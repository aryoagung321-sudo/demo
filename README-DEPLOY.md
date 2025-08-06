# Deploy Dashboard Admin di VPS

## Prasyarat
- Server: Ubuntu 20.04+/Debian (root/akses sudo)
- Node.js 18+ dan npm/yarn
- nginx (atau Caddy/Apache)
- Domain mengarah ke IP VPS (d.seoikrom.com)

## Instalasi Backend (REST+WebSocket)
1. **Clone Project:**
   ```bash
   ssh root@31.97.109.207
   git clone https://github.com/yourrepo/demo.git /var/www/demo
   cd /var/www/demo
   ```
2. **Install Dependencies:**
   ```bash
   cd server
   npm install
   ```
3. **Jalankan Backend:**
   ```bash
   pm2 start ws-server.js --name ws
   pm2 start user-api.js --name userapi
   pm2 start file-api.js --name fileapi
   pm2 save
   ```
   (atau gunakan `nohup node ... &` jika tidak pakai pm2)

4. **Cek backend berjalan di :9001 (WebSocket), :9002 (User API), :9003 (File API)**

## Instalasi Frontend (Vue.js)
1. **Build Production:**
   ```bash
   cd /var/www/demo/dashboard-frontend
   npm install
   npm run build
   ```
   Output ada di `/var/www/demo/dashboard-frontend/dist`

2. **Atur nginx:**
   ```
   server {
     listen 80;
     server_name d.seoikrom.com;
     root /var/www/demo/dashboard-frontend/dist;
     location / {
       try_files $uri $uri/ /index.html;
     }
     location /api/ {
       proxy_pass http://localhost:9002/;
     }
     location /api/upload {
       proxy_pass http://localhost:9003/api/upload;
     }
     location /api/files {
       proxy_pass http://localhost:9003/api/files;
     }
     location /api/download/ {
       proxy_pass http://localhost:9003/api/download/;
     }
     location /ws/ {
       proxy_pass http://localhost:9001/;
       proxy_http_version 1.1;
       proxy_set_header Upgrade $http_upgrade;
       proxy_set_header Connection "upgrade";
     }
   }
   ```
   - **Restart nginx:**
     ```bash
     sudo systemctl reload nginx
     ```

## Penggunaan
- Login di `http://d.seoikrom.com/login`
- Dashboard di `/dashboard`
- Manajemen user, file explorer, real-time, notifikasi aktif

## Catatan
- Untuk keamanan, gunakan HTTPS (Let’s Encrypt)
- Konfigurasi backend API sesuai kebutuhan nyata (ganti user-api.js, file-api.js, dsb)
- Untuk WebSocket production, gunakan wss:// (SSL)