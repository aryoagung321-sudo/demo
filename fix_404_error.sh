#!/bin/bash

echo "🔧 Fixing 404 error on flutter/submit-form endpoint..."

cd /var/www/demo

# 1. Start containers
echo "🚀 Starting containers..."
docker-compose up -d

# 2. Wait for containers to be ready
echo "⏳ Waiting for containers..."
sleep 15

# 3. Test backend endpoint
echo "🧪 Testing backend endpoint..."
curl -X POST http://localhost:9000/api/flutter/submit-form \
  -H "Content-Type: application/json" \
  -d '{"phoneNumber":"test","applicationDate":"2025-08-04T22:50:00.000Z"}' \
  -w "\nStatus: %{http_code}\n"

# 4. Test if backend is running
echo "🔍 Checking backend status..."
curl -I http://localhost:9000/api/users

# 5. Check backend logs
echo "📋 Backend logs:"
docker-compose logs backend --tail=10

echo "✅ Fix complete! If endpoint works, build APK with:"
echo "cd /var/www/demo/frontend && /var/www/demo/flutter/bin/flutter build apk --release" 