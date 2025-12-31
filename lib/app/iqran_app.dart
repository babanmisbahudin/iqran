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

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isDark = prefs.getBool('dark') ?? true;
      arabFont = prefs.getDouble('font') ?? 28;
    });
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark', isDark);
    await prefs.setDouble('font', arabFont);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.build(isDark),
      home: Scaffold(
        body: MainNavigation(
          isDark: isDark,
          fontSize: arabFont,
          onTheme: (value) {
            setState(() => isDark = value);
            _savePreferences();
          },
          onFont: (value) {
            setState(() => arabFont = value);
            _savePreferences();
          },
        ),
        floatingActionButton: const GlobalAudioFAB(),
      ),
    );
  }
}
