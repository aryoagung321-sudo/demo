#!/bin/bash

echo "🔨 Step by Step APK Build..."

cd /var/www/demo

echo "Step 1: Check Flutter..."
ls -la flutter/

echo "Step 2: Fix Flutter path..."
if [ -d "flutter/flutter_temp" ]; then
    mv flutter/flutter_temp flutter/flutter
fi

echo "Step 3: Set PATH..."
export PATH="/var/www/demo/flutter/flutter/bin:$PATH"

echo "Step 4: Test Flutter..."
flutter --version

echo "Step 5: Create project..."
rm -rf tukangutang_app
flutter create tukangutang_app

echo "Step 6: Enter project..."
cd tukangutang_app

echo "Step 7: Create simple main.dart..."
cat > lib/main.dart << 'EOF'
import 'package:flutter/material.dart';

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

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('TukangUtang')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Aplikasi Berjalan'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Button Setuju berfungsi!')),
                );
              },
              child: Text('Setuju dan Lanjutkan'),
            ),
          ],
        ),
      ),
    );
  }
}
EOF

echo "Step 8: Build APK..."
flutter clean
flutter pub get
flutter build apk --release

echo "Step 9: Copy APK..."
cp build/app/outputs/flutter-apk/app-release.apk /var/www/demo/dashboard-frontend/public/tukangutang_app_release.apk

echo "✅ Build completed!"
ls -la /var/www/demo/dashboard-frontend/public/tukangutang_app_release.apk 