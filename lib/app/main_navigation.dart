import 'package:flutter/material.dart';
import '../pages/quran/surah_list_page.dart';
import '../pages/bookmark/bookmark_page.dart';
import '../pages/progress/progress_page.dart';
import '../pages/settings/settings_page.dart';

class MainNavigation extends StatefulWidget {
  final bool isDark;
  final double fontSize;
  final ValueChanged<bool> onTheme;
  final ValueChanged<double> onFont;

  const MainNavigation({
    super.key,
    required this.isDark,
    required this.fontSize,
    required this.onTheme,
    required this.onFont,
  });

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      SurahListPage(fontSize: widget.fontSize),
      const BookmarkPage(),
      const ProgressPage(),
      SettingsPage(
        isDark: widget.isDark,
        fontSize: widget.fontSize,
        onTheme: widget.onTheme,
        onFont: widget.onFont,
      ),
    ];

    return Scaffold(
      body: pages[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Qur’an'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Bookmark'),
          BottomNavigationBarItem(icon: Icon(Icons.insights), label: 'Progress'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
