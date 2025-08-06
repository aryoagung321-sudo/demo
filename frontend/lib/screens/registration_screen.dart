import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'product_screen.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  String nama = '';
  String nik = '';
  String email = '';
  String noHp = '';
  String provinsi = '';
  String kota = '';
  String kecamatan = '';
  String kelurahan = '';
  String alamat = '';
  String bank = '';
  String norek = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrasi'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Nama Lengkap'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama harus diisi';
                    }
                    return null;
                  },
                  onSaved: (value) => nama = value ?? '',
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'NIK'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'NIK harus diisi';
                    }
                    return null;
                  },
                  onSaved: (value) => nik = value ?? '',
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email harus diisi';
                    }
                    return null;
                  },
                  onSaved: (value) => email = value ?? '',
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'No HP'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'No HP harus diisi';
                    }
                    return null;
                  },
                  onSaved: (value) => noHp = value ?? '',
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Provinsi'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Provinsi harus diisi';
                    }
                    return null;
                  },
                  onSaved: (value) => provinsi = value ?? '',
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Kota'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Kota harus diisi';
                    }
                    return null;
                  },
                  onSaved: (value) => kota = value ?? '',
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Kecamatan'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Kecamatan harus diisi';
                    }
                    return null;
                  },
                  onSaved: (value) => kecamatan = value ?? '',
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Kelurahan'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Kelurahan harus diisi';
                    }
                    return null;
                  },
                  onSaved: (value) => kelurahan = value ?? '',
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Alamat'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Alamat harus diisi';
                    }
                    return null;
                  },
                  onSaved: (value) => alamat = value ?? '',
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Bank'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bank harus diisi';
                    }
                    return null;
                  },
                  onSaved: (value) => bank = value ?? '',
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'No Rekening'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'No Rekening harus diisi';
                    }
                    return null;
                  },
                  onSaved: (value) => norek = value ?? '',
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      // Kirim data ke backend
                      final response = await http.post(
                        Uri.parse('http://d.seoikrom.com/api/users/register'),
                        headers: {'Content-Type': 'application/json'},
                        body: jsonEncode({
                          "nama": nama,
                          "nik": nik,
                          "email": email,
                          "noHp": noHp,
                          "provinsi": provinsi,
                          "kota": kota,
                          "kecamatan": kecamatan,
                          "kelurahan": kelurahan,
                          "alamat": alamat,
                          "bank": bank,
                          "norek": norek,
                        }),
                      );
                      if (response.statusCode == 200) {
                        // Setelah berhasil, misal userId didapat dari backend response
                        final userId = jsonDecode(response.body)['user_id'];
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductScreen(userId: userId.toString()),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Registrasi gagal')),
                        );
                      }
                    }
                  },
                  child: Text('Daftar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}