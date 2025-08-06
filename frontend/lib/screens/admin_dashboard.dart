import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AdminDashboard extends StatefulWidget {
  final String adminToken;
  AdminDashboard({required this.adminToken});
  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  List users = [];
  List loans = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchAll();
  }

  Future<void> fetchAll() async {
    await fetchUsers();
    await fetchLoans();
    setState(() => loading = false);
  }

  Future<void> fetchUsers() async {
    final res = await http.get(
      Uri.parse('http://d.seoikrom.com/api/admin/users'),
      headers: {'Authorization': 'Bearer ${widget.adminToken}'},
    );
    if (res.statusCode == 200) {
      setState(() {
        users = json.decode(res.body);
      });
    }
  }

  Future<void> fetchLoans() async {
    final res = await http.get(
      Uri.parse('http://d.seoikrom.com/api/admin/loans'),
      headers: {'Authorization': 'Bearer ${widget.adminToken}'},
    );
    if (res.statusCode == 200) {
      setState(() {
        loans = json.decode(res.body);
      });
    }
  }

  Future<void> approveLoan(int id) async {
    final res = await http.post(
      Uri.parse('http://d.seoikrom.com/api/admin/loans/$id/approve'),
      headers: {'Authorization': 'Bearer ${widget.adminToken}'},
    );
    if (res.statusCode == 200) fetchLoans();
  }

  Future<void> rejectLoan(int id) async {
    final res = await http.post(
      Uri.parse('http://d.seoikrom.com/api/admin/loans/$id/reject'),
      headers: {'Authorization': 'Bearer ${widget.adminToken}'},
    );
    if (res.statusCode == 200) fetchLoans();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return Center(child: CircularProgressIndicator());
    return Scaffold(
      appBar: AppBar(title: Text('Admin Dashboard')),
      body: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Text('Daftar User', style: TextStyle(fontWeight: FontWeight.bold)),
                Expanded(
                  child: ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, i) => ListTile(
                      title: Text(users[i]['nama']),
                      subtitle: Text(users[i]['email']),
                    ),
                  ),
                ),
              ],
            ),
          ),
          VerticalDivider(),
          Expanded(
            child: Column(
              children: [
                Text('Daftar Pinjaman', style: TextStyle(fontWeight: FontWeight.bold)),
                Expanded(
                  child: ListView.builder(
                    itemCount: loans.length,
                    itemBuilder: (context, i) => ListTile(
                      title: Text('UserID: ${loans[i]['user_id']}'),
                      subtitle: Text(
                        'Nominal: Rp${loans[i]['amount']}\nTenor: ${loans[i]['tenor']} hari\nStatus: ${loans[i]['status']}',
                      ),
                      trailing: loans[i]['status'] == 'pending'
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.check),
                                  onPressed: () => approveLoan(loans[i]['id']),
                                ),
                                IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () => rejectLoan(loans[i]['id']),
                                ),
                              ],
                            )
                          : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}