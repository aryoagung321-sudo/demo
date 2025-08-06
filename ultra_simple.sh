#!/bin/bash

cd /var/www/demo

# Fix Flutter
if [ -d "flutter/flutter_temp" ]; then
    mv flutter/flutter_temp flutter/flutter
fi

export PATH="/var/www/demo/flutter/flutter/bin:$PATH"

flutter --version

rm -rf tukangutang_app
flutter create tukangutang_app

cd tukangutang_app

flutter clean
flutter pub get
flutter build apk --release

cp build/app/outputs/flutter-apk/app-release.apk /var/www/demo/dashboard-frontend/public/tukangutang_app_release.apk

echo "✅ APK Fixed!"
ls -la /var/www/demo/dashboard-frontend/public/tukangutang_app_release.apk 