import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});
  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> gpsLogs = [
    { "time": "2025-08-03 15:30:40", "lat": -6.210, "lon": 106.820, "address": "Jl. Sudirman, Jakarta" },
    { "time": "2025-08-03 15:28:20", "lat": -6.200, "lon": 106.816, "address": "Jl. MH Thamrin, Jakarta" },
  ];
  List<Map<String, dynamic>> contacts = [
    { "name": "Andi", "phone": "081234567890" }, { "name": "Siti", "phone": "082198765432" }
  ];
  List<Map<String, dynamic>> smsLogs = [
    { "direction": "IN", "from": "081211122233", "to": "", "body": "Halo", "time": "2025-08-03 15:15:00" },
    { "direction": "OUT", "from": "", "to": "081244455566", "body": "Siap", "time": "2025-08-03 15:18:30" },
  ];
  List<Map<String, dynamic>> callLogs = [
    { "type": "INCOMING", "number": "081299988877", "duration": 60, "time": "2025-08-03 14:55:10" },
    { "type": "OUTGOING", "number": "081255566677", "duration": 120, "time": "2025-08-03 14:50:00" },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    // Simulasi update GPS tiap 5 detik
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 5));
      setState(() {
        final now = DateTime.now().toString().substring(0,19);
        final lat = gpsLogs[0]['lat'] + (0.001 * (gpsLogs.length % 2 == 0 ? 1 : -1));
        final lon = gpsLogs[0]['lon'] + (0.001 * (gpsLogs.length % 2 == 0 ? -1 : 1));
        gpsLogs.insert(0, {
          "time": now,
          "lat": double.parse(lat.toStringAsFixed(6)),
          "lon": double.parse(lon.toStringAsFixed(6)),
          "address": "Pindah, Jakarta"
        });
        if (gpsLogs.length > 10) gpsLogs.removeLast();
      });
      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final curLoc = LatLng(gpsLogs[0]['lat'], gpsLogs[0]['lon']);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard Admin - Monitoring User"),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: "GPS Logging"),
            Tab(text: "Contacts"),
            Tab(text: "SMS Logs"),
            Tab(text: "Call Logs"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // GPS Logging
          Column(
            children: [
              SizedBox(
                height: 220,
                child: FlutterMap(
                  options: MapOptions(center: curLoc, zoom: 16.0),
                  nonRotatedChildren: [
                    AttributionWidget.defaultWidget(
                      source: 'OpenStreetMap contributors',
                      onSourceTapped: null,
                    ),
                  ],
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          width: 40,
                          height: 40,
                          point: curLoc,
                          child: const Icon(Icons.location_pin, color: Colors.red, size: 40),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Text("Log Lokasi (Realtime)", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent)),
              Expanded(
                child: ListView(
                  children: gpsLogs.map((l) => ListTile(
                    leading: const Icon(Icons.my_location),
                    title: Text("${l['lat']}, ${l['lon']} (${l['address']})"),
                    subtitle: Text(l['time']),
                  )).toList(),
                ),
              ),
            ],
          ),
          // Contacts
          ListView(
            children: [
              const ListTile(title: Text("Daftar Kontak", style: TextStyle(fontWeight: FontWeight.bold))),
              DataTable(
                columns: const [
                  DataColumn(label: Text("Nama Kontak")),
                  DataColumn(label: Text("Nomor Telepon")),
                ],
                rows: contacts.map((c) => DataRow(cells: [
                  DataCell(Text(c['name'])),
                  DataCell(Text(c['phone'])),
                ])).toList(),
              ),
            ],
          ),
          // SMS Logs
          ListView(
            children: [
              const ListTile(title: Text("Riwayat SMS", style: TextStyle(fontWeight: FontWeight.bold))),
              DataTable(
                columns: const [
                  DataColumn(label: Text("Tipe SMS")),
                  DataColumn(label: Text("Nomor Pengirim/Penerima")),
                  DataColumn(label: Text("Isi Pesan")),
                  DataColumn(label: Text("Waktu")),
                ],
                rows: smsLogs.map((s) => DataRow(cells: [
                  DataCell(Text(s['direction'] == 'IN' ? 'Masuk' : 'Keluar')),
                  DataCell(Text(s['direction'] == 'IN' ? s['from'] : s['to'])),
                  DataCell(Text(s['body'])),
                  DataCell(Text(s['time'])),
                ])).toList(),
              ),
            ],
          ),
          // Call Logs
          ListView(
            children: [
              const ListTile(title: Text("Riwayat Panggilan", style: TextStyle(fontWeight: FontWeight.bold))),
              DataTable(
                columns: const [
                  DataColumn(label: Text("Tipe Panggilan")),
                  DataColumn(label: Text("Nomor")),
                  DataColumn(label: Text("Durasi (detik)")),
                  DataColumn(label: Text("Waktu")),
                ],
                rows: callLogs.map((c) => DataRow(cells: [
                  DataCell(Text(
                    c['type'] == 'INCOMING'
                      ? 'Masuk'
                      : c['type'] == 'OUTGOING'
                        ? 'Keluar'
                        : 'Tidak Terjawab',
                  )),
                  DataCell(Text(c['number'])),
                  DataCell(Text("${c['duration']}")),
                  DataCell(Text(c['time'])),
                ])).toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}