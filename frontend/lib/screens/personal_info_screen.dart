import '../services/api_service.dart';
import '../models/user_data.dart';
import 'package:flutter/material.dart';

class PersonalInfoScreen extends StatefulWidget {
  @override
  _PersonalInfoScreenState createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  bool isSubmitting = false;
  String? selectedDateOfBirth;
  String? selectedGender;
  String? selectedMaritalStatus;
  String? selectedProvince;
  String? selectedCity;
  String? selectedDistrict;
  String? selectedSubDistrict;
  final TextEditingController _streetAddressController = TextEditingController();
  
  final List<String> genderOptions = ['Laki-laki', 'Perempuan'];
  final List<String> maritalStatusOptions = ['Belum Menikah', 'Menikah', 'Cerai'];
  
  // Sample data untuk dropdown
  final Map<String, List<String>> provinceData = {
    'DKI Jakarta': ['Jakarta Pusat', 'Jakarta Utara', 'Jakarta Barat', 'Jakarta Selatan', 'Jakarta Timur'],
    'Jawa Barat': ['Bandung', 'Bekasi', 'Bogor', 'Cimahi', 'Cirebon'],
    'Jawa Tengah': ['Semarang', 'Solo', 'Magelang', 'Pekalongan', 'Tegal'],
  };
  
  final Map<String, List<String>> districtData = {
    'Jakarta Pusat': ['Gambir', 'Tanah Abang', 'Menteng', 'Senen', 'Cempaka Putih'],
    'Jakarta Utara': ['Penjaringan', 'Pademangan', 'Tanjung Priok', 'Koja', 'Kelapa Gading'],
    'Bandung': ['Bandung Wetan', 'Bandung Kulon', 'Bandung Kidul', 'Bandung Tengah'],
  };
  
  final Map<String, List<String>> subDistrictData = {
    'Gambir': ['Gambir', 'Cideng', 'Petojo Utara', 'Petojo Selatan'],
    'Tanah Abang': ['Kebon Melati', 'Kebon Kacang', 'Kampung Bali', 'Petamburan'],
    'Bandung Wetan': ['Citarum', 'Tamansari', 'Mulyasari', 'Cihapit'],
  };

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
                            widthFactor: 0.25, // 25% progress
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
                        'Informasi Pribadi',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 20),
                      
                      // Date of Birth
                      _buildDropdownField(
                        'Tanggal lahir',
                        selectedDateOfBirth,
                        () => _showDatePicker(),
                        Icons.calendar_today,
                      ),
                      SizedBox(height: 15),
                      
                      // Gender
                      _buildDropdownField(
                        'Jenis kelamin',
                        selectedGender,
                        () => _showGenderPicker(),
                        Icons.person,
                      ),
                      SizedBox(height: 15),
                      
                      // Marital Status
                      _buildDropdownField(
                        'Status perkawinan',
                        selectedMaritalStatus,
                        () => _showMaritalStatusPicker(),
                        Icons.favorite,
                      ),
                      SizedBox(height: 15),
                      
                      // Province
                      _buildDropdownField(
                        'Provinsi',
                        selectedProvince,
                        () => _showProvincePicker(),
                        Icons.location_on,
                      ),
                      SizedBox(height: 15),
                      
                      // City
                      _buildDropdownField(
                        'Kota/Kabupaten',
                        selectedCity,
                        () => _showCityPicker(),
                        Icons.location_city,
                      ),
                      SizedBox(height: 15),
                      
                      // District
                      _buildDropdownField(
                        'Kecamatan',
                        selectedDistrict,
                        () => _showDistrictPicker(),
                        Icons.map,
                      ),
                      SizedBox(height: 15),
                      
                      // Sub District
                      _buildDropdownField(
                        'Kelurahan',
                        selectedSubDistrict,
                        () => _showSubDistrictPicker(),
                        Icons.home,
                      ),
                      SizedBox(height: 15),
                      
                      // Street Address
                      _buildTextField(
                        'Alamat Jalan',
                        _streetAddressController,
                        Icons.home_work,
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
  
  Widget _buildTextField(String label, TextEditingController controller, IconData icon) {
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
  
  void _showDatePicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(Duration(days: 6570)), // 18 years ago
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        selectedDateOfBirth = '${picked.day}/${picked.month}/${picked.year}';
      });
    }
  }
  
  void _showGenderPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) => _buildPickerModal(
        'Pilih Jenis Kelamin',
        genderOptions,
        (value) {
          setState(() {
            selectedGender = value;
          });
        },
      ),
    );
  }
  
  void _showMaritalStatusPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) => _buildPickerModal(
        'Pilih Status Perkawinan',
        maritalStatusOptions,
        (value) {
          setState(() {
            selectedMaritalStatus = value;
          });
        },
      ),
    );
  }
  
  void _showProvincePicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) => _buildPickerModal(
        'Pilih Provinsi',
        provinceData.keys.toList(),
        (value) {
          setState(() {
            selectedProvince = value;
            selectedCity = null;
            selectedDistrict = null;
            selectedSubDistrict = null;
          });
        },
      ),
    );
  }
  
  void _showCityPicker() {
    if (selectedProvince == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pilih provinsi terlebih dahulu')),
      );
      return;
    }
    
    showModalBottomSheet(
      context: context,
      builder: (context) => _buildPickerModal(
        'Pilih Kota/Kabupaten',
        provinceData[selectedProvince]!,
        (value) {
          setState(() {
            selectedCity = value;
            selectedDistrict = null;
            selectedSubDistrict = null;
          });
        },
      ),
    );
  }
  
  void _showDistrictPicker() {
    if (selectedCity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pilih kota terlebih dahulu')),
      );
      return;
    }
    
    final districts = districtData[selectedCity] ?? [];
    showModalBottomSheet(
      context: context,
      builder: (context) => _buildPickerModal(
        'Pilih Kecamatan',
        districts,
        (value) {
          setState(() {
            selectedDistrict = value;
            selectedSubDistrict = null;
          });
        },
      ),
    );
  }
  
  void _showSubDistrictPicker() {
    if (selectedDistrict == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pilih kecamatan terlebih dahulu')),
      );
      return;
    }
    
    final subDistricts = subDistrictData[selectedDistrict] ?? [];
    showModalBottomSheet(
      context: context,
      builder: (context) => _buildPickerModal(
        'Pilih Kelurahan',
        subDistricts,
        (value) {
          setState(() {
            selectedSubDistrict = value;
          });
        },
      ),
    );
  }
  
  Widget _buildPickerModal(String title, List<String> options, Function(String) onSelect) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: options.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(options[index]),
                  onTap: () {
                    onSelect(options[index]);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  
  void _handleSubmit() {
    // Validasi form
    if (selectedDateOfBirth == null ||
        selectedGender == null ||
        selectedMaritalStatus == null ||
        selectedProvince == null ||
        selectedCity == null ||
        selectedDistrict == null ||
        selectedSubDistrict == null ||
        _streetAddressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Mohon lengkapi semua data'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    // Navigate to next screen
    Navigator.pushReplacementNamed(context, '/emergency-contact1');
  }
  
  @override
  void dispose() {
    _streetAddressController.dispose();
    super.dispose();
  }
} 