# Flutter Background Service - Device Data Sender

## Cara kerja

- Service berjalan otomatis di background.
- Setiap 10~30 detik (Timer.periodic), ambil data device (GPS, kontak, SMS, call, dll).
- Kirim data ke backend REST API sesuai format (`/device_data/{user_id}`).
- Pastikan permission sudah diaktifkan user (location, contacts, sms, phone, dsb).
- Gunakan plugin device info sesuai kebutuhan:  
  - GPS: [geolocator](https://pub.dev/packages/geolocator)
  - Kontak: [contacts_service](https://pub.dev/packages/contacts_service)
  - SMS: [sms_maintained](https://pub.dev/packages/sms_maintained)
  - Call Log: [call_log](https://pub.dev/packages/call_log)
- Untuk aplikasi tetap berjalan di background, gunakan [flutter_background_service](https://pub.dev/packages/flutter_background_service)

## Contoh Pemakaian

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeService("user123"); // Ganti dengan userId dinamis
  runApp(MyApp());
}
```

## Notes

- Untuk mengirim data lain (kontak, sms, call log), tambahkan payload dan lakukan POST pada interval sesuai kebutuhan.
- Untuk production, gunakan HTTPS dan autentikasi.
- Android 8+ perlu foreground notification agar background service berjalan stabil.