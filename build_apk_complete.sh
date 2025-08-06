#!/bin/bash

echo "🚀 Setup Flutter dan Build APK TukangUtang..."

cd /var/www/demo

# 1. Extract Flutter jika belum ada
if [ ! -d "flutter" ]; then
    echo "📦 Extracting Flutter SDK..."
    tar -xf flutter_linux_3.24.5-stable.tar.xz
fi

# 2. Setup environment
export PATH="$PATH:/var/www/demo/flutter/bin"
export ANDROID_HOME="/var/www/demo/android-sdk"
export JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"

# 3. Setup Flutter
echo "🔧 Setting up Flutter..."
flutter/bin/flutter config --no-analytics
flutter/bin/flutter doctor

# 4. Build APK
echo "📱 Building APK..."
cd frontend
flutter/bin/flutter clean
flutter/bin/flutter pub get
flutter/bin/flutter build apk --release

# 5. Copy APK to public folder
echo "📋 Copying APK to public folder..."
cp build/app/outputs/flutter-apk/app-release.apk ../dashboard-frontend/public/tukangutang_app_release.apk
cp build/app/outputs/flutter-apk/app-release.apk ../tukangutang_app_release.apk

echo "✅ APK Build Complete!"
echo "📁 APK Location: /var/www/demo/tukangutang_app_release.apk"
echo "📁 Public Location: /var/www/demo/dashboard-frontend/public/tukangutang_app_release.apk" 