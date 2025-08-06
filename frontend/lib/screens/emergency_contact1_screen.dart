import '../services/api_service.dart';
import '../models/user_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EmergencyContact1Screen extends StatefulWidget {
  @override
  _EmergencyContact1ScreenState createState() => _EmergencyContact1ScreenState();
}

class _EmergencyContact1ScreenState extends State<EmergencyContact1Screen> {
  bool isSubmitting = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String? selectedRelationship;
  
  final List<String> relationshipOptions = [
    'Pasangan',
    'Orang Tua',
    'Anak',
    'Saudara Laki-laki',
    'Saudara Perempuan',
    'Kerabat',
    'Teman',
    'Rekan Kerja',
    'Lainnya',
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
            
            // Progress Bar
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.trending_up, color: Colors.blue[600], size: 24),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Lengkapi informasi berikutnya, tingkat keberhasilan meminjam dana 80%',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  
                  // Loan Amount Slider
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.attach_money, color: Colors.orange[600], size: 24),
                            SizedBox(width: 10),
                            Text(
                              'Rp 2.500.000',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange[600],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        
                        // Progress Bar
                        Container(
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: 0.5, // 50% progress
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.blue[600],
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Rp 2.500.000', style: TextStyle(fontSize: 12)),
                            Text('Rp 5.000.000', style: TextStyle(fontSize: 12)),
                            Text('Rp 10.000.000', style: TextStyle(fontSize: 12)),
                            Text('****', style: TextStyle(fontSize: 12)),
                          ],
                        ),
                      ],
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
                        'Kontak Darurat 1',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 20),
                      
                      // Name Field
                      _buildTextField(
                        'Nama',
                        _nameController,
                        Icons.person,
                        () => _selectContact(),
                      ),
                      SizedBox(height: 15),
                      
                      // Phone Field
                      _buildTextField(
                        'Nomor ponsel',
                        _phoneController,
                        Icons.phone,
                        null,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      ),
                      SizedBox(height: 15),
                      
                      // Relationship Field
                      _buildDropdownField(
                        'Hubungan',
                        selectedRelationship,
                        () => _showRelationshipPicker(),
                        Icons.family_restroom,
                      ),
                      SizedBox(height: 30),
                      
                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _handleSubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[600],
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
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
    IconData icon,
    VoidCallback? onContactSelect, {
    TextInputType? keyboardType,
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
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 15),
                child: Icon(icon, color: Colors.grey[600], size: 20),
              ),
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: keyboardType,
                  inputFormatters: inputFormatters,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 18),
                    hintText: 'Masukkan $label',
                    hintStyle: TextStyle(color: Colors.grey[500]),
                  ),
                ),
              ),
              if (onContactSelect != null)
                IconButton(
                  icon: Icon(Icons.contacts, color: Colors.blue[600], size: 20),
                  onPressed: onContactSelect,
                ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildDropdownField(String label, String? value, VoidCallback onTap, IconData icon) {
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
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 18),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(icon, color: Colors.grey[600], size: 20),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    value ?? 'Pilih $label',
                    style: TextStyle(
                      fontSize: 16,
                      color: value != null ? Colors.black87 : Colors.grey[500],
                    ),
                  ),
                ),
                Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
              ],
            ),
          ),
        ),
      ],
    );
  }
  
  void _selectContact() {
    // Simulate contact selection
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Pilih Kontak'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Budi Santoso'),
              subtitle: Text('081234567890'),
              onTap: () {
                setState(() {
                  _nameController.text = 'Budi Santoso';
                  _phoneController.text = '081234567890';
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Siti Rahma'),
              subtitle: Text('081234567891'),
              onTap: () {
                setState(() {
                  _nameController.text = 'Siti Rahma';
                  _phoneController.text = '081234567891';
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal'),
          ),
        ],
      ),
    );
  }
  
  void _showRelationshipPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Pilih Hubungan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: relationshipOptions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(relationshipOptions[index]),
                    onTap: () {
                      setState(() {
                        selectedRelationship = relationshipOptions[index];
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _handleSubmit() {
    // Validasi form
    if (_nameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        selectedRelationship == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Mohon lengkapi semua data kontak darurat'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    if (_phoneController.text.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Nomor telepon tidak valid'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    // Navigate to next screen
    Navigator.pushReplacementNamed(context, '/emergency-contact2');
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
} 