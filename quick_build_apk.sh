#!/bin/bash

echo "🚀 Quick APK Build with Versioning..."

cd /var/www/demo

# Generate version
VERSION_CODE=$(date +"%Y%m%d_%H%M")
VERSION_NAME="v1.0.${VERSION_CODE}"

echo "📱 Building version: ${VERSION_NAME}"

# Setup Flutter
export PATH="/var/www/demo/flutter/bin:$PATH"

# Build APK
cd frontend
flutter clean
flutter pub get
flutter build apk --release

# Copy APK with version
APK_NAME="tukangutang_app_v${VERSION_CODE}.apk"
cp build/app/outputs/flutter-apk/app-release.apk "../dashboard-frontend/public/${APK_NAME}"
cp build/app/outputs/flutter-apk/app-release.apk "../dashboard-frontend/public/tukangutang_app_release.apk"

echo "✅ APK Built: ${APK_NAME}"
echo "📱 Download: https://d.seoikrom.com/${APK_NAME}" 