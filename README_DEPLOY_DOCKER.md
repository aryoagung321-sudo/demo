# Deploy Dashboard Admin (FastAPI + Vue.js) dengan Docker Compose

## 1. File `.env`
Simpan file berikut di root project (misal `/var/www/demo/.env`):

```dotenv
DATABASE_URL=postgresql://admin:adminpass@db:5432/demo_db
JWT_SECRET=supersecretjwtkey
VUE_APP_API_URL=https://d.seoikrom.com:9000
```

---

## 2. File `docker-compose.yml`
```yaml
version: "3.8"
services:
  backend:
    build: ./server
    env_file: .env
    volumes:
      - ./server/uploads:/app/uploads
    depends_on:
      - db
    ports:
      - "9000:9000"
    command: uvicorn main:app --host 0.0.0.0 --port 9000 --workers 2 --proxy-headers

  frontend:
    build: ./dashboard-frontend
    env_file: .env
    ports:
      - "8080:80"
    environment:
      - VUE_APP_API_URL=${VUE_APP_API_URL}

  db:
    image: postgres:15
    restart: always
    environment:
      POSTGRES_USER: admin
      POSTGRES_PASSWORD: adminpass
      POSTGRES_DB: demo_db
    volumes:
      - demo_pgdata:/var/lib/postgresql/data

volumes:
  demo_pgdata:
```

---

## 3. Script Migrasi ke PostgreSQL (alembic)
**(Opsional, jika ingin migrasi lebih lanjut – atau gunakan SQLAlchemy `Base.metadata.create_all()` otomatis)**

**a. Install Alembic**
```bash
pip install alembic psycopg2-binary
```

**b. Inisialisasi Alembic di `/server`:**
```bash
cd server
alembic init alembic
```

**c. Edit `alembic.ini`**  
Set `sqlalchemy.url = postgresql://admin:adminpass@db:5432/demo_db`

**d. Edit `alembic/env.py`:**
Ganti `target_metadata = None` menjadi:
```python
from main import Base
target_metadata = Base.metadata
```

**e. Generate migration:**
```bash
alembic revision --autogenerate -m "init"
alembic upgrade head
```
(*Setelah struktur model di main.py sudah fix, jalankan perintah di atas.*)

---

## 4. Integrasi Frontend Vue.js (axios, Pinia)

**a. axios instance** (`src/axios.js`):
```typescript
import axios from "axios";
const api = axios.create({
  baseURL: process.env.VUE_APP_API_URL || "https://d.seoikrom.com:9000",
});
api.interceptors.request.use((config) => {
  const token = localStorage.getItem("admin_token");
  if (token) config.headers.Authorization = `Bearer ${token}`;
  return config;
});
export default api;
```

**b. Pinia auth store** (`src/stores/auth.ts`):
```typescript
import { defineStore } from "pinia";
import api from "@/axios";
export const useAuthStore = defineStore("auth", {
  state: () => ({
    token: localStorage.getItem("admin_token") || "",
    user: null,
  }),
  getters: {
    isAuthenticated: (state) => !!state.token,
  },
  actions: {
    async login(username: string, password: string) {
      const res = await api.post("/api/auth/login", { username, password });
      this.token = res.data.access_token;
      localStorage.setItem("admin_token", this.token);
    },
    logout() {
      this.token = "";
      localStorage.removeItem("admin_token");
    },
  },
});
```

**c. WebSocket Vue.js**
```typescript
const ws = new WebSocket(
  `wss://d.seoikrom.com:9000/ws?token=${localStorage.getItem("admin_token")}`
);
```

---

## 5. Build & Deploy

### Build Docker Images & Run:
```bash
docker-compose up --build -d
```

### (Jika ingin rebuild/upgrade, jalankan ulang `alembic upgrade head` di backend setelah compose up)

---

## 6. Nginx (optional, production SSL)
```nginx
server {
  listen 443 ssl;
  server_name d.seoikrom.com;
  ssl_certificate /etc/letsencrypt/live/d.seoikrom.com/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/d.seoikrom.com/privkey.pem;

  location / {
    proxy_pass http://frontend:80;
  }

  location /api/ {
    proxy_pass http://backend:9000;
  }

  location /ws/ {
    proxy_pass http://backend:9000;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";
  }
}
```

---

**NOTE:**  
- `.env` digunakan baik di backend (FastAPI) maupun frontend (Vue.js).
- Ganti credentials (`adminpass`, `JWT_SECRET`) sesuai kebutuhan.
- Untuk migrasi dari SQLite ke PostgreSQL, cukup ganti `DATABASE_URL` dan jalankan alembic (atau biarkan FastAPI membuat tabel sendiri jika tidak pakai alembic).