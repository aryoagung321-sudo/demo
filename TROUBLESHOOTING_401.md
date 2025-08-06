# 🔧 **TROUBLESHOOTING 401 UNAUTHORIZED**

## ⚠️ **Status: Masalah 401 Masih Terjadi**

Berdasarkan test yang sudah dilakukan:

### ✅ **Backend API Berfungsi:**
```bash
# Login API - WORKING ✅
curl -X POST http://localhost:9000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin123"}'
# Response: {"token":"admin-token","user":{"username":"admin","role":"admin"}}

# Users API - WORKING ✅  
curl -X GET http://localhost:9000/api/users \
  -H "Authorization: Bearer admin-token"
# Response: [{"id":1,"name":"Budi Santoso",...}]
```

### ❌ **Frontend Masih 401:**
- Dashboard masih mendapat 401 Unauthorized
- Perubahan kode belum ter-deploy
- Container perlu di-restart

## 🔍 **Root Cause Analysis:**

### **1. Container Port Mismatch**
- Backend berjalan di port **9000** (bukan 3000)
- Frontend mungkin masih menggunakan port 3000

### **2. Frontend Cache Issue**
- Browser cache masih menyimpan versi lama
- Docker container belum di-restart

### **3. API Base URL Issue**
- Frontend mungkin menggunakan URL yang salah
- Perlu update base URL ke port 9000

## 🚀 **SOLUSI LENGKAP:**

### **Step 1: Update API Base URL**
```javascript
// /var/www/demo/dashboard-frontend/src/utils/api.js
const api = axios.create({
  baseURL: 'http://localhost:9000/api',  // Update ke port 9000
  timeout: 10000
})
```

### **Step 2: Restart All Containers**
```bash
cd /var/www/demo
docker-compose down
docker-compose up -d
```

### **Step 3: Build Frontend dengan Perubahan**
```bash
cd /var/www/demo
docker-compose build --no-cache frontend
docker-compose up -d frontend
```

### **Step 4: Clear Browser Cache**
1. Buka Developer Tools (F12)
2. Klik kanan pada refresh button
3. Pilih "Empty Cache and Hard Reload"
4. Atau gunakan Ctrl+Shift+R

## 🧪 **Testing Commands:**

### **1. Test Backend API:**
```bash
# Test login
curl -X POST http://localhost:9000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin123"}'

# Test users with token
curl -X GET http://localhost:9000/api/users \
  -H "Authorization: Bearer admin-token"

# Test user stats
curl -X GET http://localhost:9000/api/user-stats \
  -H "Authorization: Bearer admin-token"
```

### **2. Test Frontend:**
1. Buka https://d.seoikrom.com/dashboard
2. Login dengan admin/admin123
3. Buka Developer Tools > Network tab
4. Refresh halaman
5. Check API calls tidak mendapat 401

## 🔧 **Manual Fix Commands:**

### **Option 1: Quick Restart**
```bash
cd /var/www/demo
docker-compose restart frontend
sleep 10
docker-compose ps
```

### **Option 2: Full Rebuild**
```bash
cd /var/www/demo
docker-compose down
docker-compose build --no-cache frontend
docker-compose up -d
sleep 15
docker-compose ps
```

### **Option 3: Force Update**
```bash
cd /var/www/demo
docker-compose down
docker system prune -f
docker-compose build --no-cache
docker-compose up -d
```

## 📊 **Expected Results After Fix:**

### **✅ Network Tab Should Show:**
```
✅ /api/auth/login - 200 OK
✅ /api/users - 200 OK (with user data)
✅ /api/user-stats - 200 OK (with statistics)
❌ No more 401 errors
```

### **✅ Dashboard Should Display:**
```
✅ Real user data (not fallback)
✅ Correct statistics
✅ Working search functionality
✅ All features working
```

## 🎯 **Verification Checklist:**

### **✅ Backend Verification:**
- [ ] Container running on port 9000
- [ ] Login API returns token
- [ ] Users API returns data with token
- [ ] User-stats API returns statistics

### **✅ Frontend Verification:**
- [ ] Container running on port 8080
- [ ] Dashboard loads without 401
- [ ] Login works correctly
- [ ] User data displays properly
- [ ] Search functionality works

### **✅ Browser Verification:**
- [ ] Clear browser cache
- [ ] Hard refresh (Ctrl+Shift+R)
- [ ] Check Network tab for 401 errors
- [ ] Test all dashboard features

## 🚨 **If Still 401 After All Steps:**

### **1. Check Container Logs:**
```bash
cd /var/www/demo
docker-compose logs frontend
docker-compose logs backend
```

### **2. Check Nginx Configuration:**
```bash
# Verify nginx proxy settings
cat /etc/nginx/sites-available/d.seoikrom.com
```

### **3. Check Environment Variables:**
```bash
# Verify .env file
cat /var/www/demo/.env
```

### **4. Force Browser Cache Clear:**
- Open Developer Tools
- Go to Application tab
- Clear Storage > Clear site data
- Hard refresh

## 🎉 **Final Status:**

**Backend API: ✅ WORKING**
**Frontend Container: ✅ RUNNING**
**Issue: Frontend cache/configuration**

**Next Action: Restart frontend container and clear browser cache! 🚀** 