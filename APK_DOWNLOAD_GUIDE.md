# 📱 PANDUAN DOWNLOAD APK - PINJOL APP

## ✅ Status: APK Siap Didownload

### 🌐 URL Download

**Website Utama**: https://d.seoikrom.com
- **Landing Page**: https://d.seoikrom.com/ (Halaman utama dengan informasi lengkap)
- **Halaman Download**: https://d.seoikrom.com/download (Halaman khusus download)
- **Dashboard Admin**: https://d.seoikrom.com/dashboard (Panel admin)

### 📥 Cara Download APK

#### **Metode 1: Melalui Website**
1. Buka browser dan kunjungi: **https://d.seoikrom.com**
2. Klik tombol **"📱 Download APK"** di halaman utama
3. Atau langsung ke: **https://d.seoikrom.com/download**
4. Klik tombol **"📱 Download APK"** di halaman download
5. File akan otomatis terdownload dengan nama: `Pinjol_App_v1.0.0.apk`

#### **Metode 2: Direct Download**
- **URL Langsung**: https://d.seoikrom.com/pinjol_app_debug.apk
- File akan langsung terdownload

### 📱 Informasi APK

- **Nama File**: `pinjol_app_debug.apk`
- **Ukuran**: 148 MB (154,191,340 bytes)
- **Versi**: 1.0.0 (Debug)
- **Platform**: Android 5.0+
- **Build Date**: 4 Agustus 2024

### 🔧 Cara Install APK

#### **Langkah 1: Enable Unknown Sources**
1. Buka **Settings** di Android
2. Pilih **Security** atau **Privacy**
3. Aktifkan **"Unknown Sources"** atau **"Install unknown apps"**
4. Pilih browser yang akan digunakan untuk install

#### **Langkah 2: Install APK**
1. Buka **File Manager** atau **Downloads**
2. Cari file `Pinjol_App_v1.0.0.apk`
3. Tap file APK
4. Klik **"Install"**
5. Tunggu proses instalasi selesai
6. Klik **"Open"** untuk menjalankan aplikasi

### 🎯 Fitur Aplikasi

#### **Fitur User (Mobile App)**
- ✅ Registrasi dengan foto KTP & Selfie
- ✅ Input data pinjaman lengkap
- ✅ GPS tracking otomatis
- ✅ Upload dokumen
- ✅ Interface yang user-friendly

#### **Fitur Admin (Web Dashboard)**
- ✅ Monitoring user real-time
- ✅ View foto KTP/Selfie
- ✅ GPS tracking dengan peta
- ✅ Manajemen data pinjaman
- ✅ Export data
- ✅ Sistem keamanan

### 🔐 Login Admin Dashboard

- **URL**: https://d.seoikrom.com/dashboard
- **Username**: cs@toolspinjonterbaru.org
- **Password**: Habibhassan123@

### 📊 Status Server

- ✅ **Backend**: Node.js server running (port 9000)
- ✅ **Frontend**: Vue.js dashboard running (port 8080)
- ✅ **Database**: PostgreSQL running (port 5432)
- ✅ **SSL**: Let's Encrypt configured
- ✅ **Domain**: d.seoikrom.com active
- ✅ **APK**: Available for download

### 🚨 Troubleshooting

#### **APK Tidak Bisa Diinstall**
1. Pastikan "Unknown Sources" sudah diaktifkan
2. Cek storage space di device (minimal 200MB)
3. Restart device jika perlu
4. Download ulang APK jika file corrupt

#### **Website Tidak Bisa Diakses**
1. Cek koneksi internet
2. Coba akses dengan browser berbeda
3. Clear cache browser
4. Cek status server: `docker-compose ps`

#### **Login Admin Gagal**
1. Pastikan username dan password benar
2. Cek koneksi internet
3. Clear browser cache
4. Coba browser incognito/private

### 📞 Support

Jika ada masalah:
1. Cek status server: `docker-compose ps`
2. Cek logs: `docker-compose logs`
3. Restart service: `docker-compose restart`
4. Rebuild jika perlu: `docker-compose build --no-cache`

### 🔄 Update APK

Untuk update APK:
1. Build APK baru: `./build_apk_debug.sh`
2. Copy ke public folder: `cp pinjol_app_debug.apk dashboard-frontend/public/`
3. Rebuild frontend: `docker-compose build --no-cache frontend`
4. Restart: `docker-compose up -d`

---
**Server IP**: 31.97.109.207
**Domain**: d.seoikrom.com
**Build Location**: /var/www/demo
**Last Updated**: 4 Agustus 2024 