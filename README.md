# Pinjol UangMaju - Dokumentasi Instalasi & Deploy

## Persyaratan
- VPS (misal: 31.97.109.207)
- Domain: d.seoikrom.com (point ke IP VPS)
- Node.js 18.x atau terbaru
- MySQL/Postgres (pilih salah satu, default: MySQL)
- Nginx (reverse proxy)
- Flutter SDK (untuk build APK Android)

---

## Instalasi Backend (Node.js/Express)

1. **Clone repository**
    ```bash
    git clone https://github.com/yourusername/pinjol-app.git
    cd pinjol-app/backend
    ```

2. **Install dependencies**
    ```bash
    npm install
    ```

3. **Setting .env**
    ```
    PORT=3000
    DB_HOST=localhost
    DB_USER=root
    DB_PASS=yourpassword
    DB_NAME=pinjol_db
    JWT_SECRET=your_jwt_secret
    ```

4. **Migrasi Database**
    - Import file SQL (akan disediakan di folder backend/db/)
    - Jalankan: `mysql -u root -p pinjol_db < backend/db/schema.sql`

5. **Jalankan Backend**
    ```
    npm start
    ```

---

## Instalasi Frontend (Flutter Android)

1. **Masuk ke folder frontend**
    ```bash
    cd ../frontend
    ```

2. **Install dependencies**
    ```
    flutter pub get
    ```

3. **Build APK**
    ```
    flutter build apk --release
    ```

4. **Ambil file APK di:** `build/app/outputs/flutter-apk/app-release.apk`
5. **Install ke perangkat Android**

---

## Setting Nginx (Reverse Proxy)

### Contoh konfigurasi:

```
server {
    server_name d.seoikrom.com;

    location /api/ {
        proxy_pass http://localhost:3000/api/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
    location / {
        root /var/www/html/; # jika ingin frontend web, jika tidak bisa kosongkan
        try_files $uri $uri/ =404;
    }
}
```

Restart nginx:
```
sudo systemctl restart nginx
```

---

## Alur Penggunaan

1. **User Registrasi**  
   Mengisi form: Nama, NIK, Alamat lengkap, Provinsi, Kota, Kecamatan, Kelurahan, No. HP, Email, No. Rekening, Bank (dropdown), dsb.

2. **Permission Android**  
   Setelah mengisi No. HP, aplikasi meminta izin lokasi, kontak, log panggilan, file manager, IMEI, status online/offline, merk & tipe HP.

3. **Pilih Produk Pinjaman**  
   User memilih nominal (1-5 juta) dan tenor (7-14 hari).

4. **Admin Dashboard**  
   Admin login ke dashboard (akses via browser ke /admin), bisa melihat daftar user, data pinjaman, approve/reject, dsb.

---

## Keamanan

- Selalu gunakan HTTPS pada VPS & domain.
- Pastikan backend tidak expose credential sensitif.
- Gunakan JWT untuk autentikasi user & admin.

---

## Catatan

- Untuk implementasi permission Android, gunakan plugin Flutter berikut:  
  - `permission_handler`
  - `device_info_plus`
  - `contacts_service`
  - `imei_plugin`

- Untuk backend, gunakan JWT dan bcrypt untuk keamanan data user.