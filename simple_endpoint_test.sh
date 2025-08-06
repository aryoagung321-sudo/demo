#!/bin/bash

echo "🔍 Testing Main Endpoints..."

cd /var/www/demo

# Start containers
docker-compose up -d
sleep 5

# Test backend
echo "Testing backend..."
curl -I http://localhost:9000/api/users

# Test flutter endpoint
echo "Testing flutter/submit-form..."
curl -X POST http://localhost:9000/api/flutter/submit-form \
  -H "Content-Type: application/json" \
  -d '{"phoneNumber":"test"}' \
  -w "\nStatus: %{http_code}\n"

# Test frontend
echo "Testing frontend..."
curl -I http://localhost:8080

echo "✅ Test complete!" 