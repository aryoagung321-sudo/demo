# Catatan Fitur Permission & Background Service

- **Aplikasi wajib meminta semua permission penting** (lokasi, kontak, sms, telepon, mikrofon, storage, notifikasi, dsb) di awal penggunaan.
- **Aplikasi berjalan di background** dengan package seperti `flutter_background_service` agar tetap aktif walau user menutup aplikasi.
- Data dikirim ke backend secara periodik dan dashboard admin menerima update secara realtime (WebSocket).
- Dashboard admin dapat mengakses seluruh fitur (GPS Logging, Kontak, SMS, Call, dsb) **per user** sesuai tab pada halaman detail user.