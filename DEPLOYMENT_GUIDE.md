# 🚀 Deployment Guide - Admin Dashboard

## 📋 Informasi Deployment

- **Domain**: d.seoikrom.com
- **IP Server**: 31.97.109.207
- **Project Path**: `/var/www/demo`
- **Technology Stack**: Node.js + Vue.js + PostgreSQL + Docker + Nginx

## ✅ Status Deployment

✅ **Backend API**: Running on port 9000  
✅ **Frontend**: Running on port 8080  
✅ **Database**: PostgreSQL running on port 5432  
✅ **SSL Certificate**: Let's Encrypt installed  
✅ **Nginx Reverse Proxy**: Configured  
✅ **Docker Compose**: All services running  

## 🔗 Akses Aplikasi

- **Frontend**: https://d.seoikrom.com
- **API Base URL**: https://d.seoikrom.com/api
- **WebSocket**: wss://d.seoikrom.com/ws

## 🔐 Login Credentials

- **Username**: admin
- **Password**: admin123
- **Token**: admin-token (for API access)

## 🛠 Maintenance Commands

### Check Status
```bash
cd /var/www/demo
./deploy.sh status
```

### Restart Application
```bash
cd /var/www/demo
./deploy.sh restart
```

### View Logs
```bash
cd /var/www/demo
./deploy.sh logs
```

### System Monitoring
```bash
cd /var/www/demo
./deploy.sh monitor
```

### Backup Data
```bash
cd /var/www/demo
./deploy.sh backup
```

### Renew SSL Certificate
```bash
cd /var/www/demo
./deploy.sh ssl
```

## 📁 File Structure

```
/var/www/demo/
├── server/                 # Backend Node.js
│   ├── main.js            # Main server file
│   ├── package.json       # Backend dependencies
│   └── uploads/           # File upload directory
├── dashboard-frontend/     # Frontend Vue.js
│   ├── src/               # Source code
│   ├── dist/              # Built files
│   └── package.json       # Frontend dependencies
├── docker-compose.yml     # Docker services
├── .env                   # Environment variables
├── deploy.sh              # Deployment script
└── DEPLOYMENT_GUIDE.md    # This file
```

## 🔧 API Endpoints

### Authentication
- `POST /api/auth/login` - Login admin

### Users Management
- `GET /api/users` - Get all users
- `POST /api/users` - Create new user
- `PUT /api/users/:id` - Update user
- `DELETE /api/users/:id` - Delete user

### File Management
- `GET /api/files` - Get all files
- `POST /api/upload` - Upload file
- `GET /api/download/:name` - Download file

### Monitoring
- `GET /api/monitoring` - System status

## 🐳 Docker Services

### Backend (Node.js)
- **Port**: 9000
- **Image**: demo_backend
- **Command**: `npm start`

### Frontend (Vue.js + Nginx)
- **Port**: 8080
- **Image**: demo_frontend
- **Command**: `nginx -g daemon off`

### Database (PostgreSQL)
- **Port**: 5432
- **Image**: postgres:15
- **Database**: demo_db
- **User**: admin
- **Password**: adminpass

## 🔒 Security Features

- ✅ HTTPS/SSL enabled
- ✅ JWT-like token authentication
- ✅ CORS configured
- ✅ File upload restrictions (images only, max 5MB)
- ✅ Rate limiting ready
- ✅ Input validation

## 📊 Monitoring & Logs

### Container Logs
```bash
# Backend logs
docker-compose logs backend

# Frontend logs
docker-compose logs frontend

# Database logs
docker-compose logs db
```

### Nginx Logs
```bash
# Access logs
tail -f /var/log/nginx/access.log

# Error logs
tail -f /var/log/nginx/error.log
```

### SSL Certificate
```bash
# Check certificate status
certbot certificates

# Manual renewal
certbot renew
```

## 🔄 Auto-Renewal Setup

SSL certificate will be automatically renewed via cron job:
```bash
# Check cron jobs
crontab -l

# Manual renewal
./deploy.sh ssl
```

## 🚨 Troubleshooting

### If containers won't start:
```bash
cd /var/www/demo
docker-compose down
docker-compose up -d
```

### If SSL certificate expires:
```bash
certbot renew --force-renewal
systemctl reload nginx
```

### If API not responding:
```bash
# Check backend logs
docker-compose logs backend

# Restart backend
docker-compose restart backend
```

### If frontend not loading:
```bash
# Check frontend logs
docker-compose logs frontend

# Rebuild frontend
docker-compose build frontend
docker-compose up -d frontend
```

## 📞 Support

For issues or questions:
1. Check logs: `./deploy.sh logs`
2. Check status: `./deploy.sh status`
3. Restart services: `./deploy.sh restart`

## 🎉 Deployment Complete!

Your Admin Dashboard is now live at:
**https://d.seoikrom.com**

Login with:
- Username: `admin`
- Password: `admin123`

---

**Last Updated**: August 3, 2025  
**Deployed By**: AI Assistant  
**Server**: 31.97.109.207 