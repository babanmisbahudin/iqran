import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/app_theme.dart';
import 'main_navigation.dart';
import '../widgets/global_audio_fab.dart';
import '../services/onboarding_service.dart';
import '../pages/onboarding/first_time_onboarding_page.dart';
import '../pages/onboarding/daily_onboarding_page.dart';

class IqranApp extends StatefulWidget {
  const IqranApp({super.key});

  @override
  State<IqranApp> createState() => _IqranAppState();
}

class _IqranAppState extends State<IqranApp> {
  bool isDark = true;
  double arabFont = 28;
  bool _isLoadingRoute = true;
  Widget? _initialRoute;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    _determineInitialRoute();
  }

  // Determine which screen to show on app startup
  Future<void> _determineInitialRoute() async {
    // Check if first launch
    if (await OnboardingService.isFirstLaunch()) {
      setState(() {
        _initialRoute = const FirstTimeOnboardingPage();
        _isLoadingRoute = false;
      });
      return;
    }

    // Check if should show daily onboarding
    if (await OnboardingService.shouldShowDailyOnboarding()) {
      setState(() {
        _initialRoute = DailyOnboardingPage(
          onDismiss: () {
            setState(() {
              _initialRoute = null;
            });
          },
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
    if (!mounted) return;

    setState(() {
      isDark = prefs.getBool('dark') ?? true;
      arabFont = prefs.getDouble('font') ?? 28;
    });
  }

  // =========================
  // SAVE PREFERENCES
  // =========================
  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark', isDark);
    await prefs.setDouble('font', arabFont);
  }

  @override
  Widget build(BuildContext context) {
    // Show loading or onboarding/daily screen
    if (_isLoadingRoute) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.build(isDark),
        home: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    // Show onboarding pages if needed
    if (_initialRoute != null) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.build(isDark),
        home: _initialRoute,
      );
    }

    // Show main navigation
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // =========================
      // THEME (LIGHT / DARK)
      // =========================
      theme: AppTheme.build(isDark),

      // =========================
      // ROOT SCAFFOLD
      // =========================
      home: Scaffold(
        body: MainNavigation(
          isDark: isDark,
          fontSize: arabFont,

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
        ),

        // =========================
        // GLOBAL AUDIO FAB
        // =========================
        floatingActionButton: const GlobalAudioFAB(),
      ),
    );
  }
}
