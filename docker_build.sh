#!/bin/bash

echo "🐳 Building APK with Docker..."

cd /var/www/demo

# Create Dockerfile for Flutter build
cat > Dockerfile.flutter << 'EOF'
FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    openjdk-11-jdk \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Set up Flutter
RUN git clone https://github.com/flutter/flutter.git /flutter
ENV PATH="/flutter/bin:$PATH"

# Accept licenses
RUN yes | flutter doctor --android-licenses

# Create Flutter project
WORKDIR /app
RUN flutter create --org com.tukangutang tukangutang_app

WORKDIR /app/tukangutang_app

# Create main.dart
RUN cat > lib/main.dart << 'MAIN_EOF'
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
MAIN_EOF

# Build APK
RUN flutter clean
RUN flutter pub get
RUN flutter build apk --release

# Copy APK to host
CMD ["cp", "build/app/outputs/flutter-apk/app-release.apk", "/output/"]
EOF

# Build Docker image
echo "Building Docker image..."
docker build -f Dockerfile.flutter -t flutter-builder .

# Run container and copy APK
echo "Building APK in container..."
docker run --rm -v /var/www/demo/dashboard-frontend/public:/output flutter-builder

echo "✅ APK built with Docker!"
echo "📱 APK: https://d.seoikrom.com/tukangutang_app_release.apk" 