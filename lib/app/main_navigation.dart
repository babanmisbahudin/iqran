import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import '../models/audio_metadata.dart';
import '../pages/home/home_page.dart';
import '../pages/progress/progress_page.dart';
import '../pages/settings/settings_page.dart';
import '../services/audio_player_service.dart';
import '../widgets/mini_player/mini_player_overlay.dart';
import '../l10n/app_localizations.dart';

class MainNavigation extends StatefulWidget {
  final bool isDark;
  final double fontSize;
  final ValueChanged<bool> onTheme;
  final ValueChanged<double> onFont;
  final ValueChanged<Locale> onLocale;

  const MainNavigation({
    super.key,
    required this.isDark,
    required this.fontSize,
    required this.onTheme,
    required this.onFont,
    required this.onLocale,
  });

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final currentLocale = Localizations.localeOf(context);
    final pages = [
      HomePage(
        key: ValueKey('${widget.fontSize}_${currentLocale.languageCode}'),
        fontSize: widget.fontSize,
      ),
      const ProgressPage(),
      SettingsPage(
        isDark: widget.isDark,
        fontSize: widget.fontSize,
        onTheme: widget.onTheme,
        onFont: widget.onFont,
        onLocale: widget.onLocale,
      ),
    ];

    return Scaffold(
      body: Stack(
        children: [
          // Main content
          AnimatedSwitcher(
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
          // Mini-player overlay (draggable within MiniPlayerOverlay)
          MiniPlayerOverlay(key: MiniPlayerOverlay.globalKey),
          // Floating Glass Navbar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildFloatingGlassNavbar(),
          ),
        ],
      ),
      floatingActionButton: _buildShowMiniPlayerFab(),
    );
  }

  Widget _buildFloatingGlassNavbar() {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            decoration: BoxDecoration(
              color: (isDark ? Colors.black : Colors.white).withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1.5,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavbarItem(
                    icon: Icons.home_rounded,
                    label: l10n.navHome,
                    isActive: index == 0,
                    onTap: () => setState(() => index = 0),
                    cs: cs,
                  ),
                  _buildNavbarItem(
                    icon: Icons.insights_rounded,
                    label: l10n.navProgress,
                    isActive: index == 1,
                    onTap: () => setState(() => index = 1),
                    cs: cs,
                  ),
                  _buildNavbarItem(
                    icon: Icons.settings_rounded,
                    label: l10n.navSettings,
                    isActive: index == 2,
                    onTap: () => setState(() => index = 2),
                    cs: cs,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavbarItem({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
    required ColorScheme cs,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isActive
                  ? cs.primary.withValues(alpha: 0.3)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: isActive ? cs.primary : cs.onSurface.withValues(alpha: 0.6),
              size: 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: isActive
                  ? cs.primary
                  : cs.onSurface.withValues(alpha: 0.6),
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShowMiniPlayerFab() {
    return ValueListenableBuilder<AudioMetadata?>(
      valueListenable: AudioPlayerService.currentMetadata,
      builder: (context, metadata, _) {
        // Only show FAB if audio is playing and mini player is hidden
        if (metadata != null && MiniPlayerOverlay.isHidden()) {
          return const FloatingActionButton(
            onPressed: MiniPlayerOverlay.show,
            tooltip: 'Show player',
            mini: true,
            child: Icon(Icons.expand_more_rounded),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
