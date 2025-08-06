#!/bin/bash

echo "🚀 Building APK Now..."

cd /var/www/demo/frontend

# Setup Flutter
export PATH="/var/www/demo/flutter/bin:$PATH"

# Build APK
flutter build apk --release

# Generate version
VERSION_CODE=$(date +"%Y%m%d_%H%M")
APK_NAME="tukangutang_app_v${VERSION_CODE}.apk"

# Copy APK
cp build/app/outputs/flutter-apk/app-release.apk "../dashboard-frontend/public/${APK_NAME}"
cp build/app/outputs/flutter-apk/app-release.apk "../dashboard-frontend/public/tukangutang_app_release.apk"

echo "✅ APK Built: ${APK_NAME}"
echo "📱 Download: https://d.seoikrom.com/${APK_NAME}" 