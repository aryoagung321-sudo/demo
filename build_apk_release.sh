#!/bin/bash

echo "📱 BUILDING APK RELEASE - STABLE VERSION"
echo "========================================"

cd /var/www/demo

echo "📋 Setting up environment..."
export PATH="$PATH:/var/www/demo/flutter/bin"

echo "📁 Going to frontend directory..."
cd frontend

echo "🖼️ Checking icons..."
ls -la assets/icons/

echo "🧹 Deep cleaning..."
flutter clean
rm -rf build/
rm -rf .dart_tool/
rm -rf .flutter-plugins*

echo "📦 Getting dependencies..."
flutter pub get

echo "🔧 Building release APK (more stable)..."
flutter build apk --release

echo "📋 Checking result..."
if [ -f "build/app/outputs/flutter-apk/app-release.apk" ]; then
    echo "✅ Release APK built successfully!"
    echo "📁 Location: build/app/outputs/flutter-apk/app-release.apk"
    
    # Copy to demo directory
    cp build/app/outputs/flutter-apk/app-release.apk ../pinjol_app_release.apk
    echo "📋 Copied to: /var/www/demo/pinjol_app_release.apk"
    
    # Show file size
    APK_SIZE=$(du -h build/app/outputs/flutter-apk/app-release.apk | cut -f1)
    echo "📏 APK size: $APK_SIZE"
    
    # Copy to public folder for download
    cp build/app/outputs/flutter-apk/app-release.apk ../dashboard-frontend/public/pinjol_app_release.apk
    echo "📋 Copied to public folder for download"
    
    echo ""
    echo "🎉 SUCCESS! Release APK ready for installation"
    echo "📱 File: /var/www/demo/pinjol_app_release.apk"
    echo "🌐 Download URL: https://d.seoikrom.com/pinjol_app_release.apk"
    echo "💡 Note: This is a release APK, more stable for production"
    
else
    echo "❌ Release APK build failed!"
    echo "📋 Checking for any APK files..."
    find build -name "*.apk" 2>/dev/null || echo "No APK files found"
    
    exit 1
fi 