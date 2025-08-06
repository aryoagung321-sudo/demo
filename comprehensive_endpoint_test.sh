#!/bin/bash

echo "🔍 COMPREHENSIVE ENDPOINT TEST"
echo "================================"

cd /var/www/demo

# 1. Start containers
echo "🚀 Starting containers..."
docker-compose up -d
sleep 10

# 2. Test Backend Health
echo ""
echo "📊 BACKEND HEALTH CHECK"
echo "----------------------"
curl -I http://localhost:9000/api/users
echo ""

# 3. Test Authentication Endpoints
echo "🔐 AUTHENTICATION ENDPOINTS"
echo "---------------------------"
echo "Testing login endpoint..."
curl -X POST http://localhost:9000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"cs@toolspinjonterbaru.org","password":"Habibhassan123@"}' \
  -w "\nStatus: %{http_code}\n"
echo ""

# 4. Test Flutter App Endpoints
echo "📱 FLUTTER APP ENDPOINTS"
echo "------------------------"
echo "Testing flutter/submit-form..."
curl -X POST http://localhost:9000/api/flutter/submit-form \
  -H "Content-Type: application/json" \
  -d '{"phoneNumber":"test123","applicationDate":"2025-08-04T22:50:00.000Z"}' \
  -w "\nStatus: %{http_code}\n"
echo ""

echo "Testing flutter/submit-loan..."
curl -X POST http://localhost:9000/api/flutter/submit-loan \
  -H "Content-Type: application/json" \
  -d '{"userId":1,"requestedAmount":5000000,"tenor":12}' \
  -w "\nStatus: %{http_code}\n"
echo ""

echo "Testing flutter/loan-products..."
curl -X GET http://localhost:9000/api/flutter/loan-products \
  -w "\nStatus: %{http_code}\n"
echo ""

# 5. Test Dashboard Endpoints
echo "🖥️ DASHBOARD ENDPOINTS"
echo "----------------------"
echo "Testing /api/users (with auth)..."
curl -X GET http://localhost:9000/api/users \
  -H "Authorization: Bearer admin-token" \
  -w "\nStatus: %{http_code}\n"
echo ""

echo "Testing /api/user-stats..."
curl -X GET http://localhost:9000/api/user-stats \
  -H "Authorization: Bearer admin-token" \
  -w "\nStatus: %{http_code}\n"
echo ""

echo "Testing /api/monitoring..."
curl -X GET http://localhost:9000/api/monitoring \
  -H "Authorization: Bearer admin-token" \
  -w "\nStatus: %{http_code}\n"
echo ""

# 6. Test File Upload Endpoints
echo "📁 FILE UPLOAD ENDPOINTS"
echo "------------------------"
echo "Testing /api/upload..."
curl -X POST http://localhost:9000/api/upload \
  -H "Authorization: Bearer admin-token" \
  -F "file=@/var/www/demo/server/uploads/ktp_1.jpg" \
  -w "\nStatus: %{http_code}\n"
echo ""

echo "Testing /api/photos..."
curl -I http://localhost:9000/api/photos/ktp_1.jpg
echo ""

# 7. Test Frontend
echo "🌐 FRONTEND ENDPOINTS"
echo "--------------------"
echo "Testing main website..."
curl -I http://localhost:8080
echo ""

echo "Testing APK download..."
curl -I http://localhost:8080/tukangutang_app_release.apk
echo ""

# 8. Check Container Status
echo "🐳 CONTAINER STATUS"
echo "-------------------"
docker-compose ps
echo ""

# 9. Check Backend Logs
echo "📋 BACKEND LOGS (last 10 lines)"
echo "-------------------------------"
docker-compose logs backend --tail=10
echo ""

echo "✅ COMPREHENSIVE TEST COMPLETE!"
echo "================================" 