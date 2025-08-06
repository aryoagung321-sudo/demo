import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';

Future<void> initializeBackgroundService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
      notificationTitle: "Aplikasi berjalan",
      notificationText: "Aplikasi tetap aktif di balik layar",
    ),
    iosConfiguration: IosConfiguration(),
  );
  service.startService();
}

void onStart(ServiceInstance service) async {
  // Service berjalan di background, ambil data GPS, kontak, log, dsb secara periodik dan kirim ke backend
}