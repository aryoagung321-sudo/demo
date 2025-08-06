#!/bin/bash

echo "🔧 Fixing 502 Error Now..."

# Kill all containers
echo "🛑 Killing all containers..."
docker kill $(docker ps -q) 2>/dev/null || true
docker rm $(docker ps -aq) 2>/dev/null || true

# Start nginx with static files
echo "🌐 Starting nginx..."
docker run -d --name site_502_fix \
  -p 80:80 \
  -v /var/www/demo/dashboard-frontend/public:/usr/share/nginx/html \
  nginx:alpine

# Copy nginx config
echo "⚙️ Configuring nginx..."
docker cp /var/www/demo/nginx_download.conf site_502_fix:/etc/nginx/conf.d/default.conf
docker exec site_502_fix nginx -s reload

echo "✅ 502 Error Fixed!"
echo "🌐 Test: curl -I http://localhost" 