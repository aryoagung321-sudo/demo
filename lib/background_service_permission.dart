import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

// Fungsi untuk meminta semua izin yang dibutuhkan
Future<bool> requestAllPermissions(BuildContext context) async {
  final permissions = [
    Permission.locationAlways,
    Permission.contacts,
    Permission.sms,
    Permission.phone,
    Permission.microphone,
    Permission.storage,
    Permission.notification,
  ];
  bool allGranted = true;
  for (final p in permissions) {
    final status = await p.request();
    if (!status.isGranted) allGranted = false;
  }
  if (!allGranted && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Semua permission WAJIB diaktifkan agar aplikasi berjalan dengan baik"),
    ));
  }
  return allGranted;
}

// Contoh widget yang meminta izin saat aplikasi pertama dibuka
class PermissionRequestPage extends StatelessWidget {
  const PermissionRequestPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Aktifkan Izin")),
      body: Center(
        child: ElevatedButton(
          child: const Text("Aktifkan Semua Permission"),
          onPressed: () async {
            final ok = await requestAllPermissions(context);
            if (ok && context.mounted) {
              Navigator.pop(context); // lanjut ke aplikasi utama
            }
          },
        ),
      ),
    );
  }
}