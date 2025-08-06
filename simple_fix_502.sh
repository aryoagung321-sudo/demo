#!/bin/bash

echo "🔧 Simple 502 Fix..."

cd /var/www/demo

# Start containers
echo "🚀 Starting containers..."
docker-compose up -d

# Wait
echo "⏳ Waiting..."
sleep 10

# Test
echo "🧪 Testing..."
curl -I http://localhost:8080

echo "✅ Done!" 