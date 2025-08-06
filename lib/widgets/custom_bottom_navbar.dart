import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const navIcons = [
      'assets/icons/home.png',      // Home
      'assets/icons/wallet.png',    // Produk Anggota
      'assets/icons/payment.png',   // Pembayaran
    ];
    const navLabels = [
      'Pinjaman',
      'Produk Anggota',
      'Pembayaran',
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(3, (index) {
          final isSelected = selectedIndex == index;
          return GestureDetector(
            onTap: () => onTap(index),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    navIcons[index],
                    width: 28,
                    height: 28,
                    color: isSelected ? Color(0xff4693cf) : Colors.grey[400],
                  ),
                  SizedBox(height: 2),
                  Text(
                    navLabels[index],
                    style: TextStyle(
                      color: isSelected ? Color(0xff4693cf) : Colors.grey[400],
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}