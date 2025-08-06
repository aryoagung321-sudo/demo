import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'admin_dashboard.dart';

class AdminLogin extends StatefulWidget {
  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final _formKey = GlobalKey<FormState>();
  String? username, password;
  bool loading = false, error = false;

  void login() async {
    setState(() => loading = true);
    final res = await http.post(
      Uri.parse('http://d.seoikrom.com/api/admin/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );
    setState(() => loading = false);
    if (res.statusCode == 200) {
      final token = jsonDecode(res.body)['token'];
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (ctx) => AdminDashboard(adminToken: token),
        ),
      );
    } else {
      setState(() => error = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Admin Login")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (error) Text('Login gagal', style: TextStyle(color: Colors.red)),
              TextFormField(
                decoration: InputDecoration(labelText: "Username"),
                onChanged: (v) => username = v,
                validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Password"),
                obscureText: true,
                onChanged: (v) => password = v,
                validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: loading
                    ? null
                    : () {
                        if (_formKey.currentState!.validate()) login();
                      },
                child: loading ? CircularProgressIndicator() : Text("Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}