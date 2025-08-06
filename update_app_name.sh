#!/bin/bash

echo "🔄 UPDATING APP NAME TO 'TukangUtang'"
echo "======================================"

cd /var/www/demo/frontend/lib/screens

# Function to update app name in a screen
update_app_name() {
    local file=$1
    local screen_name=$2
    
    echo "📱 Updating $screen_name..."
    
    # Replace PinjamPasti with TukangUtang
    sed -i 's/PinjamPasti/TukangUtang/g' "$file"
    
    # Replace Pinjol App with TukangUtang
    sed -i 's/Pinjol App/TukangUtang/g' "$file"
}

# Update all screens
update_app_name "welcome_screen.dart" "Welcome Screen"
update_app_name "loan_amount_screen.dart" "Loan Amount Screen"
update_app_name "phone_login_screen.dart" "Phone Login Screen"
update_app_name "otp_verification_screen.dart" "OTP Verification Screen"
update_app_name "main_dashboard_screen.dart" "Main Dashboard Screen"
update_app_name "personal_info_screen.dart" "Personal Info Screen"
update_app_name "emergency_contact1_screen.dart" "Emergency Contact 1 Screen"
update_app_name "emergency_contact2_screen.dart" "Emergency Contact 2 Screen"
update_app_name "face_verification_screen.dart" "Face Verification Screen"
update_app_name "ktp_upload_screen.dart" "KTP Upload Screen"
update_app_name "ktp_review_screen.dart" "KTP Review Screen"
update_app_name "identity_review_screen.dart" "Identity Review Screen"
update_app_name "bank_info_screen.dart" "Bank Info Screen"
update_app_name "loan_success_screen.dart" "Loan Success Screen"
update_app_name "loan_products_screen.dart" "Loan Products Screen"
update_app_name "loan_status_screen.dart" "Loan Status Screen"

echo "✅ App name updated in all screens!"
echo "📱 Now building APK with new name..."

cd /var/www/demo
./build_apk_release.sh

echo "🎉 APK 'TukangUtang' has been built successfully!" 