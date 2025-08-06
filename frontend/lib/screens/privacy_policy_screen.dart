import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/user_data.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  @override
  _PrivacyPolicyScreenState createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  bool isAgreed = false;
  bool isSubmitting = false;

  Future<void> _handleSubmit() async {
    setState(() {
      isSubmitting = true;
    });

    try {
      // Create initial user data with minimal required fields
      UserData userData = UserData(
        phoneNumber: 'pending', // Temporary placeholder
        applicationDate: DateTime.now(),
        loanStatus: 'pending',
        locationPermission: false,
        cameraPermission: false,
        contactsPermission: false,
        phonePermission: false,
        storagePermission: false,
      );

      // Submit form data to backend
      await ApiService.submitFormData(userData);
      
      // Navigate to next page
      Navigator.pushReplacementNamed(context, '/welcome');
    } catch (e) {
      // Show error message with more details
      String errorMessage = 'Error submitting data';
      if (e.toString().contains('404')) {
        errorMessage = 'Server endpoint not found. Please check your connection.';
      } else if (e.toString().contains('Network error')) {
        errorMessage = 'Network connection error. Please check your internet connection.';
      } else {
        errorMessage = 'Error: ${e.toString()}';
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
        ),
      );
    } finally {
      setState(() {
        isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Header
              Row(
                children: [
                  Icon(Icons.security, color: Colors.green, size: 30),
                  SizedBox(width: 10),
                  Text(
                    'Permohonan Izin',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              
              // Main Content
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Untuk memberikan layanan pinjaman berkualitas tinggi kepada pengguna, meningkatkan pengalaman pinjaman dan memastikan keamanan layanan, aplikasi TukangUtang (selanjutnya disebut "kami") akan mengumpulkan dan memproses informasi pengguna yang diperlukan sesuai dengan hukum dan peraturan yang relevan. Kami berjanji untuk menggunakan informasi Anda secara legal, sah dan dengan izin, dan mengambil langkah-langkah keamanan yang ketat untuk melindungi keamanan data Anda.',
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.5,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 20),
                        
                        Text(
                          '1. Informasi yang Kami Kumpulkan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 10),
                        
                        Text(
                          '• Informasi Pribadi: nama, nomor telepon, alamat, tanggal lahir\n'
                          '• Informasi Identitas: foto KTP, selfie, nomor KTP\n'
                          '• Informasi Kontak: kontak darurat, buku kontak\n'
                          '• Informasi Lokasi: GPS untuk verifikasi\n'
                          '• Informasi Perangkat: IMEI, model perangkat, versi OS\n'
                          '• Informasi Keuangan: data bank, riwayat pinjaman',
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.5,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 20),
                        
                        Text(
                          '2. Tujuan Penggunaan Data',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 10),
                        
                        Text(
                          '• Verifikasi identitas dan kelayakan kredit\n'
                          '• Proses pengajuan dan pencairan pinjaman\n'
                          '• Monitoring dan pengelolaan pinjaman\n'
                          '• Pencegahan penipuan dan pencucian uang\n'
                          '• Peningkatan layanan dan pengalaman pengguna',
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.5,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 20),
                        
                        Text(
                          '3. Keamanan Data',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 10),
                        
                        Text(
                          'Kami menggunakan teknologi enkripsi tingkat tinggi dan protokol keamanan yang ketat untuk melindungi data Anda dari akses yang tidak sah, penggunaan yang tidak tepat, atau kebocoran data.',
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.5,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              SizedBox(height: 20),
              
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // User tidak setuju - keluar dari aplikasi
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.grey[600],
                        side: BorderSide(color: Colors.green),
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Tidak setuju',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: isSubmitting ? null : _handleSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
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
                                Text(
                                  'Mengirim...',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            )
                          : Text(
                              'Setuju',
                              style: TextStyle(fontSize: 16),
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
} 