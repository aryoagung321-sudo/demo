#!/bin/bash

echo "🚀 Starting Site with 502 Fix..."

# Stop any existing containers
docker stop $(docker ps -q) 2>/dev/null || true
docker rm $(docker ps -aq) 2>/dev/null || true

# Start nginx container
echo "🌐 Starting nginx container..."
CONTAINER_ID=$(docker run -d --name site_502_fixed \
  -p 80:80 \
  -v /var/www/demo/dashboard-frontend/public:/usr/share/nginx/html \
  nginx:alpine)

# Copy nginx config
echo "⚙️ Copying nginx config..."
docker cp /var/www/demo/nginx_fix_502.conf $CONTAINER_ID:/etc/nginx/conf.d/default.conf

# Reload nginx
echo "🔄 Reloading nginx..."
docker exec $CONTAINER_ID nginx -s reload

echo "✅ Site started successfully!"
echo "🌐 Main site: http://localhost"
echo "📱 Download: http://localhost/download"
echo "🔐 Login: http://localhost/login" 