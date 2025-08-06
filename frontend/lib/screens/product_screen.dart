import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductScreen extends StatefulWidget {
  final String userId;
  ProductScreen({required this.userId});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List products = [];
  int? selectedProductId;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final response = await http.get(Uri.parse('http://d.seoikrom.com/api/products'));
    if (response.statusCode == 200) {
      setState(() {
        products = json.decode(response.body);
      });
    }
  }

  void submitApplication() async {
    if (selectedProductId == null) return;
    // Kirim pengajuan pinjaman ke backend (tambahkan endpoint sesuai backend Anda)
    final response = await http.post(
      Uri.parse('http://d.seoikrom.com/api/users/apply-loan'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        "user_id": widget.userId,
        "product_id": selectedProductId,
      }),
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Pengajuan pinjaman berhasil!')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengajukan pinjaman')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pilih Produk Pinjaman')),
      body: products.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, i) {
                      final p = products[i];
                      return Card(
                        color: selectedProductId == p['id'] ? Colors.green[100] : null,
                        child: ListTile(
                          title: Text("Rp${p['amount']}"),
                          subtitle: Text('Tenor: ${p['tenor']} hari'),
                          trailing: selectedProductId == p['id']
                              ? Icon(Icons.check_circle, color: Colors.green)
                              : null,
                          onTap: () {
                            setState(() {
                              selectedProductId = p['id'];
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
                if (selectedProductId != null)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: submitApplication,
                      child: Text("Ajukan"),
                    ),
                  )
              ],
            ),
    );
  }
}