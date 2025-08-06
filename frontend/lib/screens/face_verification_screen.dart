import '../services/api_service.dart';
import '../models/user_data.dart';
import 'package:flutter/material.dart';

class FaceVerificationScreen extends StatefulWidget {
  @override
  _FaceVerificationScreenState createState() => _FaceVerificationScreenState();
}

class _FaceVerificationScreenState extends State<FaceVerificationScreen> {

  Future<void> _handleSubmit() async {
    setState(() {
      isSubmitting = true;
    });

    try {
      // Create user data with current form data
      UserData userData = UserData(
        phoneNumber: '', // Will be filled in later
        applicationDate: DateTime.now(),
      );

      // Submit form data to backend
      await ApiService.submitFormData(userData);
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Data berhasil dikirim!'),
          backgroundColor: Colors.blue,
        ),
      );
      
      // Navigate to next page or stay on current page
      // Navigator.pushReplacementNamed(context, '/next-page');
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
  bool isSubmitting = false;
  bool _isDetecting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              color: Colors.blue[600],
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
            
            // Instructions
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    'Masukkan wajah ke dalam bingkai, ikuti instruksi.',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Mohon jaga privasi, jangan telanjang',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            // Face Detection Frame
            Expanded(
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Face Frame
                    Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue, width: 3, style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(125),
                      ),
                      child: Stack(
                        children: [
                          // Corner markers
                          Positioned(
                            top: 10,
                            left: 10,
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(color: Colors.blue, width: 3),
                                  left: BorderSide(color: Colors.blue, width: 3),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(color: Colors.blue, width: 3),
                                  right: BorderSide(color: Colors.blue, width: 3),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            left: 10,
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: Colors.blue, width: 3),
                                  left: BorderSide(color: Colors.blue, width: 3),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            right: 10,
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: Colors.blue, width: 3),
                                  right: BorderSide(color: Colors.blue, width: 3),
                                ),
                              ),
                            ),
                          ),
                          
                          // Face silhouette guide
                          Center(
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.person,
                                size: 80,
                                color: Colors.blue.withOpacity(0.3),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    
                    // Prohibited Conditions
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildProhibitedItem(Icons.face, 'tidak bisa memakai masker'),
                        _buildProhibitedItem(Icons.face, 'tidak boleh memakai topi'),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildProhibitedItem(Icons.wb_sunny, 'tidak terlalu gelap'),
                        _buildProhibitedItem(Icons.person, 'jangan telanjang'),
                      ],
                    ),
                    SizedBox(height: 40),
                    
                    // Start Detection Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isDetecting ? null : _startDetection,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[600],
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isDetecting
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'Mendeteksi...',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              )
                            : Text(
                                'Mulai deteksi',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Footer
            Container(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  Icon(Icons.lock, color: Colors.blue[600], size: 16),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Keamanan data dilindungi platform',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildProhibitedItem(IconData icon, String text) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.blue[50],
            shape: BoxShape.circle,
          ),
          child: Stack(
            children: [
              Center(
                child: Icon(
                  icon,
                  color: Colors.blue[600],
                  size: 30,
                ),
              ),
              Center(
                child: Icon(
                  Icons.close,
                  color: Colors.red[600],
                  size: 40,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[700],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
  
  void _startDetection() async {
    setState(() {
      _isDetecting = true;
    });
    
    // Simulate face detection process
    await Future.delayed(Duration(seconds: 3));
    
    setState(() {
      _isDetecting = false;
    });
    
    // Show success dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Verifikasi Wajah Berhasil'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.blue,
                size: 50,
              ),
              SizedBox(height: 10),
              Text(
                'Wajah Anda telah berhasil diverifikasi. Silakan lanjutkan ke langkah berikutnya.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, '/ktp-upload');
              },
              child: Text('Lanjut'),
            ),
          ],
        );
      },
    );
  }
} 