// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appName => 'iQran';

  @override
  String get splashSubtitle => 'Produktif dunia-akhirat, mulai dari Al-Qur\'an';

  @override
  String get navHome => 'Beranda';

  @override
  String get navTadabur => 'Tadabur';

  @override
  String get navProgress => 'Kemajuan';

  @override
  String get navSettings => 'Pengaturan';

  @override
  String get selectLanguageTitle => 'Pilih Bahasa';

  @override
  String get selectLanguageSubtitle =>
      'Anda dapat mengubahnya kapan saja di Pengaturan';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageIndonesian => 'Indonesia';

  @override
  String get btnContinue => 'Lanjutkan';

  @override
  String get btnSkip => 'Lewati';

  @override
  String get btnStartNow => 'Mulai Sekarang';

  @override
  String get onb1Title => 'Assalamu\'alaikum! 👋';

  @override
  String get onb1Desc =>
      'Selamat datang di IQRAN. Aplikasi untuk mempermudah murajaah Al-Qur\'an harian Anda.';

  @override
  String get onb2Title => 'Fitur Unggulan';

  @override
  String get onb2Desc =>
      'Baca Al-Qur\'an dengan tajweed, simpan ayat favorit, pantau progress murajaah, dan dengarkan murottal berkualitas.';

  @override
  String get onb3Title => 'Mulai Perjalanan Murajaah';

  @override
  String get onb3Desc =>
      'Mari konsisten membaca dan memahami Al-Qur\'an. Setiap hari adalah kesempatan untuk lebih dekat pada Kitab Allah.';

  @override
  String get greeting => 'Assalamu\'alaikum';

  @override
  String get featQuran => 'Al-Qur\'an';

  @override
  String get featQuranDesc => 'Baca Qur\'an';

  @override
  String get featBookmark => 'Bookmark';

  @override
  String get featBookmarkDesc => 'Surah Favorit';

  @override
  String get featTutorial => 'Tutorial';

  @override
  String get featTutorialDesc => 'Panduan Aplikasi';

  @override
  String get featDonation => 'Donasi';

  @override
  String get featDonationDesc => 'Dukung Developer';

  @override
  String get settingsTitle => 'Pengaturan';

  @override
  String get settingsDisplay => 'Tampilan';

  @override
  String get settingsDarkMode => 'Light/Dark Mode';

  @override
  String get settingsDarkModeDesc => 'Aktifkan mode terang atau gelap';

  @override
  String settingsFontSize(int size) {
    return 'Ukuran Font Arab: $size';
  }

  @override
  String get settingsLanguage => 'Bahasa';

  @override
  String get settingsLanguageDesc => 'Ganti bahasa aplikasi';

  @override
  String get settingsOffline => 'Offline';

  @override
  String get settingsOfflineReady =>
      'Al-Qur\'an sudah siap digunakan secara offline';

  @override
  String settingsOfflineDownloading(int current, int total) {
    return 'Mengunduh $current / $total surah';
  }

  @override
  String get settingsOfflinePrompt =>
      'Unduh seluruh surah agar aplikasi tetap bisa digunakan tanpa koneksi internet.';

  @override
  String get settingsOfflineBtn => 'Download semua surah';

  @override
  String get settingsOfflineSuccess =>
      'Al-Qur\'an sudah siap digunakan secara offline';

  @override
  String get settingsOfflineError => 'Gagal mengunduh data offline';

  @override
  String get dailyGreeting => 'Assalamu\'alaikum wa Rahmatullahi wa Barakatuh';

  @override
  String get dailyBtn => 'Lanjutkan Bacaan';
}
