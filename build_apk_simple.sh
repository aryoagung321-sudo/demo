#!/bin/bash

echo "📱 BUILDING APK - SIMPLE VERSION"
echo "================================"

cd /var/www/demo

echo "📋 Setting up Flutter environment..."
export PATH="$PATH:/var/www/demo/flutter/bin"

echo "📁 Going to frontend directory..."
cd frontend

echo "🖼️ Checking icons..."
ls -la assets/icons/

echo "🧹 Cleaning build..."
flutter clean

echo "📦 Getting dependencies..."
flutter pub get

echo "🔧 Building APK..."
flutter build apk --release

echo "📋 Checking result..."
if [ -f "build/app/outputs/flutter-apk/app-release.apk" ]; then
    echo "✅ APK built successfully!"
    echo "📁 Location: build/app/outputs/flutter-apk/app-release.apk"
    
    # Copy to demo directory
    cp build/app/outputs/flutter-apk/app-release.apk ../pinjol_app.apk
    echo "📋 Copied to: /var/www/demo/pinjol_app.apk"
    
    # Show file size
    APK_SIZE=$(du -h build/app/outputs/flutter-apk/app-release.apk | cut -f1)
    echo "📏 APK size: $APK_SIZE"
    
    echo ""
    echo "🎉 SUCCESS! APK ready for installation"
    echo "📱 File: /var/www/demo/pinjol_app.apk"
    
else
    echo "❌ APK build failed!"
    echo "📋 Check the error messages above"
    exit 1
fi 