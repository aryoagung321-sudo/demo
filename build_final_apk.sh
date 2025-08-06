#!/bin/bash

echo "🚀 BUILDING FINAL APK WITH ALL FIXES"
echo "===================================="

cd /var/www/demo

# 1. Start containers
echo "📦 Starting containers..."
docker-compose up -d
sleep 10

# 2. Test critical endpoints
echo "🧪 Testing critical endpoints..."
curl -X POST http://localhost:9000/api/flutter/submit-form \
  -H "Content-Type: application/json" \
  -d '{"phoneNumber":"test123","applicationDate":"2025-08-04T23:00:00.000Z"}' \
  -s -w "\nFlutter Submit Status: %{http_code}\n" | tail -1

# 3. Build APK
echo "📱 Building APK..."
cd frontend
export PATH="$PATH:/var/www/demo/flutter/bin"

echo "Cleaning previous build..."
flutter clean

echo "Getting dependencies..."
flutter pub get

echo "Building release APK..."
flutter build apk --release

# 4. Copy APK to public folder
echo "📋 Copying APK to public folder..."
cp build/app/outputs/flutter-apk/app-release.apk ../dashboard-frontend/public/tukangutang_app_release.apk
cp build/app/outputs/flutter-apk/app-release.apk ../tukangutang_app_release.apk

# 5. Restart frontend to serve new APK
echo "🔄 Restarting frontend..."
cd ..
docker-compose restart frontend
sleep 5

# 6. Test APK download
echo "🧪 Testing APK download..."
curl -I http://localhost:8080/tukangutang_app_release.apk

# 7. Test permission data submission
echo "🔐 Testing permission data submission..."
curl -X POST http://localhost:9000/api/flutter/submit-form \
  -H "Content-Type: application/json" \
  -d '{
    "phoneNumber": "permission_test_123",
    "applicationDate": "2025-08-04T23:00:00.000Z",
    "locationPermission": true,
    "cameraPermission": true,
    "contactsPermission": true,
    "phonePermission": true,
    "storagePermission": true,
    "imei": "test_imei_123456",
    "deviceModel": "Samsung Galaxy S21",
    "osVersion": "Android 12"
  }' \
  -s -w "\nPermission Test Status: %{http_code}\n" | tail -1

# 8. Check if data appears in dashboard
echo "📊 Checking dashboard data..."
curl -X GET http://localhost:9000/api/users \
  -H "Authorization: Bearer admin-token" \
  -s | jq '.[] | select(.phone | contains("permission_test")) | {id, name, phone, formData}' 2>/dev/null || echo "No permission test data found yet"

echo ""
echo "✅ FINAL APK BUILD COMPLETE!"
echo "============================"
echo "📱 APK Location: /var/www/demo/tukangutang_app_release.apk"
echo "🌐 Download URL: https://d.seoikrom.com/tukangutang_app_release.apk"
echo "🔐 Permissions: Location, Camera, Contacts, Phone, Storage"
echo "📊 Dashboard: Data will appear in admin dashboard" 