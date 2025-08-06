# Dokumentasi API Pinjaman Online

## BASE URL
`http://d.seoikrom.com/api/`

---

## USER ENDPOINTS

### 1. Registrasi User
- **POST** `/users/register`
- **Body JSON:**
  ```json
  {
    "nama": "Nama Lengkap",
    "nik": "1234567890",
    "email": "email@email.com",
    "noHp": "08123456789",
    "provinsi": "Jawa Barat",
    "kota": "Bandung",
    "kecamatan": "Coblong",
    "kelurahan": "Dago",
    "alamat": "Jl. ABC No. 12",
    "bank": "BCA",
    "norek": "1234567890"
  }
  ```
- **Response Success:**
  ```json
  { "success": true, "user_id": 1, "message": "Registrasi berhasil" }
  ```
- **Response Error:**
  ```json
  { "success": false, "message": "Registrasi gagal", "error": "..."}
  ```

---

### 2. Daftar Produk Pinjaman
- **GET** `/products`
- **Response:**
  ```json
  [
    { "id": 1, "amount": 1000000, "tenor": 7 },
    { "id": 2, "amount": 2000000, "tenor": 7 },
    ...
  ]
  ```

---

### 3. Pengajuan Pinjaman
- **POST** `/users/apply-loan`
- **Body JSON:**
  ```json
  {
    "user_id": 1,
    "product_id": 2
  }
  ```
- **Response Success:**
  ```json
  { "success": true, "message": "Pengajuan berhasil" }
  ```
- **Response Error:**
  ```json
  { "success": false, "message": "Pengajuan gagal", "error": "..." }
  ```

---

## ADMIN ENDPOINTS

### 1. Login Admin
- **POST** `/admin/login`
- **Body JSON:**
  ```json
  { "username": "admin", "password": "admin123" }
  ```
- **Response Success:**
  ```json
  { "token": "JWT_TOKEN_HERE" }
  ```
- **Response Error:**
  ```json
  { "message": "User not found" } | { "message": "Wrong password" }
  ```

---

### 2. List User
- **GET** `/admin/users`
- **Headers:** `Authorization: Bearer JWT_TOKEN`
- **Response:** List data user

### 3. List Pinjaman
- **GET** `/admin/loans`
- **Headers:** `Authorization: Bearer JWT_TOKEN`
- **Response:** List data pinjaman

### 4. Approve Pinjaman
- **POST** `/admin/loans/:loanId/approve`
- **Headers:** `Authorization: Bearer JWT_TOKEN`
- **Response:**
  ```json
  { "success": true, "message": "Loan approved" }
  ```

### 5. Reject Pinjaman
- **POST** `/admin/loans/:loanId/reject`
- **Headers:** `Authorization: Bearer JWT_TOKEN`
- **Response:**
  ```json
  { "success": true, "message": "Loan rejected" }
  ```