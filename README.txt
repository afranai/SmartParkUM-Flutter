SMARTPARK UM - STRUKTUR FLUTTER TERPISAH

Folder utama project ini adalah folder yang berisi pubspec.yaml.

Struktur:
lib/main.dart                    Titik masuk aplikasi
lib/app.dart                     Konfigurasi MaterialApp dan tema
lib/pages/                       Halaman terpisah:
  landing_page.dart              Landing/onboarding
  auth_page.dart                 Login dan daftar
  main_shell.dart                Navigasi utama
  dashboard_page.dart            Beranda
  recommendation_page.dart       Form rekomendasi parkir
  detail_page.dart               Detail area parkir/CCTV simulasi
  profile_page.dart              Profil
lib/models/                      Model data pengguna dan parkir
lib/data/parking_data.dart       Data parkir simulasi
lib/widgets/app_widgets.dart     Komponen UI yang dipakai ulang
lib/utils/app_colors.dart       Palet warna aplikasi
assets/images/                   Logo SmartPark
web/                              Konfigurasi awal Flutter Web

Cara menjalankan dari folder project:
1. flutter pub get
2. flutter analyze
3. flutter run -d chrome

Catatan: paket ini memisahkan kode ke beberapa file tanpa sengaja mengubah desain
atau alur yang sudah ada. Data akun masih simulasi dalam memori dan CCTV berupa
pratinjau. Penyimpanan permanen belum ditambahkan pada paket modular ini.
