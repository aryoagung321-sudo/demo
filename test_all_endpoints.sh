#!/bin/bash

echo "🔍 Testing All API Endpoints..."

BASE_URL="https://d.seoikrom.com"

echo "📱 Testing Website..."
curl -I "${BASE_URL}" | head -1

echo "📱 Testing Dashboard..."
curl -I "${BASE_URL}/dashboard" | head -1

echo "📱 Testing Download Page..."
curl -I "${BASE_URL}/download" | head -1

echo "📱 Testing APK Download..."
curl -I "${BASE_URL}/tukangutang_app_release.apk" | head -1

echo "🔌 Testing Backend API..."
echo "Testing /api/users..."
curl -s -o /dev/null -w "%{http_code}" "${BASE_URL}/api/users" || echo "Failed"

echo "Testing /api/user-stats..."
curl -s -o /dev/null -w "%{http_code}" "${BASE_URL}/api/user-stats" || echo "Failed"

echo "Testing /api/flutter/loan-products..."
curl -s -o /dev/null -w "%{http_code}" "${BASE_URL}/api/flutter/loan-products" || echo "Failed"

echo "✅ All tests completed!" 