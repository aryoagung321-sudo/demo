#!/bin/bash

echo "🚀 Building APK with Auto Versioning..."

cd /var/www/demo

# Generate version number based on timestamp
VERSION_DATE=$(date +"%Y%m%d")
VERSION_TIME=$(date +"%H%M")
VERSION_CODE="${VERSION_DATE}_${VERSION_TIME}"
VERSION_NAME="v1.0.${VERSION_CODE}"

echo "📱 Version: ${VERSION_NAME}"
echo "🔢 Version Code: ${VERSION_CODE}"

# Update pubspec.yaml with new version
echo "📝 Updating pubspec.yaml..."
sed -i "s/version: .*/version: ${VERSION_NAME}/" frontend/pubspec.yaml

# Update AndroidManifest.xml
echo "📱 Updating AndroidManifest.xml..."
sed -i "s/android:label=\".*\"/android:label=\"TukangUtang v${VERSION_CODE}\"/" frontend/android/app/src/main/AndroidManifest.xml

# Setup Flutter environment
echo "🔧 Setting up Flutter environment..."
export PATH="/var/www/demo/flutter/bin:$PATH"
export ANDROID_HOME="/var/www/demo/android-sdk"
export JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"

# Clean and get dependencies
echo "🧹 Cleaning Flutter project..."
cd frontend
flutter clean
flutter pub get

# Build APK with specific name
echo "🔨 Building APK..."
flutter build apk --release

# Check if build successful
if [ $? -eq 0 ]; then
    echo "✅ APK build successful!"
    
    # Copy APK with version number
    APK_NAME="tukangutang_app_v${VERSION_CODE}.apk"
    cp build/app/outputs/flutter-apk/app-release.apk "../dashboard-frontend/public/${APK_NAME}"
    
    # Also copy as latest version
    cp build/app/outputs/flutter-apk/app-release.apk "../dashboard-frontend/public/tukangutang_app_release.apk"
    
    echo "📱 APK files created:"
    echo "   - ${APK_NAME} (versioned)"
    echo "   - tukangutang_app_release.apk (latest)"
    
    # Update download page with new version
    echo "📝 Updating download page..."
    cd ../dashboard-frontend/src/views
    
    # Update DownloadAPK.vue with new version info
    sed -i "s/Versi:.*/Versi: ${VERSION_NAME}/" DownloadAPK.vue
    sed -i "s/Update:.*/Update: $(date +'%d %B %Y')/" DownloadAPK.vue
    sed -i "s/download=\"TukangUtang_v.*\.apk\"/download=\"${APK_NAME}\"/" DownloadAPK.vue
    
    # Rebuild frontend
    echo "🔨 Rebuilding frontend..."
    cd /var/www/demo
    docker-compose build --no-cache frontend
    docker-compose up -d
    
    echo "✅ APK Build Complete!"
    echo "📱 Version: ${VERSION_NAME}"
    echo "🌐 Download URL: https://d.seoikrom.com/${APK_NAME}"
    echo "📱 Latest URL: https://d.seoikrom.com/tukangutang_app_release.apk"
    
else
    echo "❌ APK build failed!"
    exit 1
fi 