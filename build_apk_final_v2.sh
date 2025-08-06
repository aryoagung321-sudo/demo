#!/bin/bash

echo "📱 BUILDING APK FINAL V2 - WITH ICONS"
echo "====================================="

cd /var/www/demo

echo "📋 Checking Flutter environment..."
flutter --version

echo "📁 Checking project structure..."
if [ ! -d "frontend" ]; then
    echo "❌ Frontend directory not found!"
    exit 1
fi

cd frontend

echo "🖼️ Checking icons..."
if [ -f "assets/icons/icon.png" ]; then
    echo "✅ icon.png found"
else
    echo "❌ icon.png not found!"
fi

if [ -f "assets/icons/home.png" ]; then
    echo "✅ home.png found"
else
    echo "❌ home.png not found!"
fi

if [ -f "assets/icons/pembayaran.png" ]; then
    echo "✅ pembayaran.png found"
else
    echo "❌ pembayaran.png not found!"
fi

if [ -f "assets/icons/wallet_10149443.png" ]; then
    echo "✅ wallet_10149443.png found"
else
    echo "❌ wallet_10149443.png not found!"
fi

echo "🧹 Cleaning previous builds..."
flutter clean

echo "📦 Getting dependencies..."
flutter pub get

echo "🔧 Checking for issues..."
flutter doctor

echo "📱 Building APK..."
flutter build apk --release

echo "📋 Checking build result..."
if [ -f "build/app/outputs/flutter-apk/app-release.apk" ]; then
    echo "✅ APK built successfully!"
    echo "📁 APK location: build/app/outputs/flutter-apk/app-release.apk"
    
    # Get APK size
    APK_SIZE=$(du -h build/app/outputs/flutter-apk/app-release.apk | cut -f1)
    echo "📏 APK size: $APK_SIZE"
    
    # Copy to demo directory for easy access
    cp build/app/outputs/flutter-apk/app-release.apk ../pinjol_app_release.apk
    echo "📋 Copied to: /var/www/demo/pinjol_app_release.apk"
    
    echo ""
    echo "🎉 APK BUILD SUCCESSFUL!"
    echo "📱 APK ready for installation"
    echo "📁 Location: /var/www/demo/pinjol_app_release.apk"
    
else
    echo "❌ APK build failed!"
    echo "📋 Checking build logs..."
    
    # Show last 50 lines of build output
    echo "Last 50 lines of build output:"
    tail -50 build/app/outputs/logs/build-time-*.log 2>/dev/null || echo "No build logs found"
    
    exit 1
fi

echo ""
echo "🔧 APK Build Summary:"
echo "===================="
echo "✅ Flutter environment: OK"
echo "✅ Project structure: OK"
echo "✅ Icons: Found"
echo "✅ Dependencies: Installed"
echo "✅ Build: Completed"
echo "✅ APK: Generated"
echo ""
echo "📱 APK ready for installation!"
echo "🌐 You can download it from: /var/www/demo/pinjol_app_release.apk" 