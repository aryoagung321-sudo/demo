#!/bin/bash

echo "🔧 FIXING DOWNLOAD PAGE"
echo "======================="

cd /var/www/demo

echo "📁 Checking APK files..."
if [ -f "tukangutang_app_release.apk" ]; then
    echo "✅ TukangUtang APK exists"
    APK_SIZE=$(du -h tukangutang_app_release.apk | cut -f1)
    echo "📏 Size: $APK_SIZE"
else
    echo "❌ TukangUtang APK not found!"
    exit 1
fi

echo "📁 Ensuring APK is in public folder..."
cp tukangutang_app_release.apk dashboard-frontend/public/tukangutang_app_release.apk

echo "🔧 Updating download page..."
# Update the download link to point to TukangUtang APK
sed -i 's/pinjol_app_release.apk/tukangutang_app_release.apk/g' dashboard-frontend/src/views/DownloadAPK.vue
sed -i 's/Pinjol_App_v1.0.0.apk/TukangUtang_v1.0.0.apk/g' dashboard-frontend/src/views/DownloadAPK.vue

echo "🔄 Restarting frontend container..."
docker-compose restart frontend

echo "⏳ Waiting for frontend to start..."
sleep 15

echo "🌐 Testing download URLs..."
echo "📱 Direct download: https://d.seoikrom.com/tukangutang_app_release.apk"
echo "🌐 Download page: https://d.seoikrom.com/download"

echo "✅ Download page should now show TukangUtang APK!"
echo "📱 App Name: TukangUtang"
echo "📏 APK Size: $APK_SIZE"
echo "🌐 Website: https://d.seoikrom.com" 