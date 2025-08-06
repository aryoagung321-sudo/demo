import 'package:flutter/material.dart';

final List<Map<String, dynamic>> loanProducts = [
  {
    "name": "AdaKami",
    "maxAmount": 80000000,
    "rating": 4.7,
    "icon": Icons.account_balance_wallet_outlined,
    "iconColor": Colors.green,
  },
  {
    "name": "PinjamYuk",
    "maxAmount": 10000000,
    "rating": 4.6,
    "icon": Icons.account_balance_outlined,
    "iconColor": Colors.lightBlue,
  },
  {
    "name": "Cairin",
    "maxAmount": 7000000,
    "rating": 4.8,
    "icon": Icons.account_balance_wallet_rounded,
    "iconColor": Colors.teal,
  },
  {
    "name": "SINGA",
    "maxAmount": 20000000,
    "rating": 4.0,
    "icon": Icons.attach_money,
    "iconColor": Colors.orange,
  },
  {
    "name": "Moxa",
    "maxAmount": 2000000,
    "rating": 4.9,
    "icon": Icons.savings,
    "iconColor": Colors.deepPurple,
  },
  {
    "name": "Samir",
    "maxAmount": 20000000,
    "rating": 4.9,
    "icon": Icons.account_balance_wallet,
    "iconColor": Colors.redAccent,
  },
  {
    "name": "CashCerdas",
    "maxAmount": 50000000,
    "rating": 4.8,
    "icon": Icons.credit_card,
    "iconColor": Colors.blueAccent,
  },
  {
    "name": "360Kredi",
    "maxAmount": 20000000,
    "rating": 4.8,
    "icon": Icons.credit_score,
    "iconColor": Colors.green,
  },
  {
    "name": "Home Credit",
    "maxAmount": 10000,
    "rating": 4.9,
    "icon": Icons.home_work,
    "iconColor": Colors.red,
  },
];

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  String currencyFormat(int number) =>
      "Rp ${number.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}";

  Widget _buildRatingStars(double rating) {
    int fullStars = rating.floor();
    bool halfStar = (rating - fullStars) >= 0.5;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(fullStars, (i) => Icon(Icons.star, color: Colors.orange, size: 18)),
        if (halfStar) Icon(Icons.star_half, color: Colors.orange, size: 18),
        ...List.generate(5 - fullStars - (halfStar ? 1 : 0), (i) => Icon(Icons.star_border, color: Colors.orange, size: 18)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff5f7fa),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'DEMO APK, BY TOOLS PINJOL',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Icon(Icons.check_circle, color: Colors.blueAccent),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: loanProducts.length,
        padding: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
        itemBuilder: (ctx, i) {
          final p = loanProducts[i];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 6),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 1.5,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Icon produk
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: p["iconColor"]!.withOpacity(0.13),
                        ),
                        child: Icon(
                          p["icon"],
                          color: p["iconColor"],
                          size: 28,
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        p["name"],
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Spacer(),
                      Text(
                        p["rating"].toStringAsFixed(1),
                        style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      SizedBox(width: 2),
                      _buildRatingStars(p["rating"]),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        "Jumlah maksimum",
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                      Spacer(),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff1677ff),
                          shape: StadiumBorder(),
                          padding: EdgeInsets.symmetric(horizontal: 28, vertical: 0),
                        ),
                        onPressed: () {
                          // Download or open detail
                        },
                        child: Text("Unduh"),
                      ),
                    ],
                  ),
                  SizedBox(height: 2),
                  Text(
                    currencyFormat(p["maxAmount"]),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "APP hanya merekomendasikan lembaga keuangan kepada Anda dan tidak berpartisipasi dalam pemberian pinjaman",
                    style: TextStyle(fontSize: 13, color: Colors.grey[600], height: 1.3),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}