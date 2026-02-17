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
  String get onb4Title => 'Fitur Tadabur - Renungan Mendalam';

  @override
  String get onb4Desc =>
      'Eksplorasi 129+ cerita islami yang menginspirasi. Setiap cerita dilengkapi dengan doa dan pelajaran spiritual untuk memperdalam pemahaman dan iman Anda.';

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
  String settingsFontSize(Object size) {
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
  String settingsOfflineDownloading(Object current, Object total) {
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

  @override
  String get tadabur_searchPlaceholder => 'Cari cerita...';

  @override
  String get tadabur_guideTitle => 'PANDUAN TADABUR';

  @override
  String get tadabur_step1Title => 'PERSIAPAN HATI';

  @override
  String get tadabur_step1Desc =>
      'Mulai dengan niat yang ikhlas untuk memperbaiki diri dan mencari hikmah dari cerita-cerita Al-Quran. Bersihkan hati dari prasangka dan kebisingan pikiran.';

  @override
  String get tadabur_step2Title => 'MEMBACA CERITA';

  @override
  String get tadabur_step2Desc =>
      'Baca cerita dengan penuh perhatian. Jika memungkinkan, baca langsung dari Al-Quran pada surah-surah yang disebutkan untuk menambah kekhusyukan.';

  @override
  String get tadabur_step3Title => 'MERENUNGKAN';

  @override
  String get tadabur_step3Desc =>
      'Luangkan waktu untuk merenungkan makna cerita. Hubungkan dengan kehidupan pribadi Anda. Apa pesan yang ingin Allah sampaikan melalui cerita ini?';

  @override
  String get tadabur_step4Title => 'MENJAWAB PERTANYAAN';

  @override
  String get tadabur_step4Desc =>
      'Jawab pertanyaan-pertanyaan dengan jujur dan mendalam. Jangan sekadar menjawab di permukaan, tapi gali lebih dalam.';

  @override
  String get tadabur_step5Title => 'MENGAMALKAN';

  @override
  String get tadabur_step5Desc =>
      'Pilihlah satu pelajaran dari cerita yang paling menyentuh hati Anda dan niatkan untuk mengamalkannya dalam kehidupan sehari-hari.';

  @override
  String get tadabur_step6Title => 'BERDOA';

  @override
  String get tadabur_step6Desc =>
      'Tutup sesi tadabur dengan doa memohon kepada Allah untuk memberi pemahaman, kebijaksanaan, dan kemampuan untuk mengamalkan pelajaran.';

  @override
  String get tadabur_closing => 'Penutup';

  @override
  String get tadabur_closingDesc =>
      'Tadabur bukan sekadar membaca cerita, tetapi adalah proses transformasi diri melalui pemahaman dan renungan mendalam terhadap firman Allah. Semoga cerita-cerita ini membawa Anda lebih dekat kepada Allah.';

  @override
  String get tadabur_closingQuote =>
      '\"Dan mereka beriman kepada (Al-Quran) yang diturunkan kepadamu dan yang telah diturunkan sebelummu, dan mereka yakin akan adanya (kehidupan) akhirat.\" — Surah Al-Baqarah: 4';

  @override
  String tadabur_surahAyah(Object ayah, Object surah) {
    return 'Surah $surah : $ayah';
  }

  @override
  String get tadabur_readMore => 'Baca Selengkapnya';

  @override
  String get tadabur_storyHeading => 'Cerita';

  @override
  String get tadabur_lessonHeading => 'Pelajaran';

  @override
  String get tadabur_loadError => 'Gagal memuat cerita';

  @override
  String get tadabur_retryBtn => 'Coba Lagi';

  @override
  String get tadabur_emptyStories => 'Belum ada cerita';

  @override
  String get tadabur_searchEmpty => 'Cerita tidak ditemukan';
}
