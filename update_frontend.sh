#!/bin/bash

echo "🔄 UPDATING FRONTEND WITH NEW CONTENT"
echo "====================================="

cd /var/www/demo

echo "📦 Building frontend..."
docker-compose build --no-cache frontend

echo "🚀 Restarting containers..."
docker-compose down
docker-compose up -d

echo "✅ Frontend updated successfully!"
echo "🌐 Website: https://d.seoikrom.com"
echo "📱 Download: https://d.seoikrom.com/download" 