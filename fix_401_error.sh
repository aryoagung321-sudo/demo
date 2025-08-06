#!/bin/bash

echo "🔧 Fixing 401 Unauthorized Error..."
echo "=================================="

# Stop all containers
echo "📦 Stopping containers..."
cd /var/www/demo
docker-compose down

# Build frontend with new changes
echo "🔨 Building frontend with API fixes..."
docker-compose build --no-cache frontend

# Start all containers
echo "🚀 Starting containers..."
docker-compose up -d

# Wait for containers to be ready
echo "⏳ Waiting for containers to be ready..."
sleep 10

# Check container status
echo "📊 Checking container status..."
docker-compose ps

# Test API endpoints
echo "🧪 Testing API endpoints..."
echo "Testing /api/auth/login..."
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin123"}' \
  -s | jq .

echo "Testing /api/users with token..."
TOKEN=$(curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin123"}' \
  -s | jq -r '.token')

if [ "$TOKEN" != "null" ]; then
  echo "✅ Token obtained: $TOKEN"
  curl -X GET http://localhost:3000/api/users \
    -H "Authorization: Bearer $TOKEN" \
    -s | jq .
else
  echo "❌ Failed to get token"
fi

echo "✅ Fix completed!"
echo "🌐 Access your dashboard at: https://d.seoikrom.com/dashboard"
echo "🔑 Login with: admin / admin123" 