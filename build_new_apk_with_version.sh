#!/bin/bash

echo "🚀 Building New APK with Version..."

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

# Create versioned APK name
APK_NAME="tukangutang_app_v${VERSION_CODE}.apk"

# Copy APK files
cp build/app/outputs/flutter-apk/app-release.apk "../dashboard-frontend/public/${APK_NAME}"
cp build/app/outputs/flutter-apk/app-release.apk "../dashboard-frontend/public/tukangutang_app_release.apk"

echo "✅ APK Built Successfully!"
echo "📱 Files created:"
echo "   - ${APK_NAME}"
echo "   - tukangutang_app_release.apk"

# List APK files
echo "📁 APK files in public folder:"
ls -la ../dashboard-frontend/public/*.apk

echo "🌐 Download URLs:"
echo "   - Versioned: https://d.seoikrom.com/${APK_NAME}"
echo "   - Latest: https://d.seoikrom.com/tukangutang_app_release.apk" 