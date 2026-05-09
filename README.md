# 👜 BagStore Premium — Flutter App
### UTS Mobile Lanjutan | Nama: Indra Nurul Kusuma | NIM: 1123150032

**BagStore Premium** adalah aplikasi mobile berbasis Flutter untuk platform penjualan tas premium. Aplikasi ini dirancang menggunakan **Clean Architecture** (Domain → Data → Presentation) untuk memisahkan logika bisnis dari tampilan antarmuka, serta menggunakan **Provider** untuk pengelolaan *state*. 

Di sisi *backend*, aplikasi ini terhubung ke REST API yang dibangun dengan Golang, dan memanfaatkan **Firebase Authentication** sebagai lapis keamanan awal sebelum menerbitkan token akses dari sistem internal.

---

## ✨ Fitur Utama

* **Sistem Login Berlapis:** Menggabungkan Firebase Auth (Email/Password & Google Sign-In) dengan sistem verifikasi token dari backend Golang untuk menghasilkan JWT yang aman.
* **Verifikasi Email Otomatis:** Fitur *polling* di latar belakang yang mendeteksi status verifikasi email secara *real-time* tanpa perlu interaksi manual dari pengguna (langsung redirect).
* **Dashboard Katalog Tas:** Menampilkan grid koleksi tas dengan indikator stok (hijau, oranye, merah), efek *shimmer loading*, dan *fallback image* jika gambar gagal dimuat.
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
├── main.dart                          # Entry point aplikasi
├── firebase_options.dart              # Konfigurasi Firebase (auto-generated)
│
├── core/                              # Fondasi & komponen global
│   ├── constants/
│   │   ├── app_colors.dart            # Konstanta warna aplikasi
│   │   ├── app_strings.dart           # Label teks statis & pesan error
│   │   └── api_constants.dart         # URL base & endpoint API
│   ├── theme/
│   │   └── app_theme.dart             # Konfigurasi Tema Material 3
│   ├── services/
│   │   ├── secure_storage.dart        # Enkripsi penyimpanan token JWT
│   │   └── dio_client.dart            # HTTP client & interceptor log/auth
│   ├── routes/
│   │   ├── app_router.dart            # Manajemen rute halaman
│   │   └── auth_guard.dart            # Middleware proteksi halaman
│   └── widgets/                       # Widget reusable global
│       ├── auth_header.dart           # Header halaman auth
│       ├── custom_text_field.dart     # Input field kustom
│       ├── custom_button.dart         # Tombol kustom (Primary/Outline/Text)
│       ├── divider_with_text.dart     # Pemisah form dengan teks
│       ├── google_sign_in_button.dart # Tombol integrasi Google
│       └── loading_overlay.dart       # Indikator proses loading
│
└── features/                          # Fitur berbasis Clean Architecture
    ├── auth/                          # Modul Autentikasi
    │   ├── data/
    │   │   ├── models/                # Model JSON response auth
    │   │   └── repositories/          # Implementasi komunikasi API
    │   ├── domain/
    │   │   └── repositories/          # Kontrak/Interface repository auth
    │   └── presentation/
    │       ├── providers/             # Logic state management auth
    │       └── pages/                 # UI Login, Register, & Verifikasi
    │
    └── product/                       # Modul Katalog & Produk
        ├── data/
        │   ├── models/                # Model data produk
        │   └── repositories/          # Implementasi fetch data produk
        ├── domain/
        │   └── repositories/          # Kontrak/Interface repository produk
        └── presentation/
            ├── providers/             # Logic state management produk
            └── pages/                 # UI Dashboard & Katalog
```
