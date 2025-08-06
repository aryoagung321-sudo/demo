#!/bin/bash

echo "🔧 Final fix for 404 error and build APK..."

cd /var/www/demo

# 1. Start all containers
echo "🚀 Starting containers..."
docker-compose up -d

# 2. Wait for containers
echo "⏳ Waiting for containers..."
sleep 15

# 3. Test endpoint
echo "🧪 Testing flutter/submit-form endpoint..."
curl -X POST http://localhost:9000/api/flutter/submit-form \
  -H "Content-Type: application/json" \
  -d '{"phoneNumber":"test123","applicationDate":"2025-08-04T22:50:00.000Z"}' \
  -w "\nHTTP Status: %{http_code}\n"

# 4. Check backend logs
echo "📋 Backend logs:"
docker-compose logs backend --tail=5

# 5. Build APK
echo "📱 Building APK..."
cd frontend
export PATH="$PATH:/var/www/demo/flutter/bin"
flutter clean
flutter pub get
flutter build apk --release

# 6. Copy APK
echo "📋 Copying APK..."
cp build/app/outputs/flutter-apk/app-release.apk ../dashboard-frontend/public/tukangutang_app_release.apk
cp build/app/outputs/flutter-apk/app-release.apk ../tukangutang_app_release.apk

# 7. Restart frontend
echo "🔄 Restarting frontend..."
cd ..
docker-compose restart frontend

# 8. Test final
echo "🧪 Final test..."
sleep 5
curl -I http://localhost:8080/tukangutang_app_release.apk

echo "✅ Complete! APK ready at: https://d.seoikrom.com/tukangutang_app_release.apk" 