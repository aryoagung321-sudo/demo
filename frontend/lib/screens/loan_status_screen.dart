import '../services/api_service.dart';
import '../models/user_data.dart';
import 'package:flutter/material.dart';

class LoanStatusScreen extends StatefulWidget {
  @override
  _LoanStatusScreenState createState() => _LoanStatusScreenState();
}

class _LoanStatusScreenState extends State<LoanStatusScreen> {

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
  int _selectedTabIndex = 2; // Default to "Jatuh tempo" tab
  
  final List<String> tabLabels = ['Lunas', 'Belum bayar', 'Jatuh tempo', 'Menunggu disetujui'];
  
  final List<Map<String, dynamic>> loanData = [
    {
      'name': 'Pinjaman Lancar',
      'icon': Icons.attach_money,
      'iconColor': Colors.purple,
      'status': 'Jatuh tempo',
      'statusColor': Colors.red,
      'amount': 'Rp 1.800.000',
      'dueDate': '16-05-2025',
      'dueDateColor': Colors.red,
    },
    {
      'name': 'Modal Fresh--Koperasi',
      'icon': Icons.account_balance_wallet,
      'iconColor': Colors.purple,
      'status': 'Jatuh tempo',
      'statusColor': Colors.red,
      'amount': 'Rp 1.800.000',
      'dueDate': '20-05-2025',
      'dueDateColor': Colors.red,
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
            
            // Tab Navigation
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: tabLabels.asMap().entries.map((entry) {
                  int index = entry.key;
                  String label = entry.value;
                  bool isSelected = _selectedTabIndex == index;
                  
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedTabIndex = index;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: isSelected ? Colors.blue[600]! : Colors.transparent,
                              width: 2,
                            ),
                          ),
                        ),
                        child: Text(
                          label,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? Colors.blue[600] : Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            
            // Warning Banner
            Container(
              padding: EdgeInsets.all(15),
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.yellow[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning, color: Colors.orange[600], size: 20),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Hati-hati terhadap modus penipuan 2、Seluruh informasi potongan pembayaran',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange[800],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Loan List
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 20),
                itemCount: loanData.length,
                itemBuilder: (context, index) {
                  final loan = loanData[index];
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
                            // Loan Icon
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: loan['iconColor'].withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                loan['icon'],
                                color: loan['iconColor'],
                                size: 24,
                              ),
                            ),
                            SizedBox(width: 15),
                            
                            // Loan Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    loan['name'],
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: loan['statusColor'].withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          loan['status'],
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: loan['statusColor'],
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        loan['amount'],
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  
                                  Text(
                                    'Jatuh tempo: ${loan['dueDate']}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: loan['dueDateColor'],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            // Payment Button
                            ElevatedButton(
                              onPressed: () => _handlePayment(loan['name']),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[600],
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                'Pembayaran',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            
            // Warning Box
            Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.orange[200]!),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.orange[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.chat_bubble_outline,
                      color: Colors.orange[600],
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      'Jangan memberikan informasi pinjaman dan kode verifikasi Anda kepada siapa pun',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange[800],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Disclaimer
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                'Kami tidak terlibat dalam proses pencairan penagihan yang dilakukan pihak pemilik produk',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
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
                  _buildNavItem(Icons.home, 'Pinjaman', false),
                  _buildNavItem(Icons.account_balance_wallet, 'Produk Anggota', false),
                  _buildNavItem(Icons.payment, 'Pembayaran', true),
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
  
  void _handlePayment(String loanName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Pembayaran $loanName'),
        content: Text('Anda akan diarahkan ke halaman pembayaran untuk $loanName. Lanjutkan?'),
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
                  content: Text('Mengarahkan ke halaman pembayaran...'),
                  backgroundColor: Colors.blue,
                ),
              );
            },
            child: Text('Lanjut'),
          ),
        ],
      ),
    );
  }
} 