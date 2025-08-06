#!/bin/bash

set -e  # Exit on any error

echo "🚀 Robust APK Build Process..."

cd /var/www/demo

# Step 1: Setup Flutter
echo "📦 Step 1: Setting up Flutter..."
if [ ! -d "flutter/flutter" ]; then
    echo "Extracting Flutter SDK..."
    tar -xf flutter_linux_3.24.5-stable.tar.xz
    if [ -d "flutter_temp" ]; then
        mv flutter_temp flutter/flutter
    else
        mv flutter flutter_temp
        mkdir -p flutter
        mv flutter_temp flutter/
    fi
fi

export FLUTTER_ROOT=/var/www/demo/flutter/flutter
export PATH=$FLUTTER_ROOT/bin:$PATH

echo "Flutter path: $FLUTTER_ROOT"

# Step 2: Verify Flutter
echo "📋 Step 2: Verifying Flutter..."
if ! flutter --version; then
    echo "❌ Flutter not working, trying alternative setup..."
    export PATH="/var/www/demo/flutter/flutter/bin:$PATH"
    flutter --version
fi

# Step 3: Create project
echo "📱 Step 3: Creating Flutter project..."
rm -rf tukangutang_app
flutter create --org com.tukangutang --project-name tukangutang_app tukangutang_app

cd tukangutang_app

# Step 4: Update pubspec.yaml
echo "📝 Step 4: Updating dependencies..."
cat > pubspec.yaml << 'EOF'
name: tukangutang_app
description: "TukangUtang - Pinjaman Online"
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.2
  http: ^1.1.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0

flutter:
  uses-material-design: true
EOF

# Step 5: Create main.dart
echo "💻 Step 5: Creating main.dart..."
cat > lib/main.dart << 'EOF'
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TukangUtang',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: PermissionScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PermissionScreen extends StatefulWidget {
  @override
  _PermissionScreenState createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  bool _isLoading = false;
  String _message = '';

  Future<void> _handleAgree() async {
    setState(() {
      _isLoading = true;
      _message = '';
    });

    try {
      // Simulate API call
      await Future.delayed(Duration(seconds: 2));
      
      setState(() {
        _message = '✅ Berhasil! Aplikasi siap digunakan.';
      });
    } catch (e) {
      setState(() {
        _message = '❌ Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TukangUtang'),
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green[50]!, Colors.white],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20),
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.security, color: Colors.green, size: 24),
                          SizedBox(width: 8),
                          Text(
                            'Permohonan Izin',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text(
                        'TukangUtang mengumpulkan dan memproses informasi pengguna yang diperlukan sesuai dengan hukum dan peraturan yang berlaku untuk memberikan layanan pinjaman berkualitas tinggi.',
                        style: TextStyle(fontSize: 14, height: 1.5),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Kami berjanji untuk menggunakan informasi pengguna secara legal, valid, dan dengan izin, serta mengambil langkah-langkah keamanan yang ketat untuk melindungi keamanan data pengguna.',
                        style: TextStyle(fontSize: 14, height: 1.5),
                      ),
                      SizedBox(height: 16),
                      Text(
                        '1. Informasi yang Kami Kumpulkan:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.green,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text('• Informasi Pribadi: nama, nomor telepon, alamat'),
                      Text('• Informasi Identitas: foto KTP, selfie, nomor KTP'),
                      Text('• Informasi Lokasi: GPS untuk keamanan'),
                      Text('• Informasi Kontak: untuk verifikasi'),
                      Text('• Informasi Perangkat: untuk keamanan'),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              if (_message.isNotEmpty)
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _message.contains('✅') ? Colors.green[50] : Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _message.contains('✅') ? Colors.green[200]! : Colors.red[200]!,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _message.contains('✅') ? Icons.check_circle : Icons.error,
                        color: _message.contains('✅') ? Colors.green[700] : Colors.red[700],
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _message,
                          style: TextStyle(
                            color: _message.contains('✅') ? Colors.green[700] : Colors.red[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _handleAgree,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 4,
                ),
                child: _isLoading
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                          SizedBox(width: 12),
                          Text('Memproses...'),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle),
                          SizedBox(width: 8),
                          Text(
                            'Setuju dan Lanjutkan',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
EOF

# Step 6: Update Android manifest
echo "📱 Step 6: Updating Android manifest..."
cat > android/app/src/main/AndroidManifest.xml << 'EOF'
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
    <uses-permission android:name="android.permission.READ_CONTACTS" />
    <uses-permission android:name="android.permission.READ_PHONE_STATE" />
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />

    <application
        android:label="TukangUtang"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher"
        android:usesCleartextTraffic="true">
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

# Step 7: Build APK
echo "🔨 Step 7: Building APK..."
flutter clean
flutter pub get
flutter build apk --release

# Step 8: Copy APK
echo "📦 Step 8: Copying APK..."
cp build/app/outputs/flutter-apk/app-release.apk /var/www/demo/dashboard-frontend/public/tukangutang_app_release.apk

# Step 9: Verify APK
echo "✅ Step 9: Verifying APK..."
if [ -f "/var/www/demo/dashboard-frontend/public/tukangutang_app_release.apk" ]; then
    APK_SIZE=$(ls -lh /var/www/demo/dashboard-frontend/public/tukangutang_app_release.apk | awk '{print $5}')
    echo "✅ APK built successfully!"
    echo "📱 APK location: /var/www/demo/dashboard-frontend/public/tukangutang_app_release.apk"
    echo "🌐 Download URL: https://d.seoikrom.com/tukangutang_app_release.apk"
    echo "📋 APK size: $APK_SIZE"
    
    # Test if APK is valid
    if file /var/www/demo/dashboard-frontend/public/tukangutang_app_release.apk | grep -q "Android application package"; then
        echo "✅ APK validation: PASSED"
    else
        echo "⚠️  APK validation: FAILED - file may be corrupted"
    fi
else
    echo "❌ APK build failed!"
    exit 1
fi

echo "🎉 Build process completed successfully!" 