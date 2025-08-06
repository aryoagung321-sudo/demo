# 🔧 APK Build Issues & Solutions

## ❌ **Masalah Build APK**

### **Issue 1: Flutter Command Not Working**
```bash
# Error: flutter command not found or not working
# Solution: Check Flutter installation
ls -la /opt/flutter/bin/flutter
/opt/flutter/bin/flutter --version
```

### **Issue 2: Android SDK Missing Components**
```bash
# Error: Android SDK not properly configured
# Solution: Install required components
cd /opt/android-sdk
export PATH=$PATH:cmdline-tools/latest/bin
sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"
```

### **Issue 3: Project Structure Incomplete**
```bash
# Error: Missing Android folder or configuration files
# Solution: Create complete project structure
cd /var/www/demo/frontend
mkdir -p android/app/src/main/kotlin/com/example/pinjol_app
mkdir -p android/gradle/wrapper
mkdir -p assets/icons assets/images
```

## 🚀 **Alternative Solutions**

### **Solution 1: Manual Flutter Setup**
```bash
# Step 1: Set environment variables
export PATH="$PATH:/opt/flutter/bin"
export ANDROID_HOME=/opt/android-sdk
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64

# Step 2: Navigate to project
cd /var/www/demo/frontend

# Step 3: Get dependencies
flutter pub get

# Step 4: Build APK
flutter build apk --release
```

### **Solution 2: Use Pre-built APK**
```bash
# Download sample APK for testing
cd /var/www/demo
wget https://github.com/flutter/flutter/raw/main/examples/hello_world/build/app/outputs/flutter-apk/app-release.apk -O pinjol-app.apk
```

### **Solution 3: Create Minimal APK**
```bash
# Create a minimal working APK structure
cd /var/www/demo
mkdir -p apk_temp
cd apk_temp

# Create basic APK structure
mkdir -p META-INF
mkdir -p res
mkdir -p AndroidManifest.xml

# Create minimal APK (this is just for testing)
echo "APK placeholder for testing" > pinjol-app.apk
```

## 🔍 **Diagnosis Commands**

### **Check Flutter Installation**
```bash
# Check if Flutter is installed
ls -la /opt/flutter/bin/flutter

# Check Flutter version
/opt/flutter/bin/flutter --version

# Check Flutter doctor
/opt/flutter/bin/flutter doctor -v
```

### **Check Android SDK**
```bash
# Check Android SDK installation
ls -la /opt/android-sdk/cmdline-tools/latest/bin

# Check available platforms
ls -la /opt/android-sdk/platforms/

# Check build tools
ls -la /opt/android-sdk/build-tools/
```

### **Check Project Structure**
```bash
# Check frontend directory
cd /var/www/demo/frontend
ls -la

# Check Android folder
ls -la android/

# Check pubspec.yaml
cat pubspec.yaml
```

## 🎯 **Quick Fix Commands**

### **Fix 1: Complete Setup**
```bash
cd /var/www/demo

# Create directories
mkdir -p frontend/android/app/src/main/kotlin/com/example/pinjol_app
mkdir -p frontend/android/gradle/wrapper
mkdir -p frontend/assets/icons frontend/assets/images

# Set permissions
chmod +x build_apk_final.sh

# Run build
./build_apk_final.sh
```

### **Fix 2: Environment Setup**
```bash
# Add to ~/.bashrc or run manually
export PATH="$PATH:/opt/flutter/bin"
export ANDROID_HOME=/opt/android-sdk
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64

# Verify setup
flutter --version
echo $ANDROID_HOME
echo $JAVA_HOME
```

### **Fix 3: Clean Build**
```bash
cd /var/www/demo/frontend

# Clean everything
flutter clean
rm -rf build/
rm -rf .dart_tool/

# Rebuild
flutter pub get
flutter build apk --release
```

## 📋 **Verification Checklist**

- [ ] Flutter SDK installed at `/opt/flutter/`
- [ ] Android SDK installed at `/opt/android-sdk/`
- [ ] Java 17 installed and JAVA_HOME set
- [ ] Project structure complete
- [ ] pubspec.yaml valid
- [ ] Dependencies installed
- [ ] Build process completes
- [ ] APK file created and > 10MB
- [ ] APK can be installed on device

## 🆘 **Emergency Solutions**

### **If All Else Fails:**

1. **Use Docker for Flutter Build**
```bash
# Run Flutter in Docker container
docker run --rm -v /var/www/demo/frontend:/app -w /app cirrusci/flutter:stable flutter build apk --release
```

2. **Use Online Build Service**
- GitHub Actions
- Codemagic
- Bitrise

3. **Use Pre-built APK**
- Download sample APK
- Modify for your needs
- Test functionality

## 📞 **Next Steps**

1. **Try manual build commands**
2. **Check all prerequisites**
3. **Use alternative build methods**
4. **Consider cloud build services**

---

**Status**: Build issues identified, solutions provided  
**Last Updated**: August 3, 2025 