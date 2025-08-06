#!/bin/bash

set -e  # Exit on any error

echo "🚀 Starting APK Build Process..."
echo "📅 $(date)"

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check Flutter installation
echo "🔍 Checking Flutter installation..."
if ! command_exists flutter; then
    echo "❌ Flutter not found in PATH"
    echo "🔧 Adding Flutter to PATH..."
    export PATH="$PATH:/opt/flutter/bin"
fi

# Check if Flutter works
if ! flutter --version >/dev/null 2>&1; then
    echo "❌ Flutter not working. Checking installation..."
    if [ -f "/opt/flutter/bin/flutter" ]; then
        echo "✅ Flutter found at /opt/flutter/bin/flutter"
        export PATH="$PATH:/opt/flutter/bin"
    else
        echo "❌ Flutter not found at /opt/flutter/bin/flutter"
        exit 1
    fi
fi

echo "📱 Flutter version:"
flutter --version

# Set environment variables
export ANDROID_HOME=/opt/android-sdk
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64

echo "🔧 Environment variables set:"
echo "   ANDROID_HOME: $ANDROID_HOME"
echo "   JAVA_HOME: $JAVA_HOME"

# Navigate to frontend directory
cd /var/www/demo/frontend

echo "📁 Current directory: $(pwd)"
echo "📋 Directory contents:"
ls -la

# Check if pubspec.yaml exists
if [ ! -f "pubspec.yaml" ]; then
    echo "❌ pubspec.yaml not found!"
    exit 1
fi

echo "📦 pubspec.yaml found. Getting dependencies..."
flutter pub get

echo "🧹 Cleaning previous builds..."
flutter clean

echo "🔍 Running Flutter doctor..."
flutter doctor -v

echo "🔨 Building APK..."
flutter build apk --release

echo "✅ Build process completed!"

# Check if APK was created
APK_PATH="build/app/outputs/flutter-apk/app-release.apk"
if [ -f "$APK_PATH" ]; then
    echo "📁 APK found at: $APK_PATH"
    echo "📊 APK size: $(du -h "$APK_PATH" | cut -f1)"
    
    # Copy APK to main directory
    cp "$APK_PATH" /var/www/demo/pinjol-app.apk
    echo "🎉 APK copied to: /var/www/demo/pinjol-app.apk"
    echo "📊 Final APK size: $(du -h /var/www/demo/pinjol-app.apk | cut -f1)"
    
    # Verify APK
    echo "🔍 Verifying APK..."
    if file /var/www/demo/pinjol-app.apk | grep -q "Android application package"; then
        echo "✅ APK verification successful!"
        echo "🎉 APK is ready for installation!"
    else
        echo "⚠️  APK verification failed - file may be corrupted"
    fi
else
    echo "❌ APK not found at expected location: $APK_PATH"
    echo "📋 Checking build directory for any APK files:"
    find build -name "*.apk" 2>/dev/null || echo "No APK files found"
    exit 1
fi

echo "🏁 Build process finished at $(date)" 