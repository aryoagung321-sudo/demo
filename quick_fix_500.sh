#!/bin/bash

echo "🚀 Quick Fix for 500 Error"

# Stop problematic containers
echo "🛑 Stopping containers..."
docker stop $(docker ps -q) 2>/dev/null || true

# Remove containers
echo "🗑️ Removing containers..."
docker rm $(docker ps -aq) 2>/dev/null || true

# Start fresh containers
echo "🚀 Starting fresh containers..."
cd /var/www/demo

# Start backend
docker run -d --name backend_fix -p 9000:9000 -v /var/www/demo/server:/app node:18-alpine sh -c "cd /app && npm install && npm start"

# Start frontend with static files
docker run -d --name frontend_fix -p 80:80 -v /var/www/demo/dashboard-frontend/public:/usr/share/nginx/html nginx:alpine

echo "✅ Quick fix completed!"
echo "🌐 Test: curl -I http://localhost" 