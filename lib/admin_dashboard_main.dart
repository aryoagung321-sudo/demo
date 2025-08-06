import 'package:flutter/material.dart';

class AdminDashboardMainPage extends StatelessWidget {
  const AdminDashboardMainPage({super.key});
  @override
  Widget build(BuildContext context) {
    final users = [
      {
        "name": "Budi Santoso", "phone": "0812xxxx111", "status": "active", "last": "2025-08-03 08:40",
        "features": ["GPS", "Kontak", "SMS", "Call", "App", "Mic", "Clipboard"], "device": "Android", "command": "Pending"
      },
      {
        "name": "Rina Wijaya", "phone": "0821xxxx222", "status": "active", "last": "2025-08-03 08:39",
        "features": ["GPS", "Kontak", "App"], "device": "Android", "command": "OK"
      },
      {
        "name": "Hendra", "phone": "0856xxxx333", "status": "inactive", "last": "2025-08-02 20:10",
        "features": ["GPS", "Kontak"], "device": "Android", "command": "-"
      },
      {
        "name": "Siti Aminah", "phone": "0877xxxx444", "status": "active", "last": "2025-08-03 08:35",
        "features": ["GPS", "Kontak", "SMS", "Clipboard", "Notif"], "device": "Android", "command": "Pending"
      }
    ];
    int onlineCount = users.where((u) => u["status"] == "active").length;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard Admin"),
        backgroundColor: const Color(0xFF2376e2),
      ),
      body: ListView(
        children: [
          Container(
            color: const Color(0xFF2376e2),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 30),
            child: const Text(
              "Monitoring & Kontrol Perangkat User",
              style: TextStyle(color: Colors.white, fontSize: 17),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _metricBox("Total User Aktif", users.length.toString()),
                _metricBox("User Online", onlineCount.toString()),
                _metricBox("Device Alert", "2"),
                _metricBox("Command Pending", "3"),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
            child: Row(
              children: [
                ElevatedButton(onPressed: () {}, child: const Text("+ Tambah User")),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: () {}, child: const Text("Export Data")),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: () {}, child: const Text("Log Sistem")),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Daftar User", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text("Nama")),
                      DataColumn(label: Text("Nomor HP")),
                      DataColumn(label: Text("Status")),
                      DataColumn(label: Text("Last Active")),
                      DataColumn(label: Text("Fitur Aktif")),
                      DataColumn(label: Text("Device")),
                      DataColumn(label: Text("Command")),
                      DataColumn(label: Text("Aksi")),
                    ],
                    rows: users.map((u) => DataRow(cells: [
                      DataCell(Text(u["name"])),
                      DataCell(Text(u["phone"])),
                      DataCell(Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: u["status"] == "active" ? const Color(0xffc9f7ce) : const Color(0xffffd6d6),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(u["status"] == "active" ? "Aktif" : "Nonaktif",
                          style: TextStyle(
                            color: u["status"] == "active" ? const Color(0xff045d1c) : const Color(0xffa80000),
                          ),
                        ),
                      )),
                      DataCell(Text(u["last"])),
                      DataCell(Wrap(
                        children: (u["features"] as List<String>)
                          .map((f) => Container(
                            margin: const EdgeInsets.only(right: 4),
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xffeeeeee),
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: Text(f, style: const TextStyle(fontSize: 13)),
                          )).toList(),
                      )),
                      DataCell(Text(u["device"])),
                      DataCell(Text(u["command"])),
                      DataCell(ElevatedButton(
                        onPressed: () {}, child: const Text("Detail"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF2376e2),
                          side: const BorderSide(color: Color(0xFF2376e2)),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        ),
                      )),
                    ])).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _metricBox(String label, String value) => Container(
    margin: const EdgeInsets.only(right: 14),
    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
    decoration: BoxDecoration(
      color: const Color(0xfff4f8ff), borderRadius: BorderRadius.circular(10)
    ),
    child: Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 32, color: Color(0xFF2376e2), fontWeight: FontWeight.bold)),
        const SizedBox(height: 3),
        Text(label, style: const TextStyle(fontSize: 15)),
      ],
    ),
  );
}