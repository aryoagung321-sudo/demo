#!/bin/bash

echo "🔧 Memperbaiki Error 502..."

cd /var/www/demo

# 1. Stop semua containers
echo "🛑 Stopping containers..."
docker-compose down

# 2. Copy APK ke public folder
echo "📱 Copying APK to public folder..."
cp tukangutang_app_release.apk dashboard-frontend/public/

# 3. Start containers
echo "🚀 Starting containers..."
docker-compose up -d

# 4. Tunggu containers siap
echo "⏳ Waiting for containers to be ready..."
sleep 15

# 5. Cek status
echo "📊 Container status:"
docker-compose ps

# 6. Test website
echo "🧪 Testing website..."
sleep 5
curl -I http://localhost:8080

# 7. Test APK download
echo "📱 Testing APK download..."
curl -I http://localhost:8080/tukangutang_app_release.apk

echo "✅ Fix complete! Try accessing: https://d.seoikrom.com/" 