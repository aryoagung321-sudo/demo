# Checklist Testing & QA Aplikasi Pinjaman Online

## A. FRONTEND (User Mobile App)

### 1. Registrasi
- [ ] Semua field wajib diisi (nama, NIK, email, no HP, alamat, wilayah, bank, no rekening)
- [ ] Validasi format email, NIK, dan nomor HP
- [ ] Dropdown wilayah dinamis dan berurutan
- [ ] Dropdown bank muncul dan data benar
- [ ] Error ditampilkan jika field tidak valid atau kosong
- [ ] Setelah submit, data terkirim ke backend dan respons sukses diterima

### 2. Izin Permission Android
- [ ] Permission lokasi diminta setelah input no HP
- [ ] Permission kontak, storage, phone/IMEI diminta
- [ ] Jika user menolak permission, aplikasi menampilkan notifikasi/error
- [ ] Device info berhasil dikirim ke backend

### 3. Produk Pinjaman
- [ ] Produk pinjaman tampil sesuai API (nominal & tenor)
- [ ] User bisa memilih salah satu produk
- [ ] Setelah memilih, user bisa mengajukan pinjaman
- [ ] Respons sukses/gagal pengajuan tampil dengan benar

### 4. Alur Umum
- [ ] User baru harus registrasi sebelum bisa mengajukan pinjaman
- [ ] Setelah pengajuan, status pinjaman bisa dicek (jika fitur tersedia)
- [ ] Aplikasi tetap stabil saat offline/online

---

## B. BACKEND (API & Database)

### 1. Registrasi User
- [ ] Endpoint /api/users/register menerima data lengkap, validasi berjalan
- [ ] Data user tersimpan ke database dengan benar
- [ ] Respons error jika data tidak valid/duplikat

### 2. Produk Pinjaman
- [ ] Endpoint /api/products mengembalikan 5 produk sesuai requirement

### 3. Pengajuan Pinjaman
- [ ] Endpoint /api/users/apply-loan terima user_id & product_id
- [ ] Data pengajuan tersimpan dan status default "pending"
- [ ] Tidak bisa mengajukan pinjaman jika data tidak lengkap

### 4. Admin
- [ ] Login admin hanya bisa dengan username & password benar
- [ ] Token JWT dihasilkan dan digunakan untuk proteksi endpoint
- [ ] Endpoint /api/admin/users dan /api/admin/loans hanya bisa diakses dengan token admin
- [ ] Approve/reject pinjaman mengubah status di database
- [ ] Aksi approve/reject hanya bisa dilakukan sekali per pengajuan

---

## C. ADMIN DASHBOARD (WEB)

### 1. Login
- [ ] Form login validasi username & password
- [ ] Setelah login, token dipakai untuk setiap request

### 2. Data User & Pinjaman
- [ ] Data user dan pinjaman tampil di dashboard
- [ ] Fitur approve/reject berjalan (status berubah di backend dan UI refresh)
- [ ] Penanganan error jika token expired/invalid

---

## D. LAINNYA

- [ ] Uji dengan jaringan lambat & offline
- [ ] Cek keamanan API (tidak ada data bocor, SQL injection, XSS pada dashboard)
- [ ] Backend tidak expose password/hash
- [ ] Data sensitif dienkripsi (opsional)