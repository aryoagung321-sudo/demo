import 'package:flutter/material.dart';
import '../widgets/custom_bottom_navbar.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    // Navigasi sesuai index
    setState(() {
      _selectedIndex = index;
    });
    // Tambahkan navigasi ke halaman lain jika perlu
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Halaman ke $_selectedIndex')), // Ganti sesuai kebutuhan
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}