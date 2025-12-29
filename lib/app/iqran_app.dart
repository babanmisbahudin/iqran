import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';
import 'main_navigation.dart';

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
    _load();
  }

  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    setState(() {
      isDark = p.getBool('dark') ?? true;
      arabFont = p.getDouble('font') ?? 28;
    });
  }

  Future<void> _save() async {
    final p = await SharedPreferences.getInstance();
    await p.setBool('dark', isDark);
    await p.setDouble('font', arabFont);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.build(isDark),
      home: MainNavigation(
        isDark: isDark,
        fontSize: arabFont,
        onTheme: (v) {
          setState(() => isDark = v);
          _save();
        },
        onFont: (v) {
          setState(() => arabFont = v);
          _save();
        },
      ),
    );
  }
}
