# 🔧 APK Troubleshooting Guide

## ❌ **Masalah: "Ada masalah saat mengurai paket"**

### **Penyebab:**
1. **APK file corrupted** - File APK tidak lengkap atau rusak
2. **APK hanya placeholder** - File bukan APK yang valid
3. **Project Flutter tidak lengkap** - Missing Android folder dan konfigurasi
4. **Build process gagal** - Error saat build APK

### **Solusi:**

#### **1. Periksa APK File**
```bash
cd /var/www/demo
ls -la pinjol-app.apk
file pinjol-app.apk
```

**Expected Output:**
- Size: > 10MB (bukan 29 bytes)
- Type: "Android application package"

#### **2. Setup Project Flutter Lengkap**
```bash
cd /var/www/demo
chmod +x setup_flutter_project.sh
./setup_flutter_project.sh
```

#### **3. Build APK Baru**
```bash
cd /var/www/demo
chmod +x build_apk.sh
./build_apk.sh
```

## 🔍 **Diagnosis Masalah**

### **Check 1: Flutter Installation**
```bash
export PATH="$PATH:/opt/flutter/bin"
flutter --version
```

### **Check 2: Android SDK**
```bash
export ANDROID_HOME=/opt/android-sdk
ls -la $ANDROID_HOME/cmdline-tools/latest/bin
```

### **Check 3: Project Structure**
```bash
cd /var/www/demo/frontend
ls -la
ls -la android/
ls -la android/app/
```

### **Check 4: Dependencies**
```bash
cd /var/www/demo/frontend
flutter pub get
flutter doctor -v
```

## 🚀 **Step-by-Step Fix**

### **Step 1: Clean Previous Build**
```bash
cd /var/www/demo/frontend
flutter clean
rm -rf build/
```

### **Step 2: Setup Project Structure**
```bash
cd /var/www/demo
./setup_flutter_project.sh
```

### **Step 3: Get Dependencies**
```bash
cd /var/www/demo/frontend
export PATH="$PATH:/opt/flutter/bin"
export ANDROID_HOME=/opt/android-sdk
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64

flutter pub get
```

### **Step 4: Build APK**
```bash
cd /var/www/demo
./build_apk.sh
```

### **Step 5: Verify APK**
```bash
cd /var/www/demo
file pinjol-app.apk
ls -la pinjol-app.apk
```

## 📋 **Expected File Structure**

```
/var/www/demo/frontend/
├── android/
│   ├── app/
│   │   ├── build.gradle
│   │   ├── src/main/
│   │   │   ├── AndroidManifest.xml
│   │   │   └── kotlin/com/example/pinjol_app/
│   │   │       └── MainActivity.kt
│   ├── build.gradle
│   ├── settings.gradle
│   ├── local.properties
│   └── gradle/wrapper/
│       └── gradle-wrapper.properties
├── lib/
│   ├── main.dart
│   ├── screens/
│   └── services/
├── assets/
│   ├── icons/
│   └── images/
└── pubspec.yaml
```

## 🎯 **Common Errors & Solutions**

### **Error 1: "Flutter SDK not found"**
```bash
# Fix: Set Flutter path in local.properties
echo "flutter.sdk=/opt/flutter" > android/local.properties
echo "sdk.dir=/opt/android-sdk" >> android/local.properties
```

### **Error 2: "Android SDK not found"**
```bash
# Fix: Install Android SDK components
cd /opt/android-sdk
export PATH=$PATH:cmdline-tools/latest/bin
sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"
```

### **Error 3: "Gradle build failed"**
```bash
# Fix: Clean and rebuild
cd /var/www/demo/frontend
flutter clean
flutter pub get
flutter build apk --release
```

### **Error 4: "APK not found"**
```bash
# Fix: Check build output
find /var/www/demo/frontend/build -name "*.apk"
ls -la /var/www/demo/frontend/build/app/outputs/flutter-apk/
```

## ✅ **Verification Checklist**

- [ ] Flutter SDK installed and in PATH
- [ ] Android SDK installed with required components
- [ ] Java 17 installed and JAVA_HOME set
- [ ] Project structure complete (android folder, etc.)
- [ ] pubspec.yaml valid and dependencies installed
- [ ] Build process completes without errors
- [ ] APK file exists and > 10MB
- [ ] APK file type is "Android application package"
- [ ] APK can be installed on Android device

## 🆘 **Emergency Fix**

Jika semua di atas gagal, gunakan script emergency:

```bash
cd /var/www/demo
# Remove corrupted files
rm -f pinjol-app.apk
rm -rf frontend/build/

# Setup fresh project
./setup_flutter_project.sh

# Build new APK
./build_apk.sh
```

## 📞 **Support**

Jika masih ada masalah:
1. Check logs: `flutter logs`
2. Check Flutter doctor: `flutter doctor -v`
3. Check build output: `flutter build apk --verbose`
4. Verify Android SDK: `sdkmanager --list`

---

**Last Updated**: August 3, 2025  
**Status**: Ready for troubleshooting 