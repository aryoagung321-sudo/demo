#!/bin/bash

echo "🔧 Rebuild container dan memperbaiki download APK..."

cd /var/www/demo

# 1. Stop containers
echo "🛑 Menghentikan containers..."
docker-compose down

# 2. Rebuild frontend container
echo "🔨 Rebuild frontend container..."
docker-compose build --no-cache frontend

# 3. Start containers
echo "🚀 Menjalankan containers..."
docker-compose up -d

# 4. Tunggu container siap
echo "⏳ Menunggu container siap..."
sleep 15

# 5. Cek status
echo "📊 Status containers:"
docker-compose ps

# 6. Test akses APK
echo "🧪 Testing akses APK..."
sleep 5
curl -I http://localhost:8080/tukangutang_app_release.apk

echo "✅ Selesai! Coba akses: https://d.seoikrom.com/tukangutang_app_release.apk" 