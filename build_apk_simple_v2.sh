#!/bin/bash

echo "🚀 Building APK Simple v2..."

cd /var/www/demo

# Generate version
VERSION_CODE=$(date +"%Y%m%d_%H%M")
echo "📱 Version: v1.0.${VERSION_CODE}"

# Build APK
cd frontend
export PATH="/var/www/demo/flutter/bin:$PATH"
flutter build apk --release

# Copy APK with version
APK_NAME="tukangutang_app_v${VERSION_CODE}.apk"
cp build/app/outputs/flutter-apk/app-release.apk "../dashboard-frontend/public/${APK_NAME}"
cp build/app/outputs/flutter-apk/app-release.apk "../dashboard-frontend/public/tukangutang_app_release.apk"

echo "✅ APK Built: ${APK_NAME}"
echo "📱 Download: https://d.seoikrom.com/${APK_NAME}" 