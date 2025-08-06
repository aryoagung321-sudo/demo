#!/bin/bash

echo "🔧 Quick Fix 401 Error..."
echo "========================="

cd /var/www/demo

echo "📦 Restarting frontend container..."
docker-compose restart frontend

echo "⏳ Waiting for frontend to be ready..."
sleep 10

echo "📊 Container status:"
docker-compose ps

echo "🧪 Testing API..."
echo "Login test:"
curl -X POST http://localhost:9000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin123"}' \
  -s

echo ""
echo "Users API test:"
curl -X GET http://localhost:9000/api/users \
  -H "Authorization: Bearer admin-token" \
  -s | head -c 100

echo ""
echo "✅ Quick fix completed!"
echo "🌐 Access: https://d.seoikrom.com/dashboard"
echo "🔑 Login: admin / admin123"
echo ""
echo "💡 If still 401, clear browser cache and try again!" 