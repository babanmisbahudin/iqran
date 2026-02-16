// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'iQran';

  @override
  String get splashSubtitle =>
      'Be productive in dunya and akhirah, starting from the Qur\'an';

  @override
  String get navHome => 'Home';

  @override
  String get navProgress => 'Progress';

  @override
  String get navSettings => 'Settings';

  @override
  String get selectLanguageTitle => 'Choose Your Language';

  @override
  String get selectLanguageSubtitle =>
      'You can change this anytime in Settings';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageIndonesian => 'Indonesia';

  @override
  String get btnContinue => 'Continue';

  @override
  String get btnSkip => 'Skip';

  @override
  String get btnStartNow => 'Start Now';

  @override
  String get onb1Title => 'Assalamu\'alaikum! 👋';

  @override
  String get onb1Desc =>
      'Welcome to IQRAN. An app to simplify your daily Qur\'an recitation review.';

  @override
  String get onb2Title => 'Key Features';

  @override
  String get onb2Desc =>
      'Read the Qur\'an with tajweed, save favorite verses, track your reading progress, and listen to high-quality Qur\'an recitations.';

  @override
  String get onb3Title => 'Begin Your Review Journey';

  @override
  String get onb3Desc =>
      'Let\'s be consistent in reading and understanding the Qur\'an. Every day is an opportunity to be closer to the Book of Allah.';

  @override
  String get greeting => 'Assalamu\'alaikum';

  @override
  String get featQuran => 'Al-Qur\'an';

  @override
  String get featQuranDesc => 'Read Qur\'an';

  @override
  String get featBookmark => 'Bookmark';

  @override
  String get featBookmarkDesc => 'Favorite Surahs';

  @override
  String get featTutorial => 'Tutorial';

  @override
  String get featTutorialDesc => 'App Guide';

  @override
  String get featDonation => 'Donate';

  @override
  String get featDonationDesc => 'Support Developer';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsDisplay => 'Display';

  @override
  String get settingsDarkMode => 'Light/Dark Mode';

  @override
  String get settingsDarkModeDesc => 'Toggle light or dark mode';

  @override
  String settingsFontSize(int size) {
    return 'Arabic Font Size: $size';
  }

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageDesc => 'Change app language';

  @override
  String get settingsOffline => 'Offline';

  @override
  String get settingsOfflineReady => 'Al-Qur\'an is ready for offline use';

  @override
  String settingsOfflineDownloading(int current, int total) {
    return 'Downloading $current / $total surahs';
  }

  @override
  String get settingsOfflinePrompt =>
      'Download all surahs so the app can still be used without an internet connection.';

  @override
  String get settingsOfflineBtn => 'Download all surahs';

  @override
  String get settingsOfflineSuccess => 'Al-Qur\'an is ready for offline use';

  @override
  String get settingsOfflineError => 'Failed to download offline data';

  @override
  String get dailyGreeting => 'Assalamu\'alaikum wa Rahmatullahi wa Barakatuh';

  @override
  String get dailyBtn => 'Continue Reading';
}
