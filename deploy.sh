#!/bin/bash
apt update
apt install -y nodejs npm nginx git
git clone https://github.com/yourrepo/demo.git /var/www/demo
cd /var/www/demo/server && npm install
pm2 start ws-server.js --name ws
pm2 start user-api.js --name userapi
pm2 start file-api.js --name fileapi
cd /var/www/demo/dashboard-frontend && npm install && npm run build
systemctl reload nginx
echo "DONE! Akses http://d.seoikrom.com/"