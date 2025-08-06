import 'package:flutter/material.dart';
import 'product_list_screen.dart'; // Import halaman produk

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == 1) {
      // Produk Anggota
      Navigator.push(
        context,
        MaterialPageRoute(builder: (ctx) => ProductListScreen()),
      );
      // Tidak perlu set _selectedIndex, tetap di halaman ini
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ... body Anda ...
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xff4693cf),
        unselectedItemColor: Colors.grey[400],
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Pinjaman',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Produk Anggota',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment),
            label: 'Pembayaran',
          ),
        ],
      ),
    );
  }
}