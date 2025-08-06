#!/bin/bash

echo "=== BUILD APK COMPLETE V2 - TUKANGUTANG APP ==="
echo "Memulai build APK dengan nama berbeda dan fitur lengkap..."

# Navigate to frontend directory
cd /var/www/demo/frontend

# Clean previous builds
echo "Membersihkan build sebelumnya..."
flutter clean

# Get dependencies
echo "Mengupdate dependencies..."
flutter pub get

# Update app name and version
echo "Mengupdate nama aplikasi dan versi..."
sed -i 's/name: tukangutang_app/name: tukangutang_app_v2/' pubspec.yaml
sed -i 's/version: 1.0.0+1/version: 2.0.0+2/' pubspec.yaml

# Update Android app ID
echo "Mengupdate Android Application ID..."
sed -i 's/applicationId "com.example.tukangutang_app"/applicationId "com.example.tukangutang_app_v2"/' android/app/build.gradle
sed -i 's/namespace "com.example.tukangutang_app"/namespace "com.example.tukangutang_app_v2"/' android/app/build.gradle

# Build APK
echo "Membangun APK release..."
flutter build apk --release

# Check if build was successful
if [ -f "build/app/outputs/flutter-apk/app-release.apk" ]; then
    echo "✅ Build APK berhasil!"
    
    # Copy to public directory with new name
    cp build/app/outputs/flutter-apk/app-release.apk /var/www/demo/dashboard-frontend/public/tukangutang_app_v2_release.apk
    
    # Get file size
    FILE_SIZE=$(du -h /var/www/demo/dashboard-frontend/public/tukangutang_app_v2_release.apk | cut -f1)
    echo "📱 APK berhasil dibuat: tukangutang_app_v2_release.apk (Size: $FILE_SIZE)"
    
    # Update download page
    echo "Mengupdate halaman download..."
    sed -i 's/tukangutang_app_release.apk/tukangutang_app_v2_release.apk/g' /var/www/demo/dashboard-frontend/public/download.html
    
    echo "🎉 APK v2 berhasil dibuild dan diupload!"
    echo "📥 Download URL: https://d.seoikrom.com/tukangutang_app_v2_release.apk"
else
    echo "❌ Build APK gagal!"
    exit 1
fi 