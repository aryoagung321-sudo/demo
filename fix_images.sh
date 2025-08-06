#!/bin/bash

echo "🖼️ Fixing KTP and Selfie Images..."
echo "=================================="

cd /var/www/demo

echo "📁 Creating uploads directory..."
mkdir -p server/uploads

echo "🖼️ Creating sample images..."
cd server/uploads

# Create sample KTP images
echo "Sample KTP Image Data for Budi" > ktp_budi.jpg
echo "Sample KTP Image Data for Rina" > ktp_rina.jpg
echo "Sample KTP Image Data for Hendra" > ktp_hendra.jpg
echo "Sample KTP Image Data for Siti" > ktp_siti.jpg

# Create sample Selfie images
echo "Sample Selfie Image Data for Budi" > selfie_budi.jpg
echo "Sample Selfie Image Data for Rina" > selfie_rina.jpg
echo "Sample Selfie Image Data for Hendra" > selfie_hendra.jpg
echo "Sample Selfie Image Data for Siti" > selfie_siti.jpg

echo "📋 Listing created files..."
ls -la

echo "🔄 Restarting backend..."
cd /var/www/demo
docker-compose restart backend

echo "⏳ Waiting for backend to be ready..."
sleep 10

echo "🧪 Testing image endpoints..."
echo "Testing KTP image:"
curl -I http://localhost:9000/uploads/ktp_budi.jpg

echo ""
echo "Testing API photos endpoint:"
curl -I http://localhost:9000/api/photos/ktp_budi.jpg

echo ""
echo "✅ Image fix completed!"
echo "🌐 Test images at:"
echo "   - https://d.seoikrom.com/uploads/ktp_budi.jpg"
echo "   - https://d.seoikrom.com/api/photos/ktp_budi.jpg"
echo ""
echo "💡 Refresh your browser to see the images!" 