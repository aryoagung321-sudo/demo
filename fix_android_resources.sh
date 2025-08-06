#!/bin/bash

echo "🔧 FIXING ANDROID RESOURCES"
echo "============================"

cd /var/www/demo/frontend

echo "📁 Creating missing resource directories..."
mkdir -p android/app/src/main/res/mipmap-hdpi
mkdir -p android/app/src/main/res/mipmap-mdpi
mkdir -p android/app/src/main/res/mipmap-xhdpi
mkdir -p android/app/src/main/res/mipmap-xxhdpi
mkdir -p android/app/src/main/res/mipmap-xxxhdpi

echo "🖼️ Copying icons to resource directories..."
cp assets/icons/icon.png android/app/src/main/res/mipmap-hdpi/ic_launcher.png
cp assets/icons/icon.png android/app/src/main/res/mipmap-mdpi/ic_launcher.png
cp assets/icons/icon.png android/app/src/main/res/mipmap-xhdpi/ic_launcher.png
cp assets/icons/icon.png android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png
cp assets/icons/icon.png android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png

echo "🎨 Creating styles.xml..."
cat > android/app/src/main/res/values/styles.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <!-- Theme applied to the Android Window while the process is starting when the OS's Dark Mode setting is off -->
    <style name="LaunchTheme" parent="@android:style/Theme.Light.NoTitleBar">
        <item name="android:windowBackground">@drawable/launch_background</item>
    </style>
    <!-- Theme applied to the Android Window as soon as the process has started.
         This theme determines the color of the Android Window while your
         Flutter UI initializes, as well as behind your Flutter UI while its
         running. -->
    <style name="NormalTheme" parent="@android:style/Theme.Light.NoTitleBar">
        <item name="android:windowBackground">?android:colorBackground</item>
    </style>
</resources>
EOF

echo "🖼️ Creating launch_background.xml..."
cat > android/app/src/main/res/drawable/launch_background.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<layer-list xmlns:android="http://schemas.android.com/apk/res/android">
    <item android:drawable="@android:color/white" />
</layer-list>
EOF

echo "✅ Android resources fixed!"
echo "📋 Now you can build the APK again" 