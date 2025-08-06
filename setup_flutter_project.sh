#!/bin/bash

echo "🔧 Setting up Flutter Project..."

cd /var/www/demo/frontend

# Create necessary directories
mkdir -p android/app/src/main/kotlin/com/example/pinjol_app
mkdir -p android/gradle/wrapper
mkdir -p assets/icons assets/images

# Set permissions
chmod +x /var/www/demo/build_apk.sh

echo "✅ Flutter project structure created"
echo "📁 Directories created:"
echo "  - android/app/src/main/kotlin/com/example/pinjol_app"
echo "  - android/gradle/wrapper"
echo "  - assets/icons"
echo "  - assets/images"

echo "🚀 Ready to build APK!"
echo "Run: ./build_apk.sh" 