import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/privacy_policy_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/loan_amount_screen.dart';
import 'screens/phone_login_screen.dart';
import 'screens/otp_verification_screen.dart';
import 'screens/main_dashboard_screen.dart';
import 'screens/permission_request_screen.dart';
import 'screens/personal_info_screen.dart';
import 'screens/emergency_contact1_screen.dart';
import 'screens/emergency_contact2_screen.dart';
import 'screens/face_verification_screen.dart';
import 'screens/ktp_upload_screen.dart';
import 'screens/ktp_review_screen.dart';
import 'screens/identity_review_screen.dart';
import 'screens/bank_info_screen.dart';
import 'screens/loan_success_screen.dart';
import 'screens/loan_products_screen.dart';
import 'screens/loan_status_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();
  runApp(PinjolApp());
}

class PinjolApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TukangUtang',
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: Colors.green,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      initialRoute: '/privacy',
      routes: {
        '/privacy': (context) => PrivacyPolicyScreen(),
        '/welcome': (context) => WelcomeScreen(),
        '/loan-amount': (context) => LoanAmountScreen(),
        '/phone-login': (context) => PhoneLoginScreen(),
        '/otp-verification': (context) => OtpVerificationScreen(),
        '/main-dashboard': (context) => MainDashboardScreen(),
        '/permission-request': (context) => PermissionRequestScreen(),
        '/personal-info': (context) => PersonalInfoScreen(),
        '/emergency-contact1': (context) => EmergencyContact1Screen(),
        '/emergency-contact2': (context) => EmergencyContact2Screen(),
        '/face-verification': (context) => FaceVerificationScreen(),
        '/ktp-upload': (context) => KtpUploadScreen(),
        '/ktp-review': (context) => KtpReviewScreen(),
        '/identity-review': (context) => IdentityReviewScreen(),
        '/bank-info': (context) => BankInfoScreen(),
        '/loan-success': (context) => LoanSuccessScreen(),
        '/loan-products': (context) => LoanProductsScreen(),
        '/loan-status': (context) => LoanStatusScreen(),
      },
    );
  }
}