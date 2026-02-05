import 'package:flutter/material.dart';
import '../pages/home/home_page.dart';
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
      HomePage(fontSize: widget.fontSize),
      const ProgressPage(),
      SettingsPage(
        isDark: widget.isDark,
        fontSize: widget.fontSize,
        onTheme: widget.onTheme,
        onFont: widget.onFont,
      ),
    ];

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 0.05),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
        child: PageStorage(
          bucket: PageStorageBucket(),
          child: pages[index],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.insights), label: 'Progress'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Pengaturan'),
        ],
      ),
    );
  }
}
