import '../services/api_service.dart';
import '../models/user_data.dart';
import 'package:flutter/material.dart';

class LoanProductsScreen extends StatefulWidget {
  @override
  _LoanProductsScreenState createState() => _LoanProductsScreenState();
}

class _LoanProductsScreenState extends State<LoanProductsScreen> {

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
  final List<Map<String, dynamic>> loanProducts = [
    {
      'name': 'AdaKami',
      'logo': 'NK',
      'rating': 4.7,
      'maxAmount': 'Rp 80.000.000',
      'color': Colors.blue,
    },
    {
      'name': 'PinjamYuk',
      'logo': 'PY',
      'rating': 4.6,
      'maxAmount': 'Rp 10.000.000',
      'color': Colors.blue,
    },
    {
      'name': 'Cairin',
      'logo': 'C',
      'rating': 4.8,
      'maxAmount': 'Rp 7.000.000',
      'color': Colors.blue,
    },
    {
      'name': 'SINGA',
      'logo': 'S',
      'rating': 4.0,
      'maxAmount': 'Rp 20.000.000',
      'color': Colors.blue,
    },
    {
      'name': 'Moxa',
      'logo': 'M',
      'rating': 4.9,
      'maxAmount': 'Rp 2.000.000',
      'color': Colors.blue,
    },
    {
      'name': 'Samir',
      'logo': 'S',
      'rating': 4.9,
      'maxAmount': 'Rp 20.000.000',
      'color': Colors.orange,
    },
    {
      'name': 'KreditPintar',
      'logo': 'KP',
      'rating': 4.5,
      'maxAmount': 'Rp 15.000.000',
      'color': Colors.purple,
    },
    {
      'name': 'Danamas',
      'logo': 'D',
      'rating': 4.3,
      'maxAmount': 'Rp 25.000.000',
      'color': Colors.red,
    },
    {
      'name': 'Kredivo',
      'logo': 'K',
      'rating': 4.4,
      'maxAmount': 'Rp 30.000.000',
      'color': Colors.blue,
    },
    {
      'name': 'HomeCredit',
      'logo': 'HC',
      'rating': 4.2,
      'maxAmount': 'Rp 50.000.000',
      'color': Colors.orange,
    },
  ];

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
                    'AyoPinjam',
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
                    child: Icon(Icons.person, color: Colors.white, size: 20),
                  ),
                ],
              ),
            ),
            
            // Content
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(20),
                itemCount: loanProducts.length,
                itemBuilder: (context, index) {
                  final product = loanProducts[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 15),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            // Logo
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: product['color'],
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Center(
                                child: Text(
                                  product['logo'],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 15),
                            
                            // Product Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product['name'],
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  
                                  // Rating
                                  Row(
                                    children: [
                                      Text(
                                        '${product['rating']}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.orange[600],
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      ...List.generate(5, (starIndex) {
                                        if (starIndex < product['rating'].floor()) {
                                          return Icon(Icons.star, color: Colors.orange, size: 16);
                                        } else if (starIndex == product['rating'].floor() && 
                                                 product['rating'] % 1 > 0) {
                                          return Icon(Icons.star_half, color: Colors.orange, size: 16);
                                        } else {
                                          return Icon(Icons.star_border, color: Colors.orange, size: 16);
                                        }
                                      }),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  
                                  Text(
                                    'Jumlah maksimum',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  Text(
                                    product['maxAmount'],
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            // Download Button
                            ElevatedButton(
                              onPressed: () => _downloadProduct(product['name']),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[600],
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                'Unduh',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        SizedBox(height: 15),
                        
                        // Disclaimer
                        Text(
                          'APP hanya merekomendasikan lembaga keuangan kepada Anda dan tidak berpartisipasi dalam pemberian pinjaman.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            
            // Bottom Navigation
            Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(0, -1),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem(Icons.home, 'Pinjaman', true),
                  _buildNavItem(Icons.account_balance_wallet, 'Produk Anggota', false),
                  _buildNavItem(Icons.payment, 'Pembayaran', false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: isActive ? Colors.blue[600] : Colors.grey[600],
          size: 24,
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.blue[600] : Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }
  
  void _downloadProduct(String productName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Download $productName'),
        content: Text('Aplikasi $productName akan diunduh. Lanjutkan?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Mengunduh aplikasi $productName...'),
                  backgroundColor: Colors.blue,
                ),
              );
            },
            child: Text('Unduh'),
          ),
        ],
      ),
    );
  }
} 