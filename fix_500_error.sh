#!/bin/bash

echo "🔧 Fixing 500 Error..."

cd /var/www/demo

echo "📊 Checking container status..."
docker-compose ps

echo "🛑 Stopping all containers..."
docker-compose down

echo "🧹 Cleaning up..."
docker system prune -f

echo "🚀 Starting containers..."
docker-compose up -d

echo "⏳ Waiting for containers to start..."
sleep 10

echo "📊 Checking container status again..."
docker-compose ps

echo "🌐 Testing website..."
curl -I https://d.seoikrom.com | head -1

echo "✅ Fix completed!" 