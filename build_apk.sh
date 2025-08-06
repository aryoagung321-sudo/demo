#!/bin/bash

# Script untuk build APK Flutter
echo "🚀 Starting APK Build Process..."

# Set environment variables
export PATH="$PATH:/opt/flutter/bin"
export ANDROID_HOME=/opt/android-sdk
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64

# Navigate to frontend directory
cd /var/www/demo/frontend

echo "📱 Checking Flutter installation..."
if ! flutter --version; then
    echo "❌ Flutter not found. Please install Flutter first."
    exit 1
fi

echo "🔧 Setting up Flutter for Android..."
flutter config --android-sdk /opt/android-sdk

echo "🧹 Cleaning previous builds..."
flutter clean

echo "📦 Getting Flutter dependencies..."
if ! flutter pub get; then
    echo "❌ Failed to get dependencies"
    exit 1
fi

echo "🔍 Checking Flutter doctor..."
flutter doctor -v

echo "🔨 Building APK..."
if ! flutter build apk --release; then
    echo "❌ APK build failed"
    echo "📋 Checking build logs..."
    flutter logs
    exit 1
fi

echo "✅ APK Build completed!"

# Check if APK was created
APK_PATH="/var/www/demo/frontend/build/app/outputs/flutter-apk/app-release.apk"
if [ -f "$APK_PATH" ]; then
    echo "📁 APK location: $APK_PATH"
    echo "📊 APK size: $(du -h "$APK_PATH" | cut -f1)"
    
    # Copy APK to accessible location
    cp "$APK_PATH" /var/www/demo/pinjol-app.apk
    echo "🎉 APK ready at: /var/www/demo/pinjol-app.apk"
    echo "📊 Final APK size: $(du -h /var/www/demo/pinjol-app.apk | cut -f1)"
    
    # Verify APK integrity
    echo "🔍 Verifying APK..."
    if file /var/www/demo/pinjol-app.apk | grep -q "Android application package"; then
        echo "✅ APK verification successful"
    else
        echo "⚠️  APK verification failed - file may be corrupted"
    fi
else
    echo "❌ APK not found at expected location: $APK_PATH"
    echo "📋 Available files in build directory:"
    find /var/www/demo/frontend/build -name "*.apk" 2>/dev/null || echo "No APK files found"
    exit 1
fi 