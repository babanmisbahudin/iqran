import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
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
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'iQran'**
  String get appName;

  /// No description provided for @splashSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Be productive in dunya and akhirah, starting from the Qur\'an'**
  String get splashSubtitle;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get navProgress;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @selectLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Language'**
  String get selectLanguageTitle;

  /// No description provided for @selectLanguageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You can change this anytime in Settings'**
  String get selectLanguageSubtitle;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageIndonesian.
  ///
  /// In en, this message translates to:
  /// **'Indonesia'**
  String get languageIndonesian;

  /// No description provided for @btnContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get btnContinue;

  /// No description provided for @btnSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get btnSkip;

  /// No description provided for @btnStartNow.
  ///
  /// In en, this message translates to:
  /// **'Start Now'**
  String get btnStartNow;

  /// No description provided for @onb1Title.
  ///
  /// In en, this message translates to:
  /// **'Assalamu\'alaikum! 👋'**
  String get onb1Title;

  /// No description provided for @onb1Desc.
  ///
  /// In en, this message translates to:
  /// **'Welcome to IQRAN. An app to simplify your daily Qur\'an recitation review.'**
  String get onb1Desc;

  /// No description provided for @onb2Title.
  ///
  /// In en, this message translates to:
  /// **'Key Features'**
  String get onb2Title;

  /// No description provided for @onb2Desc.
  ///
  /// In en, this message translates to:
  /// **'Read the Qur\'an with tajweed, save favorite verses, track your reading progress, and listen to high-quality Qur\'an recitations.'**
  String get onb2Desc;

  /// No description provided for @onb3Title.
  ///
  /// In en, this message translates to:
  /// **'Begin Your Review Journey'**
  String get onb3Title;

  /// No description provided for @onb3Desc.
  ///
  /// In en, this message translates to:
  /// **'Let\'s be consistent in reading and understanding the Qur\'an. Every day is an opportunity to be closer to the Book of Allah.'**
  String get onb3Desc;

  /// No description provided for @greeting.
  ///
  /// In en, this message translates to:
  /// **'Assalamu\'alaikum'**
  String get greeting;

  /// No description provided for @featQuran.
  ///
  /// In en, this message translates to:
  /// **'Al-Qur\'an'**
  String get featQuran;

  /// No description provided for @featQuranDesc.
  ///
  /// In en, this message translates to:
  /// **'Read Qur\'an'**
  String get featQuranDesc;

  /// No description provided for @featBookmark.
  ///
  /// In en, this message translates to:
  /// **'Bookmark'**
  String get featBookmark;

  /// No description provided for @featBookmarkDesc.
  ///
  /// In en, this message translates to:
  /// **'Favorite Surahs'**
  String get featBookmarkDesc;

  /// No description provided for @featTutorial.
  ///
  /// In en, this message translates to:
  /// **'Tutorial'**
  String get featTutorial;

  /// No description provided for @featTutorialDesc.
  ///
  /// In en, this message translates to:
  /// **'App Guide'**
  String get featTutorialDesc;

  /// No description provided for @featDonation.
  ///
  /// In en, this message translates to:
  /// **'Donate'**
  String get featDonation;

  /// No description provided for @featDonationDesc.
  ///
  /// In en, this message translates to:
  /// **'Support Developer'**
  String get featDonationDesc;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsDisplay.
  ///
  /// In en, this message translates to:
  /// **'Display'**
  String get settingsDisplay;

  /// No description provided for @settingsDarkMode.
  ///
  /// In en, this message translates to:
  /// **'Light/Dark Mode'**
  String get settingsDarkMode;

  /// No description provided for @settingsDarkModeDesc.
  ///
  /// In en, this message translates to:
  /// **'Toggle light or dark mode'**
  String get settingsDarkModeDesc;

  /// No description provided for @settingsFontSize.
  ///
  /// In en, this message translates to:
  /// **'Arabic Font Size: {size}'**
  String settingsFontSize(int size);

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageDesc.
  ///
  /// In en, this message translates to:
  /// **'Change app language'**
  String get settingsLanguageDesc;

  /// No description provided for @settingsOffline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get settingsOffline;

  /// No description provided for @settingsOfflineReady.
  ///
  /// In en, this message translates to:
  /// **'Al-Qur\'an is ready for offline use'**
  String get settingsOfflineReady;

  /// No description provided for @settingsOfflineDownloading.
  ///
  /// In en, this message translates to:
  /// **'Downloading {current} / {total} surahs'**
  String settingsOfflineDownloading(int current, int total);

  /// No description provided for @settingsOfflinePrompt.
  ///
  /// In en, this message translates to:
  /// **'Download all surahs so the app can still be used without an internet connection.'**
  String get settingsOfflinePrompt;

  /// No description provided for @settingsOfflineBtn.
  ///
  /// In en, this message translates to:
  /// **'Download all surahs'**
  String get settingsOfflineBtn;

  /// No description provided for @settingsOfflineSuccess.
  ///
  /// In en, this message translates to:
  /// **'Al-Qur\'an is ready for offline use'**
  String get settingsOfflineSuccess;

  /// No description provided for @settingsOfflineError.
  ///
  /// In en, this message translates to:
  /// **'Failed to download offline data'**
  String get settingsOfflineError;

  /// No description provided for @dailyGreeting.
  ///
  /// In en, this message translates to:
  /// **'Assalamu\'alaikum wa Rahmatullahi wa Barakatuh'**
  String get dailyGreeting;

  /// No description provided for @dailyBtn.
  ///
  /// In en, this message translates to:
  /// **'Continue Reading'**
  String get dailyBtn;
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
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
