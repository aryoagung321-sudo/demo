import '../services/api_service.dart';
import '../models/user_data.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionRequestScreen extends StatefulWidget {
  @override
  _PermissionRequestScreenState createState() => _PermissionRequestScreenState();
}

class _PermissionRequestScreenState extends State<PermissionRequestScreen> {
  bool isSubmitting = false;
  int currentStep = 1;
  int totalSteps = 5; // Increased to cover all permissions
  List<String> permissionStatus = ['pending', 'pending', 'pending', 'pending', 'pending'];
  
  final List<Map<String, dynamic>> permissions = [
    {
      'name': 'Lokasi',
      'permission': Permission.location,
      'icon': Icons.location_on,
      'description': 'Izinkan TukangUtang mengakses lokasi Anda?'
    },
    {
      'name': 'Kamera',
      'permission': Permission.camera,
      'icon': Icons.camera_alt,
      'description': 'Izinkan TukangUtang mengakses kamera?'
    },
    {
      'name': 'Kontak',
      'permission': Permission.contacts,
      'icon': Icons.contacts,
      'description': 'Izinkan TukangUtang mengakses kontak?'
    },
    {
      'name': 'Telepon',
      'permission': Permission.phone,
      'icon': Icons.phone,
      'description': 'Izinkan TukangUtang mengakses telepon?'
    },
    {
      'name': 'Penyimpanan',
      'permission': Permission.storage,
      'icon': Icons.storage,
      'description': 'Izinkan TukangUtang mengakses penyimpanan?'
    }
  ];

  Future<void> _handleSubmit() async {
    setState(() {
      isSubmitting = true;
    });

    try {
      // Create user data with permission status
      UserData userData = UserData(
        phoneNumber: '', // Will be filled in later
        applicationDate: DateTime.now(),
        locationPermission: permissionStatus[0] == 'granted',
        cameraPermission: permissionStatus[1] == 'granted',
        contactsPermission: permissionStatus[2] == 'granted',
        phonePermission: permissionStatus[3] == 'granted',
        storagePermission: permissionStatus[4] == 'granted',
      );

      // Submit form data to backend
      await ApiService.submitFormData(userData);
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Permission data berhasil dikirim!'),
          backgroundColor: Colors.green,
        ),
      );
      
      // Navigate to next page
      Navigator.pushReplacementNamed(context, '/personal-info');
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ' + e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isSubmitting = false;
      });
    }
  }

  Future<void> _requestPermission(int index) async {
    try {
      final permission = permissions[index]['permission'];
      final status = await permission.request();
      
      setState(() {
        if (status.isGranted) {
          permissionStatus[index] = 'granted';
        } else {
          permissionStatus[index] = 'denied';
        }
      });
      
      // Auto proceed to next permission after a short delay
      if (index < totalSteps - 1) {
        Future.delayed(Duration(seconds: 1), () {
          setState(() {
            currentStep = index + 2;
          });
        });
      }
    } catch (e) {
      setState(() {
        permissionStatus[index] = 'error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              color: Colors.green[600],
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  Icon(Icons.arrow_back, color: Colors.white, size: 24),
                  SizedBox(width: 15),
                  Text(
                    'TukangUtang',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(Icons.headphones, color: Colors.white, size: 20),
                  ),
                ],
              ),
            ),
            
            // Main Content
            Expanded(
              child: Center(
                child: Container(
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Permission Icon
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Icon(
                          permissions[currentStep - 1]['icon'],
                          color: Colors.green[600],
                          size: 40,
                        ),
                      ),
                      SizedBox(height: 20),
                      
                      // Permission Text
                      Text(
                        permissions[currentStep - 1]['description'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                          height: 1.3,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 30),
                      
                      // Step Indicator
                      Row(
                        children: [
                          Text(
                            '$currentStep dari $totalSteps',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                      SizedBox(height: 20),
                      
                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                // User menolak permission
                                _requestPermission(currentStep - 1);
                              },
                              child: Text(
                                'TOLAK',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[600],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                // User mengizinkan permission
                                _requestPermission(currentStep - 1);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green[600],
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                'IZINKAN',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      // Submit Button (show when all permissions are handled)
                      if (currentStep > totalSteps)
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(top: 20),
                          child: ElevatedButton(
                            onPressed: isSubmitting ? null : _handleSubmit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[600],
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: isSubmitting
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Text('Mengirim...'),
                                    ],
                                  )
                                : Text(
                                    'LANJUTKAN',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 