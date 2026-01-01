import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/app_theme.dart';
import 'main_navigation.dart';
import '../widgets/global_audio_fab.dart';

class IqranApp extends StatefulWidget {
  const IqranApp({super.key});

  @override
  State<IqranApp> createState() => _IqranAppState();
}

class _IqranAppState extends State<IqranApp> {
  bool isDark = true;
  double arabFont = 28;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
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
