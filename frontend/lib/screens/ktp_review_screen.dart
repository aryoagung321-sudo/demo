import '../services/api_service.dart';
import '../models/user_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class KtpReviewScreen extends StatefulWidget {
  @override
  _KtpReviewScreenState createState() => _KtpReviewScreenState();
}

class _KtpReviewScreenState extends State<KtpReviewScreen> {
  bool isSubmitting = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ktpNumberController = TextEditingController();
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill with data from previous screen
    _nameController.text = 'Budi Santoso';
    _ktpNumberController.text = '3571234567890123';
  }

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
            
            // Instructions Banner
            Container(
              padding: EdgeInsets.all(15),
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.orange[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.orange[600], size: 20),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Unggah foto KTP asli dan isi informasi KTP',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.orange[800],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Form Content
            Expanded(
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Foto KTP: halaman depan',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: 15),
                      
                      // KTP Photo Upload Area
                      Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!, width: 2, style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Stack(
                          children: [
                            // KTP Template
                            Container(
                              padding: EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'PROVINCE JAWA TIMUR',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'XXX XXXXX XXXXX',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'NIK : XXXXXXXXXXXXX',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    width: double.infinity,
                                    height: 1,
                                    color: Colors.grey[300],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      for (int i = 0; i < 5; i++)
                                        Container(
                                          width: 40,
                                          height: 1,
                                          color: Colors.grey[300],
                                          margin: EdgeInsets.only(right: 10),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            
                            // Photo area
                            Positioned(
                              top: 10,
                              right: 10,
                              child: Container(
                                width: 60,
                                height: 80,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[300]!),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.person,
                                  color: Colors.grey[400],
                                  size: 30,
                                ),
                              ),
                            ),
                            
                            // Upload Button
                            Center(
                              child: Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.camera_alt,
                                    color: Colors.grey[600],
                                    size: 40,
                                  ),
                                  onPressed: _isUploading ? null : _uploadKtpPhoto,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                      
                      Text(
                        'Pastikan nomor KTP sesuai dengan foto atau pengajuan akan ditolak.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 30),
                      
                      // Name Field
                      _buildTextField(
                        'Nama Sesuai KTP',
                        _nameController,
                        Icons.person,
                      ),
                      SizedBox(height: 15),
                      
                      // KTP Number Field
                      _buildTextField(
                        'Nomor KTP',
                        _ktpNumberController,
                        Icons.credit_card,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      ),
                      SizedBox(height: 30),
                      
                      // Security Info
                      Row(
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
                      SizedBox(height: 30),
                      
                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isUploading ? null : _handleSubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[600],
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isUploading
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
                                      'Mengunggah...',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                )
                              : Text(
                                  'Lanjut',
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
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon, {
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: controller,
            inputFormatters: inputFormatters,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 18),
              hintText: 'Masukkan $label',
              hintStyle: TextStyle(color: Colors.grey[500]),
              prefixIcon: Icon(icon, color: Colors.grey[600], size: 20),
            ),
          ),
        ),
      ],
    );
  }
  
  void _uploadKtpPhoto() async {
    setState(() {
      _isUploading = true;
    });
    
    // Simulate photo upload and OCR process
    await Future.delayed(Duration(seconds: 2));
    
    // Simulate OCR results
    setState(() {
      _nameController.text = 'Budi Santoso';
      _ktpNumberController.text = '3571234567890123';
      _isUploading = false;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Foto KTP berhasil diunggah dan data telah terisi otomatis'),
        backgroundColor: Colors.blue,
      ),
    );
  }
  
  void _handleSubmit() {
    // Validasi form
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Mohon masukkan nama sesuai KTP'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    if (_ktpNumberController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Mohon masukkan nomor KTP'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    if (_ktpNumberController.text.length != 16) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Nomor KTP harus 16 digit'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    // Navigate to next screen
    Navigator.pushReplacementNamed(context, '/identity-review');
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _ktpNumberController.dispose();
    super.dispose();
  }
} 