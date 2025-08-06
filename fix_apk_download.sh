#!/bin/bash

echo "🔧 Memperbaiki masalah download APK..."

# 1. Pastikan file APK ada di public folder
echo "📱 Memastikan file APK tersedia..."
if [ ! -f "/var/www/demo/dashboard-frontend/public/tukangutang_app_release.apk" ]; then
    echo "❌ File APK tidak ditemukan, menyalin dari direktori utama..."
    cp /var/www/demo/tukangutang_app_release.apk /var/www/demo/dashboard-frontend/public/
fi

# 2. Set permission yang benar
echo "🔐 Mengatur permission file..."
chmod 644 /var/www/demo/dashboard-frontend/public/tukangutang_app_release.apk

# 3. Restart container frontend
echo "🔄 Restart container frontend..."
cd /var/www/demo
docker-compose restart frontend

# 4. Tunggu container siap
echo "⏳ Menunggu container siap..."
sleep 10

# 5. Cek status container
echo "📊 Status container:"
docker-compose ps

# 6. Test akses file
echo "🧪 Testing akses file APK..."
curl -I http://localhost:8080/tukangutang_app_release.apk

echo "✅ Selesai! Coba akses: https://d.seoikrom.com/tukangutang_app_release.apk" 