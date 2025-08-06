#!/bin/bash

echo "🔨 Simple APK Build..."

# Test endpoint first
echo "Testing endpoint..."
curl -X POST https://d.seoikrom.com/api/flutter/submit-form \
  -H "Content-Type: application/json" \
  -d '{"phoneNumber":"+6281234567890","fullName":"Test User"}' \
  -s

echo -e "\n\nBuilding APK..."

# Check if Flutter exists
if [ -f "/var/www/demo/flutter/flutter/bin/flutter" ]; then
    export PATH="/var/www/demo/flutter/flutter/bin:$PATH"
    
    cd /var/www/demo
    
    # Create project if not exists
    if [ ! -d "tukangutang_app" ]; then
        flutter create tukangutang_app
    fi
    
    cd tukangutang_app
    
    # Simple main.dart
    cat > lib/main.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TukangUtang',
      theme: ThemeData(primarySwatch: Colors.green),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _loading = false;
  String _result = '';

  Future<void> _testAPI() async {
    setState(() {
      _loading = true;
      _result = '';
    });

    try {
      final response = await http.post(
        Uri.parse('https://d.seoikrom.com/api/flutter/submit-form'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'phoneNumber': '+6281234567890',
          'fullName': 'Test User',
        }),
      );

      setState(() {
        _result = 'Status: ${response.statusCode}\nResponse: ${response.body}';
      });
    } catch (e) {
      setState(() {
        _result = 'Error: $e';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('TukangUtang')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text('Klik tombol di bawah untuk test API'),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loading ? null : _testAPI,
              child: _loading ? CircularProgressIndicator() : Text('Test API'),
            ),
            SizedBox(height: 20),
            if (_result.isNotEmpty)
              Container(
                padding: EdgeInsets.all(12),
                color: Colors.grey[200],
                child: Text(_result),
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
description: "TukangUtang"
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

    # Build
    flutter clean
    flutter pub get
    flutter build apk --release
    
    # Copy
    cp build/app/outputs/flutter-apk/app-release.apk /var/www/demo/dashboard-frontend/public/tukangutang_app_release.apk
    
    echo "✅ APK built!"
    echo "📱 https://d.seoikrom.com/tukangutang_app_release.apk"
else
    echo "❌ Flutter not found"
fi 