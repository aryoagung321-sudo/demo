#!/bin/bash

echo "🚀 Deploying Responsive Website..."

cd /var/www/demo

# Build frontend with responsive design
echo "📱 Building responsive frontend..."
docker-compose build --no-cache frontend

# Start containers
echo "🚀 Starting containers..."
docker-compose up -d

# Wait for containers
echo "⏳ Waiting for containers..."
sleep 10

# Test responsive website
echo "🧪 Testing responsive website..."
curl -I http://localhost:8080

# Test APK download
echo "📱 Testing APK download..."
curl -I http://localhost:8080/tukangutang_app_release.apk

echo "✅ Responsive website deployed!"
echo "🌐 Website: https://d.seoikrom.com"
echo "📱 Download: https://d.seoikrom.com/tukangutang_app_release.apk"
echo ""
echo "📱 Responsive Features:"
echo "- Mobile-first design"
echo "- Tablet optimization"
echo "- Desktop enhancement"
echo "- Dark mode support"
echo "- High contrast mode"
echo "- Reduced motion support"
echo "- Landscape orientation"
echo "- All device sizes supported" 