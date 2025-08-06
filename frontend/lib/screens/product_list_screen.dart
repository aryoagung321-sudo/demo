import 'package:flutter/material.dart';

// Dummy data for products
final List<Map<String, dynamic>> loanProducts = [
  {
    "name": "AdaKami",
    "logo": "https://upload.wikimedia.org/wikipedia/commons/thumb/5/5e/AdaKami_logo.png/120px-AdaKami_logo.png",
    "maxAmount": 80000000,
    "rating": 4.7,
    "downloads": "1jt+",
  },
  {
    "name": "PinjamYuk",
    "logo": "https://play-lh.googleusercontent.com/Z5oJXQ7Tkqhk4Evr3wEKNyZqj6jJURJtWmn6n6KQ8v9l4vF9lKXWQdFQa7g0FQWQfA=w240-h480-rw",
    "maxAmount": 10000000,
    "rating": 4.6,
    "downloads": "500rb+",
  },
  {
    "name": "Cairin",
    "logo": "https://play-lh.googleusercontent.com/4A3qj2Jlc2s3rpnqvZb2Y4Pt9nQ2eN7s4iG0F5c9QG5pXw=w240-h480-rw",
    "maxAmount": 7000000,
    "rating": 4.8,
    "downloads": "1jt+",
  },
  {
    "name": "SINGA",
    "logo": "https://play-lh.googleusercontent.com/6b6h4K8bXW4nH8h4b4w6p6Qh4w8w8h6h7w4h8h4h=w240-h480-rw",
    "maxAmount": 20000000,
    "rating": 4.0,
    "downloads": "100rb+",
  },
  {
    "name": "Moxa",
    "logo": "https://play-lh.googleusercontent.com/4QJ9QhQ4QhQ4QhQ4QhQ4QhQ4QhQ4QhQ4QhQ4QhQ4=w240-h480-rw",
    "maxAmount": 2000000,
    "rating": 4.9,
    "downloads": "100rb+",
  },
  {
    "name": "Samir",
    "logo": "https://play-lh.googleusercontent.com/4A9fQhQ4QhQ4QhQ4QhQ4QhQ4QhQ4QhQ4QhQ4QhQ4=w240-h480-rw",
    "maxAmount": 20000000,
    "rating": 4.9,
    "downloads": "50rb+",
  },
  {
    "name": "CashCerdas",
    "logo": "https://play-lh.googleusercontent.com/4A1QhQ4QhQ4QhQ4QhQ4QhQ4QhQ4QhQ4QhQ4QhQ4=w240-h480-rw",
    "maxAmount": 50000000,
    "rating": 4.8,
    "downloads": "500rb+",
  },
  {
    "name": "360Kredi",
    "logo": "https://play-lh.googleusercontent.com/4A3QhQ4QhQ4QhQ4QhQ4QhQ4QhQ4QhQ4QhQ4QhQ4=w240-h480-rw",
    "maxAmount": 20000000,
    "rating": 4.8,
    "downloads": "100rb+",
  },
  {
    "name": "Home Credit",
    "logo": "https://upload.wikimedia.org/wikipedia/commons/thumb/2/24/Home_Credit_Logo.png/640px-Home_Credit_Logo.png",
    "maxAmount": 10000,
    "rating": 4.9,
    "downloads": "1jt+",
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
                      // Logo
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey[200],
                          image: DecorationImage(
                            image: NetworkImage(p["logo"]),
                            fit: BoxFit.cover,
                          ),
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