#!/bin/bash

echo "📱 BUILDING APK DEBUG - SIMPLE VERSION"
echo "======================================"

cd /var/www/demo

echo "📋 Setting up environment..."
export PATH="$PATH:/var/www/demo/flutter/bin"

echo "📁 Going to frontend directory..."
cd frontend

echo "🖼️ Checking icons..."
ls -la assets/icons/

echo "🧹 Cleaning..."
flutter clean

echo "📦 Getting dependencies..."
flutter pub get

echo "🔧 Building debug APK (easier to build)..."
flutter build apk --debug

echo "📋 Checking result..."
if [ -f "build/app/outputs/flutter-apk/app-debug.apk" ]; then
    echo "✅ Debug APK built successfully!"
    echo "📁 Location: build/app/outputs/flutter-apk/app-debug.apk"
    
    # Copy to demo directory
    cp build/app/outputs/flutter-apk/app-debug.apk ../pinjol_app_debug.apk
    echo "📋 Copied to: /var/www/demo/pinjol_app_debug.apk"
    
    # Show file size
    APK_SIZE=$(du -h build/app/outputs/flutter-apk/app-debug.apk | cut -f1)
    echo "📏 APK size: $APK_SIZE"
    
    echo ""
    echo "🎉 SUCCESS! Debug APK ready for installation"
    echo "📱 File: /var/www/demo/pinjol_app_debug.apk"
    echo "💡 Note: This is a debug APK, suitable for testing"
    
else
    echo "❌ Debug APK build failed!"
    echo "📋 Checking for any APK files..."
    find build -name "*.apk" 2>/dev/null || echo "No APK files found"
    
    exit 1
fi 