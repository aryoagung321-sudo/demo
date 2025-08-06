#!/bin/bash

echo "🚀 Deploying APK to website..."

cd /var/www/demo

# Copy existing APK to public folder
cp tukangutang_app_release.apk dashboard-frontend/public/

# Start containers
docker-compose up -d

# Test APK download
sleep 5
curl -I http://localhost:8080/tukangutang_app_release.apk

echo "✅ APK deployed at: https://d.seoikrom.com/tukangutang_app_release.apk" 