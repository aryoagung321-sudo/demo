#!/bin/bash

echo "📱 BUILDING TUKANGUTANG APK"
echo "============================"

cd /var/www/demo

echo "🔧 Setting up environment..."
cd frontend

echo "🧹 Cleaning previous build..."
flutter clean

echo "📦 Getting dependencies..."
flutter pub get

echo "🔧 Building release APK..."
flutter build apk --release

echo "📋 Checking build result..."
if [ -f "build/app/outputs/flutter-apk/app-release.apk" ]; then
    echo "✅ APK built successfully!"
    
    # Copy to main directory with new name
    cp build/app/outputs/flutter-apk/app-release.apk /var/www/demo/tukangutang_app_release.apk
    
    # Copy to public folder for website download
    cp build/app/outputs/flutter-apk/app-release.apk /var/www/demo/dashboard-frontend/public/tukangutang_app_release.apk
    
    # Get file size
    APK_SIZE=$(du -h /var/www/demo/tukangutang_app_release.apk | cut -f1)
    
    echo "📁 APK copied to:"
    echo "   - /var/www/demo/tukangutang_app_release.apk"
    echo "   - /var/www/demo/dashboard-frontend/public/tukangutang_app_release.apk"
    echo "📏 APK size: $APK_SIZE"
    
    # Update download page to point to new APK
    echo "🌐 Updating download page..."
    sed -i 's/pinjol_app_release.apk/tukangutang_app_release.apk/g' /var/www/demo/dashboard-frontend/src/views/DownloadAPK.vue
    
    # Restart frontend to apply changes
    echo "🔄 Restarting frontend..."
    cd /var/www/demo
    docker-compose restart frontend
    
    echo "🎉 SUCCESS! TukangUtang APK ready!"
    echo "📱 Download URL: https://d.seoikrom.com/tukangutang_app_release.apk"
    echo "🌐 Website: https://d.seoikrom.com"
    echo "📱 App Name: TukangUtang"
    echo "💡 Note: This is a release APK with new branding"
    
else
    echo "❌ APK build failed!"
    exit 1
fi 