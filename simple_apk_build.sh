#!/bin/bash

echo "🔨 Simple APK Build..."

cd /var/www/demo

# Fix Flutter structure
if [ -d "flutter/flutter_temp" ]; then
    echo "📦 Fixing Flutter structure..."
    mv flutter/flutter_temp flutter/flutter
fi

# Set Flutter path
export FLUTTER_ROOT=/var/www/demo/flutter/flutter
export PATH=$FLUTTER_ROOT/bin:$PATH

# Test Flutter
if ! flutter --version; then
    echo "❌ Flutter not working, extracting fresh copy..."
    rm -rf flutter
    tar -xf flutter_linux_3.24.5-stable.tar.xz
    mv flutter flutter_temp
    mkdir -p flutter
    mv flutter_temp flutter/
    export FLUTTER_ROOT=/var/www/demo/flutter/flutter
    export PATH=$FLUTTER_ROOT/bin:$PATH
fi

echo "✅ Flutter version:"
flutter --version

# Create project
echo "📱 Creating Flutter project..."
rm -rf tukangutang_app
flutter create --org com.tukangutang tukangutang_app

cd tukangutang_app

# Simple main.dart
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
      appBar: AppBar(
        title: Text('TukangUtang'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text('Aplikasi berjalan dengan baik!'),
              ),
            ),
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

# Build APK
echo "🔨 Building APK..."
flutter clean
flutter pub get
flutter build apk --release

# Copy APK
echo "📦 Copying APK..."
cp build/app/outputs/flutter-apk/app-release.apk /var/www/demo/dashboard-frontend/public/tukangutang_app_release.apk

echo "✅ APK built successfully!"
echo "📱 APK: https://d.seoikrom.com/tukangutang_app_release.apk"
echo "📋 Size: $(ls -lh /var/www/demo/dashboard-frontend/public/tukangutang_app_release.apk | awk '{print $5}')" 