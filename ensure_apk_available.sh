#!/bin/bash

echo "🔧 ENSURING TUKANGUTANG APK IS AVAILABLE"
echo "========================================="

cd /var/www/demo

echo "📁 Checking APK files..."
if [ -f "tukangutang_app_release.apk" ]; then
    echo "✅ Main APK file exists"
    APK_SIZE=$(du -h tukangutang_app_release.apk | cut -f1)
    echo "📏 Size: $APK_SIZE"
else
    echo "❌ Main APK file not found!"
    exit 1
fi

echo "📁 Checking public folder..."
if [ -f "dashboard-frontend/public/tukangutang_app_release.apk" ]; then
    echo "✅ Public APK file exists"
else
    echo "📋 Copying APK to public folder..."
    cp tukangutang_app_release.apk dashboard-frontend/public/tukangutang_app_release.apk
fi

echo "🔄 Restarting frontend container..."
docker-compose restart frontend

echo "⏳ Waiting for frontend to start..."
sleep 10

echo "🌐 Checking website availability..."
if curl -s -o /dev/null -w "%{http_code}" https://d.seoikrom.com | grep -q "200"; then
    echo "✅ Website is accessible"
else
    echo "⚠️ Website might be starting up..."
fi

echo "📱 APK Download URLs:"
echo "   - https://d.seoikrom.com/tukangutang_app_release.apk"
echo "   - https://d.seoikrom.com/download"

echo "🎉 TukangUtang APK should now be available!"
echo "📱 App Name: TukangUtang"
echo "📏 APK Size: $APK_SIZE"
echo "🌐 Website: https://d.seoikrom.com" 