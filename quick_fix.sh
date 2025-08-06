#!/bin/bash

echo "🚀 Quick Fix APK Error..."

cd /var/www/demo

# Step 1: Fix Flutter
echo "1. Fixing Flutter..."
if [ -d "flutter/flutter_temp" ]; then
    mv flutter/flutter_temp flutter/flutter
fi

# Step 2: Set PATH
export PATH="/var/www/demo/flutter/flutter/bin:$PATH"

# Step 3: Test Flutter
echo "2. Testing Flutter..."
flutter --version

# Step 4: Create project
echo "3. Creating project..."
rm -rf tukangutang_app
flutter create tukangutang_app

# Step 5: Build
echo "4. Building APK..."
cd tukangutang_app
flutter clean
flutter pub get
flutter build apk --release

# Step 6: Copy
echo "5. Copying APK..."
cp build/app/outputs/flutter-apk/app-release.apk /var/www/demo/dashboard-frontend/public/tukangutang_app_release.apk

echo "✅ APK Fixed!"
ls -la /var/www/demo/dashboard-frontend/public/tukangutang_app_release.apk 