#!/bin/bash

echo "🚀 Quick Test and Build APK..."

# Test endpoint first
echo "1. Testing API endpoint..."
curl -X POST https://d.seoikrom.com/api/flutter/submit-form \
  -H "Content-Type: application/json" \
  -d '{"phoneNumber":"+6281234567890","fullName":"Test User"}' \
  --max-time 10 \
  -s

echo -e "\n\n2. Checking if Flutter is available..."
if [ -d "/var/www/demo/flutter/flutter" ]; then
    echo "✅ Flutter found"
    export FLUTTER_ROOT=/var/www/demo/flutter/flutter
    export PATH=$FLUTTER_ROOT/bin:$PATH
    
    # Create simple APK
    echo "3. Creating simple APK..."
    cd /var/www/demo
    
    if [ ! -d "tukangutang_app" ]; then
        flutter create --org com.tukangutang --project-name tukangutang_app tukangutang_app
    fi
    
    cd tukangutang_app
    
    # Create simple main.dart
    cat > lib/main.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TukangUtang',
      theme: ThemeData(primarySwatch: Colors.green),
      home: PermissionScreen(),
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

  Future<void> _submitForm() async {
    setState(() {
      _isLoading = true;
      _message = '';
    });

    try {
      final response = await http.post(
        Uri.parse('https://d.seoikrom.com/api/flutter/submit-form'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'phoneNumber': '+6281234567890',
          'fullName': 'Test User',
          'email': 'test@example.com',
          'deviceModel': 'Android Device',
          'imei': '123456789012345',
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          _message = '✅ Berhasil! Data terkirim ke server.';
        });
      } else {
        setState(() {
          _message = '❌ Error: ${response.statusCode} - ${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        _message = '❌ Network Error: $e';
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
                      'TukangUtang mengumpulkan dan memproses informasi pengguna yang diperlukan sesuai dengan hukum dan peraturan yang berlaku.',
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 16),
                    Text(
                      '1. Informasi yang Kami Kumpulkan:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text('• Informasi Pribadi: nama, nomor telepon, alamat'),
                    Text('• Informasi Identitas: foto KTP, selfie'),
                    Text('• Informasi Lokasi: GPS untuk keamanan'),
                    Text('• Informasi Kontak: untuk verifikasi'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            if (_message.isNotEmpty)
              Container(
                padding: EdgeInsets.all(12),
                color: _message.contains('✅') ? Colors.green[100] : Colors.red[100],
                child: Text(
                  _message,
                  style: TextStyle(
                    color: _message.contains('✅') ? Colors.green[900] : Colors.red[900],
                  ),
                ),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _submitForm,
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
EOF

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

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0

flutter:
  uses-material-design: true
EOF

    # Build APK
    echo "4. Building APK..."
    flutter clean
    flutter pub get
    flutter build apk --release

    # Copy APK
    echo "5. Copying APK..."
    cp build/app/outputs/flutter-apk/app-release.apk /var/www/demo/dashboard-frontend/public/tukangutang_app_release.apk
    
    echo "✅ APK built successfully!"
    echo "📱 APK: https://d.seoikrom.com/tukangutang_app_release.apk"
    
else
    echo "❌ Flutter not found"
fi 