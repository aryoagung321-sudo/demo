#!/bin/bash

echo "🔧 Quick fix for 404 error..."

cd /var/www/demo

# Start containers
docker-compose up -d

# Wait
sleep 10

# Test endpoint
echo "Testing endpoint..."
curl -X POST http://localhost:9000/api/flutter/submit-form \
  -H "Content-Type: application/json" \
  -d '{"phoneNumber":"test"}' \
  -w "\nHTTP Status: %{http_code}\n"

echo "✅ Done!" 