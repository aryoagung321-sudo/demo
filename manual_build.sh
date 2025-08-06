#!/bin/bash

echo "🔨 Manual APK Build..."

cd /var/www/demo

# Fix Flutter structure
echo "1. Fixing Flutter structure..."
if [ -d "flutter/flutter_temp" ]; then
    mv flutter/flutter_temp flutter/flutter
fi

# Set path
export PATH="/var/www/demo/flutter/flutter/bin:$PATH"

# Test Flutter
echo "2. Testing Flutter..."
flutter --version

# Create project
echo "3. Creating project..."
rm -rf tukangutang_app
flutter create tukangutang_app

cd tukangutang_app

# Simple main.dart
echo "4. Creating main.dart..."
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

# Build
echo "5. Building APK..."
flutter clean
flutter pub get
flutter build apk --release

# Copy
echo "6. Copying APK..."
cp build/app/outputs/flutter-apk/app-release.apk /var/www/demo/dashboard-frontend/public/tukangutang_app_release.apk

echo "✅ Done!" 