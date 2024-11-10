# CanIEatThis?

CanIEatThis? adalah aplikasi mobile yang membantu pengguna dengan alergi atau intoleransi makanan untuk dengan cepat mengidentifikasi apakah suatu produk aman untuk dikonsumsi. Dengan menggunakan pemindai barcode dan database produk yang komprehensif, aplikasi ini memberikan informasi instan tentang kandungan alergen dalam produk makanan.

## Fitur Utama

- **Pemindaian Barcode**: Pindai barcode produk untuk mendapatkan informasi detail.
- **Analisis Alergen**: Identifikasi cepat alergen dalam produk berdasarkan profil pengguna.
- **Profil Pengguna**: Sesuaikan profil alergi pribadi untuk rekomendasi yang akurat.
- **Riwayat Pemindaian**: Simpan dan akses riwayat produk yang telah dipindai.
- **Rekomendasi Produk**: Dapatkan saran produk alternatif yang aman.
- **Informasi Apotek Terdekat**: Temukan apotek terdekat untuk kebutuhan darurat.

## Persyaratan

- Flutter (versi 2.5.0 atau lebih baru)
- Dart (versi 2.14.0 atau lebih baru)
- Android Studio / VS Code
- Android Emulator

## Instalasi

1. Clone repositori ini:
   ```
   git clone https://github.com/yourusername/can_i_eat_this.git
   ```

2. Masuk ke direktori proyek:
   ```
   cd can_i_eat_this
   ```

3. Instal dependensi:
   ```
   flutter pub get
   ```

4. Jalankan aplikasi:
   ```
   flutter run
   ```

## Penggunaan

1. Buka aplikasi dan buat profil pengguna dengan informasi alergi Anda.
2. Di layar utama, tekan tombol scan untuk memindai barcode produk.
3. Lihat hasil analisis yang menunjukkan apakah produk aman untuk Anda konsumsi.
4. Jelajahi rekomendasi produk alternatif jika diperlukan.
5. Akses riwayat pemindaian Anda untuk referensi cepat di masa mendatang.

## Struktur Proyek

```
lib/
├── main.dart
├── widgets/
│   ├── subscription/
│   │   └── subscription_status_widget.dart
│   ├── product/
│   │   ├── shimmer_product_detail.dart
│   │   ├── scanner_widget.dart
│   │   ├── recommendation_widget.dart
│   │   └── product_detail_widget.dart
│   ├── pharmacy/
│   │   └── maps.dart
│   ├── home/
│   │   ├── recommendation_item.dart
│   │   ├── product_history_card.dart
│   │   ├── pharmacy_section.dart
│   │   ├── pharmacy_item.dart
│   │   ├── last_scanned_widget.dart
│   │   ├── custom_app_bar.dart
│   │   └── all_scan_page.dart
│   └── chats/
│       └── chat_bubble.dart
├── services/
│   ├── user_service.dart
│   ├── search_service.dart
│   ├── product_service.dart
│   ├── pharmacy_service.dart
│   ├── package_service.dart
│   ├── home_service.dart
│   ├── chat_service.dart
│   └── api_service.dart
├── app/
│   ├── utils/
│   │   ├── term_of_service.dart
│   │   ├── error_handler.dart
│   │   ├── dio_interceptor.dart
│   │   ├── constant.dart
│   │   ├── chat_channel_utils.dart
│   │   └── bottom_nav_bar.dart
│   ├── themes/
│   │   └── app_theme.dart
│   ├── routes/
│   │   └── app_pages.dart
│   ├── modules/
│   │   ├── splash_page.dart
│   │   ├── search/
│   │   │   ├── views/
│   │   │   │   ├── search_page.dart
│   │   │   │   └── product_detail_page.dart
│   │   │   ├── controllers/
│   │   │   │   └── search_controllers.dart
│   │   │   └── bindings/
│   │   │       └── search_bindings.dart
│   │   ├── scan/
│   │   │   ├── views/
│   │   │   │   ├── scan_view.dart
│   │   │   │   └── alternative_product_page.dart
│   │   │   ├── controllers/
│   │   │   │   ├── scan_controller.dart
│   │   │   │   └── alternative_controller.dart
│   │   │   └── bindings/
│   │   │       └── alternative_bindings.dart
│   │   ├── profile/
│   │   │   ├── views/
│   │   │   │   ├── profile_page.dart
│   │   │   │   ├── personal_information_page.dart
│   │   │   │   └── change_password_page.dart
│   │   │   ├── controllers/
│   │   │   │   └── profile_controller.dart
│   │   │   └── bindings/
│   │   │       └── profile_binding.dart
│   │   ├── product_details/
│   │   │   ├── views/
│   │   │   │   └── product_page.dart
│   │   │   ├── controllers/
│   │   │   └── bindings/
│   │   ├── pharmacy/
│   │   │   ├── views/
│   │   │   │   ├── pharmacy_page.dart
│   │   │   │   └── pharmacy_detail_page.dart
│   │   │   ├── controllers/
│   │   │   │   └── pharmacy_controller.dart
│   │   │   └── bindings/
│   │   │       └── pharmacy_binding.dart
│   │   ├── home/
│   │   │   ├── views/
│   │   │   │   └── home_page.dart
│   │   │   ├── controllers/
│   │   │   │   └── home_controller.dart
│   │   │   └── bindings/
│   │   │       └── home_binding.dart
│   │   ├── chat/
│   │   │   ├── views/
│   │   │   │   ├── list_consultant.dart
│   │   │   │   ├── consultant_req_page.dart
│   │   │   │   ├── chat_room_page.dart
│   │   │   │   ├── chat_page2.dart
│   │   │   │   ├── chat_page.dart
│   │   │   │   └── acquiantances_page.dart
│   │   │   ├── controllers/
│   │   │   │   ├── subscription_controller.dart
│   │   │   │   ├── chat_room_controller.dart
│   │   │   │   └── chat_controller.dart
│   │   │   └── bindings/
│   │   │       ├── subscription_binding.dart
│   │   │       └── chat_binding.dart
│   │   └── auth/
│   │       ├── views/
│   │       │   ├── signup_form.dart
│   │       │   ├── login_page.dart
│   │       │   ├── login_form.dart
│   │       │   └── forgetPassword_form.dart
│   │       ├── controllers/
│   │       │   └── base_controller.dart
│   │       └── bindings/
│   ├── middleware/
│   ├── hooks/
│   │   └── use_auth.dart
│   ├── global_widgets/
│   │   └── custom_app_bar.dart
│   └── data/
│       ├── repositories/
│       │   └── product_repository.dart
│       ├── providers/
│       │   └── api_provider.dart
│       └── models/
│           ├── user2_model.dart
│           ├── user_model.dart
│           ├── search_model.dart
│           ├── recommendation_model.dart
│           ├── product_model.dart
│           ├── pharmacy_model.dart
│           ├── password_model.dart
│           ├── parse_allergens.dart
│           ├── package_model.dart
│           ├── message_model.dart
│           ├── history_model.dart
│           ├── consultant2_model.dart
│           ├── consultant_model.dart
│           ├── chat_user_model.dart
│           ├── chat_model.dart
│           ├── auth_model.dart
│           ├── answer_model.dart
│           ├── alternative_model.dart
│           └── allergen_model.dart
```

## Kontribusi

Kontribusi untuk CanIEatThis? sangat dihargai. Jika Anda ingin berkontribusi:

1. Fork repository
2. Buat branch fitur Anda (`git checkout -b feature/AmazingFeature`)
3. Commit perubahan Anda (`git commit -m 'Add some AmazingFeature'`)
4. Push ke branch (`git push origin feature/AmazingFeature`)
5. Buka Pull Request

## Lisensi

Didistribusikan di bawah Lisensi MIT. Lihat `LICENSE` untuk informasi lebih lanjut.

## Kontak
- Arvan Yudhistia Ardana : 225150200111014
- Riady Wiguna : 225150200111013
- Zidan Rafi Nasrullah : 225150200111012


Link Proyek: [https://github.com/arvardy184/eat_this_app](https://github.com/arvardy184/eat_this_app)

## Pengakuan

- [OpenFoodFacts API](https://world.openfoodfacts.org/data)
- [Flutter](https://flutter.dev)
- [mobile_scanner](https://pub.dev/packages/mobile_scanner)
- [persistent_bottom_nav_bar](https://pub.dev/packages/persistent_bottom_nav_bar)
