# 🚲 RentBike Premium — Flutter App
### UTS Mobile Lanjutan | NIM: 1123150032

**RentBike Premium** adalah aplikasi mobile berbasis Flutter untuk platform penyewaan sepeda. Aplikasi ini dirancang menggunakan **Clean Architecture** (Domain → Data → Presentation) untuk memisahkan logika bisnis dari tampilan antarmuka, serta menggunakan **Provider** untuk pengelolaan *state*. 

Di sisi *backend*, aplikasi ini terhubung ke REST API yang dibangun dengan Golang, dan memanfaatkan **Firebase Authentication** sebagai lapis keamanan awal sebelum menerbitkan token akses dari sistem internal.

---

## ✨ Fitur Utama

* **Sistem Login Berlapis:** Menggabungkan Firebase Auth (Email/Password & Google Sign-In) dengan sistem verifikasi token dari backend Golang untuk menghasilkan JWT yang aman.
* **Verifikasi Email Otomatis:** Fitur *polling* di latar belakang yang mendeteksi status verifikasi email secara *real-time* tanpa perlu interaksi manual dari pengguna (langsung redirect).
* **Dashboard Katalog Interaktif:** Menampilkan grid produk dengan indikator stok (hijau, oranye, merah), efek *shimmer loading*, dan *fallback image* jika gambar gagal dimuat.
* **Keamanan Sesi:** Penyimpanan sesi dan token secara terenkripsi menggunakan *Secure Storage* internal perangkat (bukan *shared preferences* biasa).
* **Komponen UI Reusable:** Penggunaan desain Material 3 dengan kumpulan *widget custom* (tombol, form input, overlay) yang rapi dan konsisten di seluruh halaman aplikasi.

---

## 🛠️ Tech Stack & Dependencies

* **Framework:** Flutter
* **State Management:** `provider`
* **Networking:** `dio` (custom dengan *auth, retry,* dan *log interceptors*)
* **Keamanan:** `flutter_secure_storage`
* **Autentikasi:** `firebase_auth`, `google_sign_in`
* **Utility:** `equatable`, `email_validator`, `flutter_svg`

---

## 📁 Struktur Arsitektur Proyek

Proyek ini dipisahkan secara modular mengikuti konsep Clean Architecture agar kode lebih rapi dan mudah di-maintenance:

```text
lib/
├── main.dart             # Entry point & inisialisasi awal
├── core/                 # Fondasi global aplikasi
│   ├── constants/        # URL API, palet warna, dan teks statis
│   ├── routes/           # Manajemen navigasi & proteksi halaman (Auth Guard)
│   ├── services/         # Konfigurasi HTTP client dan Secure Storage
│   └── widgets/          # Kumpulan UI komponen yang bisa dipakai ulang
│
└── features/             # Modul berbasis fitur
    ├── auth/             # Layer autentikasi (login, register, verifikasi)
    │   ├── data/         # Komunikasi ke API Golang & Firebase
    │   ├── domain/       # Kontrak/Interface repository
    │   └── presentation/ # UI dan State (Provider)
    │
    └── product/          # Layer dashboard dan katalog sepeda
        ├── data/         # Fetch produk dari API
        ├── domain/       # Kontrak/Interface
        └── presentation/ # UI Dashboard
