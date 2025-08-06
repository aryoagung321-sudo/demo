# 📦 Dokumentasi Pemasangan & Instalasi Project DEMO APK Pinjol di VPS

---

## 1. **Persiapan Server (VPS)**
- Minimal OS: Ubuntu 20.04/22.04 (rekomendasi), CentOS, atau sejenisnya
- RAM min. 2GB
- Sudah memiliki akses root/`sudo`
- Port 80 (http) dan 443 (https, opsional) terbuka

---

## 2. **Install Dependencies**

### **A. Install Git**
```bash
sudo apt update
sudo apt install git -y
```

### **B. Install Node.js & npm**  
(Jika backend atau web dashboard menggunakan Node.js)
```bash
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs
```

### **C. Install Flutter SDK**  
(Jika ingin build APK Android langsung di VPS)
```bash
sudo apt-get update
sudo apt-get install -y unzip xz-utils zip curl git
cd /opt
sudo git clone https://github.com/flutter/flutter.git -b stable
echo 'export PATH="$PATH:/opt/flutter/bin"' >> ~/.bashrc
source ~/.bashrc
flutter --version
```
> **Note:** Untuk VPS, build APK biasanya lebih efektif dilakukan di lokal (Windows/Mac/Linux), lalu upload hasil APK ke server jika ingin share.

### **D. Install PM2 (Opsional, untuk backend nodejs)**
```bash
sudo npm install -g pm2
```

---

## 3. **Clone Project**
```bash
cd /home/youruser/
git clone https://github.com/yourusername/your-pinjol-project.git
cd your-pinjol-project
```

---

## 4. **Setup Backend (Jika Ada)**
> **Contoh jika menggunakan Node.js/Express**

```bash
cd backend/
npm install
cp .env.example .env
# Edit .env sesuai kebutuhan (DB, secret, dsb)
npm run build # jika ada typescript
pm2 start npm --name pinjol-backend -- start
```

---

## 5. **Setup Frontend Web Dashboard (Jika Ada)**
> **Contoh jika menggunakan React/Vue**

```bash
cd frontend/
npm install
npm run build
# Arahkan domain/subdomain ke folder build hasilnya (bisa lewat nginx)
```

---

## 6. **Build APK Android (Opsional)**
> **Sebaiknya lakukan di laptop/PC, lalu upload APK ke VPS jika ingin file installer di-share**

```bash
cd frontend/
flutter pub get
flutter build apk --release
# Hasil: build/app/outputs/flutter-apk/app-release.apk
```

---

## 7. **Setup NGINX (Opsional, untuk reverse proxy/hosting web dashboard/API)**
```bash
sudo apt install nginx -y
sudo systemctl enable nginx
sudo systemctl start nginx
```
**Contoh konfigurasi sederhana:**
```nginx
server {
    listen 80;
    server_name your-domain.com;

    location /api/ {
        proxy_pass http://localhost:3000/; # ganti port sesuai backend
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
    location / {
        root /home/youruser/your-pinjol-project/frontend/build;
        try_files $uri $uri/ /index.html;
    }
}
```
- Simpan konfigurasi di `/etc/nginx/sites-available/pinjol` lalu symlink ke `sites-enabled`, dan reload nginx.

---

## 8. **Akses Project**
- **API/Backend:** http://your-vps-ip:3000 atau http://your-domain.com/api/
- **Dashboard Web:** http://your-domain.com/
- **APK:** Upload dan share file APK ke user (misal lewat Google Drive, direct link VPS, dst).

---

## 9. **Tips & Troubleshooting**
- Cek log aplikasi: `pm2 logs`, `journalctl`, atau `nginx -t && systemctl restart nginx`
- Pastikan port backend dan frontend tidak bentrok
- Jika pakai database (MySQL/Postgres/Mongo), pastikan sudah running dan kredensial di `.env` benar

---

## 10. **Notes**
- **Ganti `youruser`, `your-domain.com`, dan nama repo sesuai setup Anda.**
- Untuk build dan upload APK, rekomendasi lakukan di lokal, lalu upload ke VPS jika ingin distribusi file.
- Jika ada kebutuhan deployment Docker atau CI/CD, bisa ditambahkan sesuai stack Anda.

---

**Selesai!**  
Project siap dijalankan di VPS Anda 🚀

Jika butuh bantuan lebih lanjut, silakan hubungi team pengembang atau lihat README masing-masing folder (backend/frontend).