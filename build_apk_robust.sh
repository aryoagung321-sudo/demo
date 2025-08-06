#!/bin/bash

echo "📱 BUILDING APK - ROBUST VERSION"
echo "================================"

cd /var/www/demo

echo "📋 Setting up environment..."
export PATH="$PATH:/var/www/demo/flutter/bin"
export ANDROID_HOME=/opt/android-sdk
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64

echo "📁 Going to frontend directory..."
cd frontend

echo "🖼️ Checking icons..."
ls -la assets/icons/

echo "🧹 Deep cleaning..."
flutter clean
rm -rf build/
rm -rf .dart_tool/
rm -rf .flutter-plugins
rm -rf .flutter-plugins-dependencies

echo "📦 Getting dependencies..."
flutter pub get

echo "🔧 Checking Flutter doctor..."
flutter doctor

echo "🔨 Building APK with verbose output..."
flutter build apk --release --verbose

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
    echo "📋 Checking for APK files..."
    find build -name "*.apk" 2>/dev/null || echo "No APK files found"
    
    echo "📋 Checking build logs..."
    if [ -d "build/app/outputs/logs" ]; then
        echo "Last 20 lines of build logs:"
        tail -20 build/app/outputs/logs/build-time-*.log 2>/dev/null || echo "No build logs found"
    fi
    
    exit 1
fi 