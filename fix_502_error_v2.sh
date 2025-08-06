#!/bin/bash

echo "🔧 Fixing 502 Error..."

cd /var/www/demo

# Stop all containers
echo "🛑 Stopping containers..."
docker-compose down

# Clean up
echo "🧹 Cleaning up..."
docker system prune -f

# Rebuild and start containers
echo "🔨 Rebuilding containers..."
docker-compose build --no-cache
docker-compose up -d

# Wait for containers
echo "⏳ Waiting for containers..."
sleep 15

# Check container status
echo "📊 Container status:"
docker-compose ps

# Test endpoints
echo "🧪 Testing endpoints..."
sleep 5

echo "🌐 Testing website..."
curl -I http://localhost:8080

echo "📱 Testing APK download..."
curl -I http://localhost:8080/tukangutang_app_release.apk

echo "🔧 Testing backend..."
curl -I http://localhost:9000/api/users

echo "✅ Fix complete!"
echo "🌐 Website: https://d.seoikrom.com"
echo "📱 APK: https://d.seoikrom.com/tukangutang_app_release.apk" 