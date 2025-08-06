#!/bin/bash

echo "🔧 Building and fixing APK with error corrections..."

cd /var/www/demo

# 1. Start containers
echo "🚀 Starting containers..."
docker-compose up -d

# 2. Wait for containers to be ready
echo "⏳ Waiting for containers..."
sleep 10

# 3. Build APK
echo "📱 Building APK..."
cd frontend
export PATH="$PATH:/var/www/demo/flutter/bin"
flutter clean
flutter pub get
flutter build apk --release

# 4. Copy APK to public folder
echo "📋 Copying APK..."
cp build/app/outputs/flutter-apk/app-release.apk ../dashboard-frontend/public/tukangutang_app_release.apk
cp build/app/outputs/flutter-apk/app-release.apk ../tukangutang_app_release.apk

# 5. Restart frontend to serve new APK
echo "🔄 Restarting frontend..."
cd ..
docker-compose restart frontend

# 6. Test
echo "🧪 Testing..."
sleep 5
curl -I http://localhost:8080/tukangutang_app_release.apk

echo "✅ APK build and deploy complete!"
echo "📱 Download: https://d.seoikrom.com/tukangutang_app_release.apk" 