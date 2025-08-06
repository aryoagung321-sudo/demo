# 🔧 Dashboard Troubleshooting Guide

## 🚨 Masalah: Dashboard Kosong di https://d.seoikrom.com/dashboard

### ✅ Solusi yang Sudah Diterapkan:

1. **Fixed Import Issues**
   - Menambahkan `computed` import di AdminDashboardHome.vue
   - Menambahkan DashboardLayout component

2. **Improved API Integration**
   - Membuat utils/api.js dengan axios interceptor
   - Menambahkan token authentication otomatis

3. **Enhanced UI/UX**
   - Menambahkan navigation bar
   - Layout yang lebih responsif
   - Proper routing setup

### 🔍 Cara Test Dashboard:

1. **Login ke Dashboard**
   ```bash
   # Akses login page
   https://d.seoikrom.com/login
   
   # Credentials:
   Username: admin
   Password: admin123
   ```

2. **Test API Endpoints**
   ```bash
   # Test login
   curl -X POST https://d.seoikrom.com/api/auth/login \
     -H "Content-Type: application/json" \
     -d '{"username":"admin","password":"admin123"}'
   
   # Test dashboard data
   curl -H "Authorization: Bearer admin-token" \
     https://d.seoikrom.com/api/users
   ```

3. **Check Browser Console**
   - Buka Developer Tools (F12)
   - Lihat Console untuk error messages
   - Check Network tab untuk API calls

### 🛠 Debug Commands:

```bash
# Check container status
cd /var/www/demo
./deploy.sh status

# View frontend logs
./deploy.sh logs

# Restart frontend only
docker-compose restart frontend

# Rebuild frontend
docker-compose build frontend
docker-compose up -d frontend
```

### 📁 File Structure Dashboard:

```
dashboard-frontend/src/
├── views/
│   ├── AdminLogin.vue          # Login page
│   ├── AdminDashboardHome.vue  # Main dashboard
│   ├── UserManagement.vue      # User management
│   └── FileExplorer.vue        # File management
├── components/
│   └── DashboardLayout.vue     # Navigation layout
├── stores/
│   └── auth.js                 # Authentication store
├── utils/
│   └── api.js                  # API utilities
└── router/
    └── index.js                # Route configuration
```

### 🔧 Common Issues & Solutions:

#### 1. Dashboard Blank/White Screen
**Cause**: JavaScript error atau routing issue
**Solution**: 
```bash
# Check browser console for errors
# Rebuild frontend
docker-compose build frontend
docker-compose up -d frontend
```

#### 2. API Calls Failing
**Cause**: CORS atau authentication issue
**Solution**:
```bash
# Check backend logs
docker-compose logs backend

# Test API directly
curl https://d.seoikrom.com/api/auth/login
```

#### 3. Charts Not Loading
**Cause**: Chart.js dependency issue
**Solution**:
```bash
# Rebuild with updated dependencies
docker-compose build frontend
docker-compose up -d frontend
```

#### 4. Navigation Not Working
**Cause**: Router configuration issue
**Solution**:
- Check router/index.js
- Ensure all components are imported
- Verify route paths

### 🎯 Expected Dashboard Features:

✅ **Login System**
- Username: admin
- Password: admin123
- JWT token authentication

✅ **Dashboard Overview**
- User statistics
- Real-time charts
- System monitoring

✅ **User Management**
- List all users
- Add/Edit/Delete users
- User status tracking

✅ **File Management**
- Upload files
- List uploaded files
- Download files

✅ **Navigation**
- Responsive navbar
- Active route highlighting
- Logout functionality

### 📊 Dashboard Components:

1. **Header Section**
   - Dashboard title
   - Description

2. **Metrics Cards**
   - Total active users
   - Online users
   - Device alerts
   - Pending commands

3. **Analytics Charts**
   - User activity (7 days)
   - Feature distribution
   - Hourly online users

4. **User Table**
   - User list with details
   - Status indicators
   - Action buttons

5. **Navigation Bar**
   - Dashboard link
   - Users link
   - Files link
   - Logout button

### 🔄 Update Process:

```bash
# 1. Make changes to Vue files
# 2. Rebuild frontend
cd /var/www/demo
docker-compose build frontend

# 3. Restart frontend
docker-compose up -d frontend

# 4. Check status
./deploy.sh status
```

### 📞 Support:

Jika dashboard masih kosong:

1. **Check Browser Console** (F12)
2. **Verify API Response**:
   ```bash
   curl https://d.seoikrom.com/api/auth/login
   ```
3. **Check Container Logs**:
   ```bash
   ./deploy.sh logs
   ```
4. **Restart All Services**:
   ```bash
   ./deploy.sh restart
   ```

---

**Last Updated**: August 3, 2025  
**Status**: Dashboard should be working with proper layout and navigation 