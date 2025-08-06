# 📦 Panduan Deploy Dashboard Admin (FastAPI + Vue.js + PostgreSQL) di VPS

Panduan ini akan membimbing Anda dari **nol** hingga aplikasi full production berjalan di domain Anda (`d.seoikrom.com`), menggunakan Docker Compose, SSL, dan semua best-practice modern.

---

## 🛠 **A. Prasyarat VPS**

- OS: **Ubuntu 20.04/22.04** (user root atau sudo)
- Domain: `d.seoikrom.com` sudah diarahkan ke IP VPS Anda
- Port 22, 80, 443, 9000, 8080 **terbuka di firewall**
- **Belum ada aplikasi lain yang berjalan di port-port tersebut** (atau sesuaikan)

---

## 🗂 **B. Struktur Project**

Misal project di `/var/www/demo/`:
```text
/var/www/demo/
 ├── server/                # Backend FastAPI
 ├── dashboard-frontend/    # Frontend Vue.js
 ├── .env                   # Environment config
 └── docker-compose.yml     # Docker Compose setup
```

---

## 📝 **C. Konfigurasi File Lingkungan**

### 1. **File `.env`**

```dotenv
DATABASE_URL=postgresql://admin:adminpass@db:5432/demo_db
JWT_SECRET=supersecretjwtkey
VUE_APP_API_URL=https://d.seoikrom.com:9000
```

- **Ubah** password/admin sesuai keamanan Anda.

---

### 2. **File `docker-compose.yml`**

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

## ⚙️ **D. Setup Project di VPS**

### 1. **Persiapkan VPS**
```bash
sudo apt update && sudo apt install -y git docker.io docker-compose
sudo systemctl enable --now docker
```

### 2. **Clone Project**
```bash
mkdir -p /var/www/demo && cd /var/www/demo
git clone [REPO-ANDA] .
```
> **Ganti `[REPO-ANDA]` dengan URL repo Anda atau upload manual folder `server` dan `dashboard-frontend` ke VPS.**

### 3. **Buat `.env` & `docker-compose.yml`**
- Salin semua isi file `.env` dan `docker-compose.yml` di atas ke folder project.

---

## 🐳 **E. Build & Jalankan Docker Compose**

### 1. **Build & Up**
```bash
cd /var/www/demo
sudo docker-compose build
sudo docker-compose up -d
```
- Tunggu sampai semua service (`db`, `backend`, `frontend`) statusnya healthy/running.

### 2. **Cek Status**
```bash
sudo docker-compose ps
```
- Pastikan `backend`, `db`, dan `frontend` **UP**.

---

## 🗃 **F. Inisialisasi Database & Migrasi**

> **Otomatis!** Pada startup, FastAPI akan membuat tabel jika belum ada (`Base.metadata.create_all`).  
> Jika ingin migrasi manual/advance, gunakan Alembic (lihat README sebelumnya).

---

## 🔐 **G. Setup HTTPS/SSL via Nginx + Let's Encrypt**

### 1. **Install Nginx & Certbot**
```bash
sudo apt install -y nginx certbot python3-certbot-nginx
```

### 2. **Atur Nginx Reverse Proxy**
Edit `/etc/nginx/sites-available/demo`:
```nginx
server {
    server_name d.seoikrom.com;

    location /api/ {
        proxy_pass http://127.0.0.1:9000;
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    location /ws/ {
        proxy_pass http://127.0.0.1:9000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
    }

    location / {
        proxy_pass http://127.0.0.1:8080;
        proxy_set_header Host $host;
    }
}

```
Aktifkan & restart:
```bash
sudo ln -s /etc/nginx/sites-available/demo /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

### 3. **Pasang SSL LetsEncrypt**
```bash
sudo certbot --nginx -d d.seoikrom.com
```
Cek: akses https://d.seoikrom.com

---

## 🧑‍💻 **H. Testing & Penggunaan**

- **Login:** https://d.seoikrom.com/login (username: `admin`, password: `admin123` atau sesuai reset)
- **Dashboard:** https://d.seoikrom.com/dashboard
- **API:** https://d.seoikrom.com/api/users (hanya via JWT)
- **WebSocket:** wss://d.seoikrom.com/ws?token=JWT_TOKEN
- **File Explorer:** Dashboard > File, upload file gambar <=5MB (jpg/png/jpeg)
- **Monitoring Backend:** https://d.seoikrom.com/api/monitoring (via JWT)

---

## 🌟 **I. Maintenance & Customisasi**

- **Ganti password admin:** via endpoint reset, atau update langsung di DB.
- **Ganti JWT_SECRET:** update di `.env`, restart backend.
- **Backup data:** backup volume `demo_pgdata` dan folder `uploads`.
- **Update code:**  
  ```bash
  git pull
  sudo docker-compose build
  sudo docker-compose up -d
  ```

---

## 🚩 **J. Troubleshooting**

- Cek log service:
  ```bash
  sudo docker-compose logs backend
  sudo docker-compose logs frontend
  ```
- Gunakan `docker exec -it <container> bash` untuk debug langsung.
- Cek nginx error di `/var/log/nginx/error.log`

---

## 📚 **K. Fitur Keamanan & Production**

- Semua endpoint REST & WebSocket **wajib JWT**.
- Rate limit sudah aktif (slowapi).
- Audit log login, CRUD, upload.
- File upload hanya gambar, max 5MB.
- Gunakan HTTPS (`wss` untuk WebSocket).
- Admin dapat reset password.
- Database terpisah (PostgreSQL, bukan memory).

---

## 📄 **L. File Penting**

- `.env` — konfigurasi rahasia (jangan upload ke repo publik)
- `docker-compose.yml` — setup seluruh stack
- `/server/main.py` — kode backend utama
- `/dashboard-frontend/` — kode frontend Vue.js

---

## 🎉 **SELESAI**

Aplikasi dashboard admin siap production di https://d.seoikrom.com  
Silakan custom fitur, tema, atau keamanan sesuai kebutuhan bisnis Anda.

---

**Jika ada error, copy log/error-nya ke sini, saya bantu troubleshooting!**