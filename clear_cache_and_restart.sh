#!/bin/bash

echo "🧹 Clearing cache and restarting application..."

# Stop all containers
echo "🛑 Stopping containers..."
cd /var/www/demo
docker-compose down

# Clear nginx cache
echo "🗑️ Clearing nginx cache..."
docker system prune -f

# Clear browser cache headers
echo "📝 Adding cache-busting headers..."
if [ -f "/etc/nginx/sites-available/d.seoikrom.com" ]; then
    # Add cache control headers
    sed -i '/location \/ {/a\        add_header Cache-Control "no-cache, no-store, must-revalidate";' /etc/nginx/sites-available/d.seoikrom.com
    sed -i '/location \/ {/a\        add_header Pragma "no-cache";' /etc/nginx/sites-available/d.seoikrom.com
    sed -i '/location \/ {/a\        add_header Expires "0";' /etc/nginx/sites-available/d.seoikrom.com
    
    # Reload nginx
    nginx -s reload
fi

# Start containers
echo "🚀 Starting containers..."
docker-compose up -d

# Wait for containers to be ready
echo "⏳ Waiting for containers to be ready..."
sleep 10

# Check container status
echo "📊 Container status:"
docker-compose ps

echo "✅ Cache cleared and application restarted!"
echo "🌐 Access the application at: https://d.seoikrom.com"
echo "💡 If you still see old content, try:"
echo "   - Hard refresh: Ctrl+F5 (Windows) or Cmd+Shift+R (Mac)"
echo "   - Clear browser cache manually"
echo "   - Open in incognito/private mode" 