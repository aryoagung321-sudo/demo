#!/bin/bash

echo "🔧 FINAL 401 FIX - COMPLETE SOLUTION"
echo "==================================="

cd /var/www/demo

echo "📦 Step 1: Stopping containers..."
docker-compose down

echo "🔨 Step 2: Building frontend with API fixes..."
docker-compose build --no-cache frontend

echo "🚀 Step 3: Starting all containers..."
docker-compose up -d

echo "⏳ Step 4: Waiting for containers to be ready..."
sleep 15

echo "📊 Step 5: Checking container status..."
docker-compose ps

echo "🧪 Step 6: Testing API endpoints..."
echo "Testing login API..."
curl -X POST http://localhost:9000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin123"}' \
  -s

echo ""
echo "Testing users API..."
curl -X GET http://localhost:9000/api/users \
  -H "Authorization: Bearer admin-token" \
  -s | head -c 100

echo ""
echo "✅ FINAL FIX COMPLETED!"
echo "🌐 Access your dashboard: https://d.seoikrom.com/dashboard"
echo "🔑 Login credentials: admin / admin123"
echo ""
echo "💡 IMPORTANT: Clear browser cache and hard refresh!"
echo "   - Press Ctrl+Shift+R or"
echo "   - Right-click refresh > Empty Cache and Hard Reload"
echo ""
echo "🎯 Expected result: No more 401 errors in Network tab!" 