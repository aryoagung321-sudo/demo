#!/bin/bash

echo "🔧 Restoring Site to Working State..."

# Stop all containers
echo "🛑 Stopping all containers..."
docker stop $(docker ps -q) 2>/dev/null || true
docker rm $(docker ps -aq) 2>/dev/null || true

# Clean up
echo "🧹 Cleaning up..."
docker system prune -f

# Go to demo directory
cd /var/www/demo

# Start backend
echo "🚀 Starting backend..."
docker run -d --name backend_restore \
  -p 9000:9000 \
  -v /var/www/demo/server:/app \
  node:18-alpine \
  sh -c "cd /app && npm install && npm start"

# Wait for backend
sleep 5

# Start frontend with Vue.js
echo "🚀 Starting frontend..."
cd /var/www/demo/dashboard-frontend

# Build frontend
echo "📦 Building frontend..."
npm install
npm run build

# Start nginx with built files
docker run -d --name frontend_restore \
  -p 80:80 \
  -v /var/www/demo/dashboard-frontend/dist:/usr/share/nginx/html \
  -v /var/www/demo/dashboard-frontend/public:/usr/share/nginx/html/public \
  nginx:alpine

# Copy nginx config
docker cp /var/www/demo/dashboard-frontend/nginx.conf frontend_restore:/etc/nginx/conf.d/default.conf
docker exec frontend_restore nginx -s reload

# Test
echo "⏳ Waiting for services..."
sleep 10

echo "🌐 Testing site..."
curl -I http://localhost | head -1
curl -I http://localhost/download | head -1

echo "✅ Site restored!"
echo "🌐 Main site: http://localhost"
echo "📱 Download: http://localhost/download" 