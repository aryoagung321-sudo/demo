#!/bin/bash

echo "🔧 SETTING UP FLUTTER AND BUILDING APK"
echo "======================================"

cd /var/www/demo

echo "📁 Checking Flutter installation..."
if [ -d "flutter" ]; then
    echo "✅ Flutter directory exists"
    
    # Add Flutter to PATH
    export PATH="$PATH:/var/www/demo/flutter/bin"
    echo "🔧 Added Flutter to PATH"
    
    # Check Flutter version
    if flutter --version; then
        echo "✅ Flutter is working"
    else
        echo "❌ Flutter not working, trying to fix..."
        chmod +x flutter/bin/flutter
        chmod +x flutter/bin/dart
    fi
else
    echo "❌ Flutter directory not found!"
    echo "📥 Downloading Flutter..."
    wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.19.6-stable.tar.xz
    tar xf flutter_linux_3.19.6-stable.tar.xz
    export PATH="$PATH:/var/www/demo/flutter/bin"
fi

echo "📱 Building TukangUtang APK..."
cd frontend

echo "🧹 Cleaning previous build..."
flutter clean

echo "📦 Getting dependencies..."
flutter pub get

echo "🔧 Building release APK..."
flutter build apk --release

echo "📋 Checking build result..."
if [ -f "build/app/outputs/flutter-apk/app-release.apk" ]; then
    echo "✅ APK built successfully!"
    
    # Copy to main directory with new name
    cp build/app/outputs/flutter-apk/app-release.apk /var/www/demo/tukangutang_app_release.apk
    
    # Copy to public folder for website download
    cp build/app/outputs/flutter-apk/app-release.apk /var/www/demo/dashboard-frontend/public/tukangutang_app_release.apk
    
    # Get file size
    APK_SIZE=$(du -h /var/www/demo/tukangutang_app_release.apk | cut -f1)
    
    echo "📁 APK copied to:"
    echo "   - /var/www/demo/tukangutang_app_release.apk"
    echo "   - /var/www/demo/dashboard-frontend/public/tukangutang_app_release.apk"
    echo "📏 APK size: $APK_SIZE"
    
    # Restart frontend to apply changes
    echo "🔄 Restarting frontend..."
    cd /var/www/demo
    docker-compose restart frontend
    
    echo "🎉 SUCCESS! TukangUtang APK ready!"
    echo "📱 Download URL: https://d.seoikrom.com/tukangutang_app_release.apk"
    echo "🌐 Website: https://d.seoikrom.com"
    echo "📱 App Name: TukangUtang"
    echo "💡 Note: This is a release APK with new branding"
    
else
    echo "❌ APK build failed!"
    echo "🔍 Checking for errors..."
    flutter doctor
    exit 1
fi 