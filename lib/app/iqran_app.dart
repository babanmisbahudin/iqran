import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/app_theme.dart';
import 'main_navigation.dart';
import '../services/onboarding_service.dart';
import '../services/localization_service.dart';
import '../pages/onboarding/first_time_onboarding_page.dart';
import '../pages/onboarding/daily_onboarding_page.dart';
import '../l10n/app_localizations.dart';

class IqranApp extends StatefulWidget {
  const IqranApp({super.key});

  @override
  State<IqranApp> createState() => _IqranAppState();
}

class _IqranAppState extends State<IqranApp> {
  bool isDark = true;
  double arabFont = 28;
  double latinFont = 16;
  late Locale _currentLocale;
  bool _isLoadingRoute = true;
  Widget? _initialRoute;

  @override
  void initState() {
    super.initState();
    _currentLocale = const Locale('id'); // Default
    _loadPreferences();
    _determineInitialRoute();
  }

  void _handleDailyOnboardingDismiss() {
    if (!mounted) return;

    // Use addPostFrameCallback to ensure state change happens after current frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _initialRoute = null;
        });
      }
    });
  }

  // Determine which screen to show on app startup
  Future<void> _determineInitialRoute() async {
    // Set default locale to Indonesian (only supported language)
    if (!await LocalizationService.isLanguageSelected()) {
      const locale = Locale('id');
      setState(() => _currentLocale = locale);
      await LocalizationService.saveLocale(locale);
      await LocalizationService.markLanguageSelected();
    }

    // Check if first launch
    if (await OnboardingService.isFirstLaunch()) {
      setState(() {
        _initialRoute = FirstTimeOnboardingPage(
          onComplete: () {
            setState(() {
              _initialRoute = null;
            });
          },
        );
        _isLoadingRoute = false;
      });
      return;
    }

    // Check if should show daily onboarding
    if (await OnboardingService.shouldShowDailyOnboarding()) {
      setState(() {
        _initialRoute = DailyOnboardingPage(
          onDismiss: _handleDailyOnboardingDismiss,
        );
        _isLoadingRoute = false;
      });
      return;
    }

    // Normal flow - go to main navigation
    setState(() {
      _initialRoute = null;
      _isLoadingRoute = false;
    });
  }

  // =========================
  // LOAD PREFERENCES
  // =========================
  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final locale = await LocalizationService.loadLocale();

    if (!mounted) return;

    setState(() {
      isDark = prefs.getBool('dark') ?? true;
      arabFont = prefs.getDouble('font') ?? 28;
      latinFont = prefs.getDouble('latinFont') ?? 16;
      _currentLocale = locale;
    });
  }

  // =========================
  // SAVE PREFERENCES
  // =========================
  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark', isDark);
    await prefs.setDouble('font', arabFont);
    await prefs.setDouble('latinFont', latinFont);
  }

  @override
  Widget build(BuildContext context) {
    // Show loading or onboarding/daily screen
    if (_isLoadingRoute) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        locale: _currentLocale,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: LocalizationService.supportedLocales,
        theme: AppTheme.build(isDark),
        home: const Scaffold(
          backgroundColor: Colors.transparent,
          body: SizedBox.expand(),
        ),
      );
    }

    // Show onboarding pages if needed
    if (_initialRoute != null) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        locale: _currentLocale,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: LocalizationService.supportedLocales,
        theme: AppTheme.build(isDark),
        home: _initialRoute,
      );
    }

    // Show main navigation
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: _currentLocale,

      // =========================
      // LOCALIZATION
      // =========================
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: LocalizationService.supportedLocales,

      // =========================
      // THEME (LIGHT / DARK)
      // =========================
      theme: AppTheme.build(isDark),

      // =========================
      // MAIN NAVIGATION
      // =========================
      home: MainNavigation(
        isDark: isDark,
        fontSize: arabFont,
        latinFontSize: latinFont,

        // Toggle theme
        onTheme: (value) {
          setState(() => isDark = value);
          _savePreferences();
        },

        // Change arab font size
        onFont: (value) {
          setState(() => arabFont = value);
          _savePreferences();
        },

        // Change latin font size
        onLatinFont: (value) {
          setState(() => latinFont = value);
          _savePreferences();
        },
      ),
    );
  }
}
