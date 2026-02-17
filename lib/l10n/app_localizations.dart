import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('id')];

  /// No description provided for @appName.
  ///
  /// In id, this message translates to:
  /// **'iQran'**
  String get appName;

  /// No description provided for @splashSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Produktif dunia-akhirat, mulai dari Al-Qur\'an'**
  String get splashSubtitle;

  /// No description provided for @navHome.
  ///
  /// In id, this message translates to:
  /// **'Beranda'**
  String get navHome;

  /// No description provided for @navTadabur.
  ///
  /// In id, this message translates to:
  /// **'Tadabur'**
  String get navTadabur;

  /// No description provided for @navProgress.
  ///
  /// In id, this message translates to:
  /// **'Kemajuan'**
  String get navProgress;

  /// No description provided for @navSettings.
  ///
  /// In id, this message translates to:
  /// **'Pengaturan'**
  String get navSettings;

  /// No description provided for @selectLanguageTitle.
  ///
  /// In id, this message translates to:
  /// **'Pilih Bahasa'**
  String get selectLanguageTitle;

  /// No description provided for @selectLanguageSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Anda dapat mengubahnya kapan saja di Pengaturan'**
  String get selectLanguageSubtitle;

  /// No description provided for @languageEnglish.
  ///
  /// In id, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageIndonesian.
  ///
  /// In id, this message translates to:
  /// **'Indonesia'**
  String get languageIndonesian;

  /// No description provided for @btnContinue.
  ///
  /// In id, this message translates to:
  /// **'Lanjutkan'**
  String get btnContinue;

  /// No description provided for @btnSkip.
  ///
  /// In id, this message translates to:
  /// **'Lewati'**
  String get btnSkip;

  /// No description provided for @btnStartNow.
  ///
  /// In id, this message translates to:
  /// **'Mulai Sekarang'**
  String get btnStartNow;

  /// No description provided for @onb1Title.
  ///
  /// In id, this message translates to:
  /// **'Assalamu\'alaikum! 👋'**
  String get onb1Title;

  /// No description provided for @onb1Desc.
  ///
  /// In id, this message translates to:
  /// **'Selamat datang di IQRAN. Aplikasi untuk mempermudah murajaah Al-Qur\'an harian Anda.'**
  String get onb1Desc;

  /// No description provided for @onb2Title.
  ///
  /// In id, this message translates to:
  /// **'Fitur Unggulan'**
  String get onb2Title;

  /// No description provided for @onb2Desc.
  ///
  /// In id, this message translates to:
  /// **'Baca Al-Qur\'an dengan tajweed, simpan ayat favorit, pantau progress murajaah, dan dengarkan murottal berkualitas.'**
  String get onb2Desc;

  /// No description provided for @onb3Title.
  ///
  /// In id, this message translates to:
  /// **'Mulai Perjalanan Murajaah'**
  String get onb3Title;

  /// No description provided for @onb3Desc.
  ///
  /// In id, this message translates to:
  /// **'Mari konsisten membaca dan memahami Al-Qur\'an. Setiap hari adalah kesempatan untuk lebih dekat pada Kitab Allah.'**
  String get onb3Desc;

  /// No description provided for @onb4Title.
  ///
  /// In id, this message translates to:
  /// **'Fitur Tadabur - Renungan Mendalam'**
  String get onb4Title;

  /// No description provided for @onb4Desc.
  ///
  /// In id, this message translates to:
  /// **'Eksplorasi 129+ cerita islami yang menginspirasi. Setiap cerita dilengkapi dengan doa dan pelajaran spiritual untuk memperdalam pemahaman dan iman Anda.'**
  String get onb4Desc;

  /// No description provided for @greeting.
  ///
  /// In id, this message translates to:
  /// **'Assalamu\'alaikum'**
  String get greeting;

  /// No description provided for @featQuran.
  ///
  /// In id, this message translates to:
  /// **'Al-Qur\'an'**
  String get featQuran;

  /// No description provided for @featQuranDesc.
  ///
  /// In id, this message translates to:
  /// **'Baca Qur\'an'**
  String get featQuranDesc;

  /// No description provided for @featBookmark.
  ///
  /// In id, this message translates to:
  /// **'Bookmark'**
  String get featBookmark;

  /// No description provided for @featBookmarkDesc.
  ///
  /// In id, this message translates to:
  /// **'Surah Favorit'**
  String get featBookmarkDesc;

  /// No description provided for @featTutorial.
  ///
  /// In id, this message translates to:
  /// **'Tutorial'**
  String get featTutorial;

  /// No description provided for @featTutorialDesc.
  ///
  /// In id, this message translates to:
  /// **'Panduan Aplikasi'**
  String get featTutorialDesc;

  /// No description provided for @featDonation.
  ///
  /// In id, this message translates to:
  /// **'Donasi'**
  String get featDonation;

  /// No description provided for @featDonationDesc.
  ///
  /// In id, this message translates to:
  /// **'Dukung Developer'**
  String get featDonationDesc;

  /// No description provided for @settingsTitle.
  ///
  /// In id, this message translates to:
  /// **'Pengaturan'**
  String get settingsTitle;

  /// No description provided for @settingsDisplay.
  ///
  /// In id, this message translates to:
  /// **'Tampilan'**
  String get settingsDisplay;

  /// No description provided for @settingsDarkMode.
  ///
  /// In id, this message translates to:
  /// **'Light/Dark Mode'**
  String get settingsDarkMode;

  /// No description provided for @settingsDarkModeDesc.
  ///
  /// In id, this message translates to:
  /// **'Aktifkan mode terang atau gelap'**
  String get settingsDarkModeDesc;

  /// No description provided for @settingsFontSize.
  ///
  /// In id, this message translates to:
  /// **'Ukuran Font Arab: {size}'**
  String settingsFontSize(Object size);

  /// No description provided for @settingsLanguage.
  ///
  /// In id, this message translates to:
  /// **'Bahasa'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageDesc.
  ///
  /// In id, this message translates to:
  /// **'Ganti bahasa aplikasi'**
  String get settingsLanguageDesc;

  /// No description provided for @settingsOffline.
  ///
  /// In id, this message translates to:
  /// **'Offline'**
  String get settingsOffline;

  /// No description provided for @settingsOfflineReady.
  ///
  /// In id, this message translates to:
  /// **'Al-Qur\'an sudah siap digunakan secara offline'**
  String get settingsOfflineReady;

  /// No description provided for @settingsOfflineDownloading.
  ///
  /// In id, this message translates to:
  /// **'Mengunduh {current} / {total} surah'**
  String settingsOfflineDownloading(Object current, Object total);

  /// No description provided for @settingsOfflinePrompt.
  ///
  /// In id, this message translates to:
  /// **'Unduh seluruh surah agar aplikasi tetap bisa digunakan tanpa koneksi internet.'**
  String get settingsOfflinePrompt;

  /// No description provided for @settingsOfflineBtn.
  ///
  /// In id, this message translates to:
  /// **'Download semua surah'**
  String get settingsOfflineBtn;

  /// No description provided for @settingsOfflineSuccess.
  ///
  /// In id, this message translates to:
  /// **'Al-Qur\'an sudah siap digunakan secara offline'**
  String get settingsOfflineSuccess;

  /// No description provided for @settingsOfflineError.
  ///
  /// In id, this message translates to:
  /// **'Gagal mengunduh data offline'**
  String get settingsOfflineError;

  /// No description provided for @dailyGreeting.
  ///
  /// In id, this message translates to:
  /// **'Assalamu\'alaikum wa Rahmatullahi wa Barakatuh'**
  String get dailyGreeting;

  /// No description provided for @dailyBtn.
  ///
  /// In id, this message translates to:
  /// **'Lanjutkan Bacaan'**
  String get dailyBtn;

  /// No description provided for @tadabur_searchPlaceholder.
  ///
  /// In id, this message translates to:
  /// **'Cari cerita...'**
  String get tadabur_searchPlaceholder;

  /// No description provided for @tadabur_guideTitle.
  ///
  /// In id, this message translates to:
  /// **'PANDUAN TADABUR'**
  String get tadabur_guideTitle;

  /// No description provided for @tadabur_step1Title.
  ///
  /// In id, this message translates to:
  /// **'PERSIAPAN HATI'**
  String get tadabur_step1Title;

  /// No description provided for @tadabur_step1Desc.
  ///
  /// In id, this message translates to:
  /// **'Mulai dengan niat yang ikhlas untuk memperbaiki diri dan mencari hikmah dari cerita-cerita Al-Quran. Bersihkan hati dari prasangka dan kebisingan pikiran.'**
  String get tadabur_step1Desc;

  /// No description provided for @tadabur_step2Title.
  ///
  /// In id, this message translates to:
  /// **'MEMBACA CERITA'**
  String get tadabur_step2Title;

  /// No description provided for @tadabur_step2Desc.
  ///
  /// In id, this message translates to:
  /// **'Baca cerita dengan penuh perhatian. Jika memungkinkan, baca langsung dari Al-Quran pada surah-surah yang disebutkan untuk menambah kekhusyukan.'**
  String get tadabur_step2Desc;

  /// No description provided for @tadabur_step3Title.
  ///
  /// In id, this message translates to:
  /// **'MERENUNGKAN'**
  String get tadabur_step3Title;

  /// No description provided for @tadabur_step3Desc.
  ///
  /// In id, this message translates to:
  /// **'Luangkan waktu untuk merenungkan makna cerita. Hubungkan dengan kehidupan pribadi Anda. Apa pesan yang ingin Allah sampaikan melalui cerita ini?'**
  String get tadabur_step3Desc;

  /// No description provided for @tadabur_step4Title.
  ///
  /// In id, this message translates to:
  /// **'MENJAWAB PERTANYAAN'**
  String get tadabur_step4Title;

  /// No description provided for @tadabur_step4Desc.
  ///
  /// In id, this message translates to:
  /// **'Jawab pertanyaan-pertanyaan dengan jujur dan mendalam. Jangan sekadar menjawab di permukaan, tapi gali lebih dalam.'**
  String get tadabur_step4Desc;

  /// No description provided for @tadabur_step5Title.
  ///
  /// In id, this message translates to:
  /// **'MENGAMALKAN'**
  String get tadabur_step5Title;

  /// No description provided for @tadabur_step5Desc.
  ///
  /// In id, this message translates to:
  /// **'Pilihlah satu pelajaran dari cerita yang paling menyentuh hati Anda dan niatkan untuk mengamalkannya dalam kehidupan sehari-hari.'**
  String get tadabur_step5Desc;

  /// No description provided for @tadabur_step6Title.
  ///
  /// In id, this message translates to:
  /// **'BERDOA'**
  String get tadabur_step6Title;

  /// No description provided for @tadabur_step6Desc.
  ///
  /// In id, this message translates to:
  /// **'Tutup sesi tadabur dengan doa memohon kepada Allah untuk memberi pemahaman, kebijaksanaan, dan kemampuan untuk mengamalkan pelajaran.'**
  String get tadabur_step6Desc;

  /// No description provided for @tadabur_closing.
  ///
  /// In id, this message translates to:
  /// **'Penutup'**
  String get tadabur_closing;

  /// No description provided for @tadabur_closingDesc.
  ///
  /// In id, this message translates to:
  /// **'Tadabur bukan sekadar membaca cerita, tetapi adalah proses transformasi diri melalui pemahaman dan renungan mendalam terhadap firman Allah. Semoga cerita-cerita ini membawa Anda lebih dekat kepada Allah.'**
  String get tadabur_closingDesc;

  /// No description provided for @tadabur_closingQuote.
  ///
  /// In id, this message translates to:
  /// **'\"Dan mereka beriman kepada (Al-Quran) yang diturunkan kepadamu dan yang telah diturunkan sebelummu, dan mereka yakin akan adanya (kehidupan) akhirat.\" — Surah Al-Baqarah: 4'**
  String get tadabur_closingQuote;

  /// No description provided for @tadabur_surahAyah.
  ///
  /// In id, this message translates to:
  /// **'Surah {surah} : {ayah}'**
  String tadabur_surahAyah(Object ayah, Object surah);

  /// No description provided for @tadabur_readMore.
  ///
  /// In id, this message translates to:
  /// **'Baca Selengkapnya'**
  String get tadabur_readMore;

  /// No description provided for @tadabur_storyHeading.
  ///
  /// In id, this message translates to:
  /// **'Cerita'**
  String get tadabur_storyHeading;

  /// No description provided for @tadabur_lessonHeading.
  ///
  /// In id, this message translates to:
  /// **'Pelajaran'**
  String get tadabur_lessonHeading;

  /// No description provided for @tadabur_loadError.
  ///
  /// In id, this message translates to:
  /// **'Gagal memuat cerita'**
  String get tadabur_loadError;

  /// No description provided for @tadabur_retryBtn.
  ///
  /// In id, this message translates to:
  /// **'Coba Lagi'**
  String get tadabur_retryBtn;

  /// No description provided for @tadabur_emptyStories.
  ///
  /// In id, this message translates to:
  /// **'Belum ada cerita'**
  String get tadabur_emptyStories;

  /// No description provided for @tadabur_searchEmpty.
  ///
  /// In id, this message translates to:
  /// **'Cerita tidak ditemukan'**
  String get tadabur_searchEmpty;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
