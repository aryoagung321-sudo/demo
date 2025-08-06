import os
import shutil
import time
from typing import List, Optional

from fastapi import FastAPI, HTTPException, status, Depends, UploadFile, File, Form, WebSocket, WebSocketDisconnect, Request
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from fastapi.responses import FileResponse
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from pydantic import BaseModel
from sqlalchemy import create_engine, Column, Integer, String, Enum, select, DateTime, func
from sqlalchemy.orm import declarative_base, sessionmaker, Session
import jwt
from passlib.context import CryptContext
from slowapi import Limiter, _rate_limit_exceeded_handler
from slowapi.util import get_remote_address
from fastapi_limiter.depends import RateLimiter
import psutil

DATABASE_URL = os.getenv("DATABASE_URL", "sqlite:///./appdb.sqlite3")
JWT_SECRET = os.getenv("JWT_SECRET", "supersecretjwtkey")
UPLOAD_DIR = "./uploads"
os.makedirs(UPLOAD_DIR, exist_ok=True)

# --- SQLAlchemy setup ---
Base = declarative_base()
engine = create_engine(DATABASE_URL, connect_args={"check_same_thread": False} if "sqlite" in DATABASE_URL else {})
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

class User(Base):
    __tablename__ = "users"
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String)
    phone = Column(String, unique=True)
    status = Column(String, default="active")

class Admin(Base):
    __tablename__ = "admins"
    id = Column(Integer, primary_key=True, index=True)
    username = Column(String, unique=True)
    password_hash = Column(String)

class Log(Base):
    __tablename__ = "logs"
    id = Column(Integer, primary_key=True, index=True)
    timestamp = Column(DateTime, default=func.now())
    event = Column(String)
    username = Column(String)
    ip = Column(String)

Base.metadata.create_all(bind=engine)

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/api/auth/login")

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

def create_admin_default():
    db = SessionLocal()
    if not db.query(Admin).filter_by(username="admin").first():
        admin = Admin(username="admin", password_hash=pwd_context.hash("admin123"))
        db.add(admin)
        db.commit()
    db.close()
create_admin_default()

def create_access_token(data: dict, expires_in=3600):
    payload = data.copy()
    payload.update({"exp": int(time.time()) + expires_in})
    return jwt.encode(payload, JWT_SECRET, algorithm="HS256")

def verify_token(token: str):
    try:
        return jwt.decode(token, JWT_SECRET, algorithms=["HS256"])
    except Exception:
        raise HTTPException(status_code=401, detail="Invalid or expired token")

def get_current_admin(token: str = Depends(oauth2_scheme), db: Session = Depends(get_db)):
    payload = verify_token(token)
    admin = db.query(Admin).filter_by(username=payload.get("sub")).first()
    if not admin:
        raise HTTPException(status_code=401, detail="Admin not found")
    return admin

# --- FastAPI app ---
app = FastAPI()
app.add_middleware(CORSMiddleware,
    allow_origins=["*"], allow_credentials=True,
    allow_methods=["*"], allow_headers=["*"]
)

# --- Rate limiter ---
limiter = Limiter(key_func=get_remote_address)
app.state.limiter = limiter
app.add_exception_handler(429, _rate_limit_exceeded_handler)

# --- API Models ---
class UserModel(BaseModel):
    id: Optional[int]
    name: str
    phone: str
    status: str

class LoginModel(BaseModel):
    username: str
    password: str

class ResetPWModel(BaseModel):
    username: str
    old_password: str
    new_password: str

# --- Auth ---
@app.post("/api/auth/login")
@limiter.limit("10/minute")
def login(form_data: OAuth2PasswordRequestForm = Depends(), db: Session = Depends(get_db), request: Request = None):
    admin = db.query(Admin).filter_by(username=form_data.username).first()
    if not admin or not pwd_context.verify(form_data.password, admin.password_hash):
        raise HTTPException(status_code=401, detail="Username atau password salah!")
    token = create_access_token({"sub": admin.username})
    db.add(Log(event="login", username=admin.username, ip=request.client.host))
    db.commit()
    return {"access_token": token, "token_type": "bearer"}

# --- Reset password admin ---
@app.post("/api/auth/reset-password")
def reset_password(data: ResetPWModel, db: Session = Depends(get_db), token: str = Depends(oauth2_scheme)):
    payload = verify_token(token)
    admin = db.query(Admin).filter_by(username=data.username).first()
    if not admin or not pwd_context.verify(data.old_password, admin.password_hash):
        raise HTTPException(status_code=401, detail="Password lama salah!")
    admin.password_hash = pwd_context.hash(data.new_password)
    db.commit()
    return {"ok": True}

# --- User CRUD ---
@app.get("/api/users", response_model=List[UserModel])
def get_users(db: Session = Depends(get_db), _: Admin = Depends(get_current_admin)):
    return db.query(User).all()

@app.post("/api/users", response_model=UserModel)
def add_user(user: UserModel, db: Session = Depends(get_db), _: Admin = Depends(get_current_admin)):
    user_db = User(name=user.name, phone=user.phone, status=user.status)
    db.add(user_db)
    db.commit()
    db.refresh(user_db)
    db.add(Log(event="add_user", username="admin", ip=""))
    db.commit()
    return user_db

@app.put("/api/users/{user_id}", response_model=UserModel)
def edit_user(user_id: int, user: UserModel, db: Session = Depends(get_db), _: Admin = Depends(get_current_admin)):
    user_db = db.query(User).filter_by(id=user_id).first()
    if not user_db:
        raise HTTPException(status_code=404, detail="User not found")
    user_db.name = user.name
    user_db.phone = user.phone
    user_db.status = user.status
    db.commit()
    db.add(Log(event="edit_user", username="admin", ip=""))
    db.commit()
    return user_db

@app.delete("/api/users/{user_id}")
def delete_user(user_id: int, db: Session = Depends(get_db), _: Admin = Depends(get_current_admin)):
    db.query(User).filter_by(id=user_id).delete()
    db.commit()
    db.add(Log(event="delete_user", username="admin", ip=""))
    db.commit()
    return {"ok": True}

# --- File Explorer (jpg, jpeg, png, max 5MB) ---
@app.get("/api/files")
def list_files(_: Admin = Depends(get_current_admin)):
    return [{"name": f} for f in os.listdir(UPLOAD_DIR) if os.path.isfile(os.path.join(UPLOAD_DIR, f))]

@app.post("/api/upload")
def upload_file(file: UploadFile = File(...), _: Admin = Depends(get_current_admin)):
    if not file.filename.lower().endswith(('.jpg', '.jpeg', '.png')):
        raise HTTPException(400, "File harus gambar jpg/jpeg/png")
    if file.spool_max_size > 5*1024*1024:
        raise HTTPException(400, "Ukuran file maksimal 5MB")
    dest_path = os.path.join(UPLOAD_DIR, file.filename)
    with open(dest_path, "wb") as buffer:
        shutil.copyfileobj(file.file, buffer)
    return {"ok": True, "filename": file.filename}

@app.get("/api/download/{filename}")
def download_file(filename: str, _: Admin = Depends(get_current_admin)):
    file_path = os.path.join(UPLOAD_DIR, filename)
    if os.path.isfile(file_path):
        return FileResponse(file_path, filename=filename)
    raise HTTPException(404, "File tidak ditemukan")

# --- Monitoring Resource Backend ---
@app.get("/api/monitoring")
def resource_monitoring(_: Admin = Depends(get_current_admin)):
    return {
        "cpu_percent": psutil.cpu_percent(),
        "ram_used": psutil.virtual_memory().used // (1024*1024),
        "ram_total": psutil.virtual_memory().total // (1024*1024),
        "disk_used": psutil.disk_usage('/').used // (1024*1024),
        "disk_total": psutil.disk_usage('/').total // (1024*1024),
        "uptime": time.time() - psutil.boot_time(),
    }

# --- WebSocket (protected by token query param) ---
from fastapi import Query
from fastapi.concurrency import run_in_threadpool
import asyncio
import random

class WSManager:
    def __init__(self): self.active: List[WebSocket] = []
    async def connect(self, ws: WebSocket): await ws.accept(); self.active.append(ws)
    def disconnect(self, ws: WebSocket): self.active.remove(ws)
    async def broadcast(self, message: dict): 
        for ws in self.active:
            try: await ws.send_json(message)
            except: pass

wsmanager = WSManager()

@app.websocket("/ws")
async def ws_dashboard(websocket: WebSocket, token: str = Query(...)):
    # Token validation
    try:
        verify_token(token)
    except Exception:
        await websocket.close(code=4403)
        return
    await wsmanager.connect(websocket)
    try:
        while True:
            await asyncio.sleep(1)
    except WebSocketDisconnect:
        wsmanager.disconnect(websocket)

async def push_stats():
    while True:
        await wsmanager.broadcast({
            "type": "stats",
            "online": random.randint(4, 12),
            "timestamp": int(time.time()),
        })
        if random.random() > 0.7:
            await wsmanager.broadcast({
                "type": "notification",
                "msg": "Ada aktivitas baru di dashboard!"
            })
        await asyncio.sleep(5)

@app.on_event("startup")
async def start_stats():
    asyncio.create_task(push_stats())

app.mount("/uploads", StaticFiles(directory=UPLOAD_DIR), name="uploads")

# --- MAIN ---
if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="0.0.0.0", port=9000, reload=True)