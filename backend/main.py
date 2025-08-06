# Simple FastAPI WebSocket Backend for Realtime Admin Dashboard
# Features: 
# - Accepts device data via HTTP POST (from Android background service)
# - Broadcasts updates via WebSocket to admin dashboard clients (per user)
# - In-memory, suitable for demo/POC (use DB/Redis for production)

from fastapi import FastAPI, WebSocket, WebSocketDisconnect, Request
from fastapi.responses import JSONResponse
from fastapi.middleware.cors import CORSMiddleware
import uvicorn
from typing import Dict, List
import asyncio

app = FastAPI()

# For demo: store active websocket connections per user
class ConnectionManager:
    def __init__(self):
        self.active_connections: Dict[str, List[WebSocket]] = {}

    async def connect(self, user_id: str, websocket: WebSocket):
        await websocket.accept()
        if user_id not in self.active_connections:
            self.active_connections[user_id] = []
        self.active_connections[user_id].append(websocket)

    def disconnect(self, user_id: str, websocket: WebSocket):
        self.active_connections[user_id].remove(websocket)
        if not self.active_connections[user_id]:
            del self.active_connections[user_id]

    async def send_personal_message(self, user_id: str, message: str):
        if user_id in self.active_connections:
            for conn in self.active_connections[user_id]:
                await conn.send_text(message)

manager = ConnectionManager()

# Allow CORS for local dev, change on prod!
app.add_middleware(
    CORSMiddleware,
    allow_origins=['*'],
    allow_credentials=True,
    allow_methods=['*'],
    allow_headers=['*'],
)

@app.websocket("/ws/{user_id}")
async def websocket_endpoint(websocket: WebSocket, user_id: str):
    await manager.connect(user_id, websocket)
    try:
        while True:
            await websocket.receive_text()  # ping-pong or no-op
    except WebSocketDisconnect:
        manager.disconnect(user_id, websocket)

@app.post("/device_data/{user_id}")
async def receive_device_data(user_id: str, request: Request):
    """
    Endpoint yang menerima post data dari device.
    Format JSON sesuai fitur: {"type":"gps", ...}, {"type":"contacts", ...}, dst.
    """
    data = await request.json()
    # Broadcast ke dashboard admin untuk user yang bersangkutan
    await manager.send_personal_message(user_id, request.body().decode('utf-8'))
    return JSONResponse({"status": "ok"})

# Example endpoint for dashboard to test connection
@app.get("/")
async def index():
    return {"status": "ok", "msg": "Backend WebSocket Admin Dashboard"}

if __name__ == "__main__":
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)