#!/bin/bash

echo "🧪 Test and Build APK"

# Test endpoint
echo "Testing API endpoint..."
curl -X POST https://d.seoikrom.com/api/flutter/submit-form \
  -H "Content-Type: application/json" \
  -d '{"phoneNumber":"+6281234567890","fullName":"Test User"}' \
  -s -w "\nHTTP Status: %{http_code}\n"

# Check Flutter
if [ -f "/var/www/demo/flutter/flutter/bin/flutter" ]; then
    echo "Flutter found, building APK..."
    export PATH="/var/www/demo/flutter/flutter/bin:$PATH"
    
    cd /var/www/demo
    
    # Create simple project
    flutter create --org com.tukangutang test_app
    cd test_app
    
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
      home: Scaffold(
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
      ),
    );
  }
}
EOF

    # Build
    flutter build apk --release
    
    # Copy
    cp build/app/outputs/flutter-apk/app-release.apk /var/www/demo/dashboard-frontend/public/tukangutang_app_release.apk
    
    echo "✅ APK built successfully!"
    echo "📱 Download: https://d.seoikrom.com/tukangutang_app_release.apk"
else
    echo "❌ Flutter not found"
fi 