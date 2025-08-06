#!/bin/bash

echo "🌐 UPDATING WEBSITE TO SHOW TUKANGUTANG APK"
echo "==========================================="

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

echo "📁 Copying APK to public folder..."
cp tukangutang_app_release.apk dashboard-frontend/public/tukangutang_app_release.apk

echo "🔧 Updating download page..."
# Remove old APK references
sed -i 's/pinjol_app_release.apk/tukangutang_app_release.apk/g' dashboard-frontend/src/views/DownloadAPK.vue
sed -i 's/Pinjol_App_v1.0.0.apk/TukangUtang_v1.0.0.apk/g' dashboard-frontend/src/views/DownloadAPK.vue
sed -i 's/Pinjol App/TukangUtang/g' dashboard-frontend/src/views/DownloadAPK.vue

echo "🔄 Restarting all containers..."
docker-compose down
sleep 5
docker-compose up -d

echo "⏳ Waiting for services to start..."
sleep 20

echo "🌐 Testing website..."
if curl -s -o /dev/null -w "%{http_code}" https://d.seoikrom.com | grep -q "200"; then
    echo "✅ Website is accessible"
else
    echo "⚠️ Website might still be starting..."
fi

echo "📱 APK Download URLs:"
echo "   - Direct: https://d.seoikrom.com/tukangutang_app_release.apk"
echo "   - Page: https://d.seoikrom.com/download"

echo "🎉 Website updated successfully!"
echo "📱 App Name: TukangUtang"
echo "📏 APK Size: $APK_SIZE"
echo "🌐 Website: https://d.seoikrom.com" 