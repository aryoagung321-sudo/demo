#!/bin/bash

echo "🚀 Building APK Final v3 with Auto Versioning..."

cd /var/www/demo

# Generate version number
VERSION_DATE=$(date +"%Y%m%d")
VERSION_TIME=$(date +"%H%M")
VERSION_CODE="${VERSION_DATE}_${VERSION_TIME}"
VERSION_NAME="v1.0.${VERSION_CODE}"

echo "📱 Version: ${VERSION_NAME}"
echo "🔢 Version Code: ${VERSION_CODE}"

# Setup environment
export PATH="/var/www/demo/flutter/bin:$PATH"
export ANDROID_HOME="/var/www/demo/android-sdk"
export JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"

# Update pubspec.yaml
echo "📝 Updating pubspec.yaml..."
cd frontend
sed -i "s/version: .*/version: ${VERSION_NAME}+${VERSION_CODE}/" pubspec.yaml

# Clean project
echo "🧹 Cleaning project..."
flutter clean
flutter pub get
flutter pub upgrade

# Check Flutter doctor
echo "🔍 Checking Flutter environment..."
flutter doctor

# Build APK
echo "🔨 Building APK..."
flutter build apk --release --verbose

# Check build result
if [ $? -eq 0 ]; then
    echo "✅ APK build successful!"
    
    # Create versioned APK name
    APK_NAME="tukangutang_app_v${VERSION_CODE}.apk"
    
    # Copy APK files
    cp build/app/outputs/flutter-apk/app-release.apk "../dashboard-frontend/public/${APK_NAME}"
    cp build/app/outputs/flutter-apk/app-release.apk "../dashboard-frontend/public/tukangutang_app_release.apk"
    
    echo "📱 APK files created:"
    echo "   - ${APK_NAME}"
    echo "   - tukangutang_app_release.apk"
    
    # Update download page
    echo "📝 Updating download page..."
    cd ../dashboard-frontend/src/views
    
    # Update version info in DownloadAPK.vue
    sed -i "s/Versi:.*/Versi: ${VERSION_NAME}/" DownloadAPK.vue
    sed -i "s/Update:.*/Update: $(date +'%d %B %Y')/" DownloadAPK.vue
    
    # Rebuild frontend
    echo "🔨 Rebuilding frontend..."
    cd /var/www/demo
    docker-compose build --no-cache frontend
    docker-compose up -d
    
    echo "✅ APK Build Complete!"
    echo "📱 Version: ${VERSION_NAME}"
    echo "🌐 Download URLs:"
    echo "   - Versioned: https://d.seoikrom.com/${APK_NAME}"
    echo "   - Latest: https://d.seoikrom.com/tukangutang_app_release.apk"
    
    # Test endpoints
    echo "🧪 Testing endpoints..."
    sleep 5
    curl -I http://localhost:8080
    curl -I http://localhost:8080/tukangutang_app_release.apk
    
else
    echo "❌ APK build failed!"
    echo "🔍 Checking for errors..."
    flutter doctor -v
    exit 1
fi 