#!/bin/bash

echo "🔄 UPDATING ALL SCREENS TO 'TukangUtang'"
echo "========================================="

cd /var/www/demo/frontend/lib/screens

# Function to update app name in a screen
update_screen() {
    local file=$1
    local screen_name=$2
    
    echo "📱 Updating $screen_name..."
    
    # Replace PinjamPasti with TukangUtang
    sed -i 's/PinjamPasti/TukangUtang/g' "$file"
    
    # Replace Pinjol App with TukangUtang
    sed -i 's/Pinjol App/TukangUtang/g' "$file"
    
    # Update color scheme from green to blue
    sed -i 's/Colors\.green\[/Colors.blue[/g' "$file"
    sed -i 's/Colors\.green/Colors.blue/g' "$file"
}

# Update all screens
update_screen "main_dashboard_screen.dart" "Main Dashboard Screen"
update_screen "loan_amount_screen.dart" "Loan Amount Screen"
update_screen "personal_info_screen.dart" "Personal Info Screen"
update_screen "emergency_contact1_screen.dart" "Emergency Contact 1 Screen"
update_screen "emergency_contact2_screen.dart" "Emergency Contact 2 Screen"
update_screen "face_verification_screen.dart" "Face Verification Screen"
update_screen "ktp_upload_screen.dart" "KTP Upload Screen"
update_screen "ktp_review_screen.dart" "KTP Review Screen"
update_screen "identity_review_screen.dart" "Identity Review Screen"
update_screen "bank_info_screen.dart" "Bank Info Screen"
update_screen "loan_success_screen.dart" "Loan Success Screen"
update_screen "loan_products_screen.dart" "Loan Products Screen"
update_screen "loan_status_screen.dart" "Loan Status Screen"

echo "✅ All screens updated!"
echo "📱 Now building APK with new name 'TukangUtang'..."

cd /var/www/demo

# Build APK
echo "🔧 Building APK..."
cd frontend

# Clean and get dependencies
flutter clean
flutter pub get

# Build release APK
flutter build apk --release

# Check if build was successful
if [ -f "build/app/outputs/flutter-apk/app-release.apk" ]; then
    echo "✅ APK built successfully!"
    
    # Copy to main directory
    cp build/app/outputs/flutter-apk/app-release.apk /var/www/demo/tukangutang_app_release.apk
    
    # Copy to public folder for download
    cp build/app/outputs/flutter-apk/app-release.apk /var/www/demo/dashboard-frontend/public/tukangutang_app_release.apk
    
    # Get file size
    APK_SIZE=$(du -h /var/www/demo/tukangutang_app_release.apk | cut -f1)
    
    echo "🎉 SUCCESS! APK 'TukangUtang' ready for installation"
    echo "📱 File: /var/www/demo/tukangutang_app_release.apk"
    echo "📏 Size: $APK_SIZE"
    echo "🌐 Download URL: https://d.seoikrom.com/tukangutang_app_release.apk"
    echo "💡 Note: This is a release APK with new name 'TukangUtang'"
else
    echo "❌ APK build failed!"
    exit 1
fi 