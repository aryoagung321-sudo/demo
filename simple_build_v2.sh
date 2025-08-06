#!/bin/bash

echo "=== SIMPLE BUILD APK V2 ==="

# Navigate to frontend
cd /var/www/demo/frontend

# Clean and get dependencies
flutter clean
flutter pub get

# Build APK
echo "Building APK..."
flutter build apk --release

# Copy to public directory
if [ -f "build/app/outputs/flutter-apk/app-release.apk" ]; then
    cp build/app/outputs/flutter-apk/app-release.apk /var/www/demo/dashboard-frontend/public/tukangutang_app_v2_release.apk
    echo "✅ APK v2 berhasil dibuat!"
    echo "📱 File: tukangutang_app_v2_release.apk"
    echo "📥 URL: https://d.seoikrom.com/tukangutang_app_v2_release.apk"
else
    echo "❌ Build gagal!"
fi 