#!/bin/bash

echo "🔄 Updating Download Page..."

cd /var/www/demo

# Update APK info in download.html
echo "1. Updating APK info..."
sed -i 's/26 MB/18 MB/g' dashboard-frontend/public/download.html

# Copy updated files to container
echo "2. Copying files to container..."
docker cp dashboard-frontend/public/download.html demo_frontend_1:/usr/share/nginx/html/download.html
docker cp tukangutang_app/build/app/outputs/flutter-apk/app-release.apk demo_frontend_1:/usr/share/nginx/html/tukangutang_app_release.apk

# Verify files
echo "3. Verifying files..."
echo "APK size in container:"
docker exec demo_frontend_1 ls -lh /usr/share/nginx/html/tukangutang_app_release.apk

echo "Download page updated:"
docker exec demo_frontend_1 ls -lh /usr/share/nginx/html/download.html

echo "✅ Download page updated successfully!"
echo "📱 APK: https://d.seoikrom.com/tukangutang_app_release.apk"
echo "🌐 Download page: https://d.seoikrom.com/download" 