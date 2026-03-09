import 'package:flutter/material.dart';

/// Screen size classification based on width breakpoints
enum ScreenSize { phone, tablet, desktop }

/// Centralized responsive design utility class for iQran app
///
/// Breakpoints:
///   phone   : width < 600px
///   tablet  : 600px <= width < 900px
///   desktop : width >= 900px
///
/// Provides consistent sizing, spacing, and layout decisions across all pages.
class ResponsiveHelper {
  // --- Breakpoints ---
  static const double kPhoneBreak = 600.0;
  static const double kTabletBreak = 900.0;
  static const double kDesktopBreak = 1200.0; // wide desktop

  // --- Screen size classification ---
  /// Classify screen size from BuildContext
  static ScreenSize screenSizeOf(BuildContext context) =>
      _classify(MediaQuery.of(context).size.width);

  /// Classify screen size from width in pixels
  static ScreenSize screenSizeFrom(double width) => _classify(width);

  static ScreenSize _classify(double w) {
    if (w >= kTabletBreak) return ScreenSize.desktop;
    if (w >= kPhoneBreak) return ScreenSize.tablet;
    return ScreenSize.phone;
  }

  // --- Convenience boolean checks ---
  static bool isPhone(BuildContext context) =>
      screenSizeOf(context) == ScreenSize.phone;

  static bool isTablet(BuildContext context) =>
      screenSizeOf(context) == ScreenSize.tablet;

  static bool isDesktop(BuildContext context) =>
      screenSizeOf(context) == ScreenSize.desktop;

  static bool isTabletOrDesktop(BuildContext context) => !isPhone(context);

  // --- Horizontal padding (matches existing home_page.dart) ---
  /// Get responsive horizontal padding based on screen width
  static double horizontalPadding(double width) {
    if (width > kDesktopBreak) return 32.0;
    if (width > kTabletBreak) return 24.0;
    if (width > kPhoneBreak) return 20.0;
    return 16.0;
  }

  // --- Feature grid (home page) ---
  /// Get number of columns for feature grid
  static int featureGridColumns(double w) {
    if (w > kDesktopBreak) return 4;
    if (w > kTabletBreak) return 3;
    return 2;
  }

  /// Get spacing between feature grid items
  static double featureGridSpacing(double w) {
    if (w > kDesktopBreak) return 20.0;
    if (w > kTabletBreak) return 16.0;
    return 14.0;
  }

  /// Get aspect ratio for feature cards
  static double featureCardAspectRatio(int columns) {
    if (columns >= 4) return 0.85;
    if (columns == 3) return 0.88;
    return 0.92;
  }

  // --- Feature card internals ---
  /// Icon size in feature cards
  static double featureIconSize(double w) {
    if (w > kDesktopBreak) return 64.0;
    if (w > kTabletBreak) return 60.0;
    return 56.0;
  }

  /// Icon padding in feature cards
  static double featureIconPadding(double w) {
    if (w > kTabletBreak) return 16.0;
    return 14.0;
  }

  /// Title font size in feature cards
  static double featureTitleFontSize(double w) {
    if (w > kTabletBreak) return 16.0;
    return 15.0;
  }

  /// Description font size in feature cards
  static double featureDescriptionFontSize(double w) {
    if (w > kTabletBreak) return 13.0;
    return 12.0;
  }

  // --- Surah list ---
  /// Number of columns for surah list
  static int surahListColumns(double w) {
    if (w >= kTabletBreak) return 2;
    return 1;
  }

  /// Arabic trailing text font size in surah list
  static double arabicTrailingFontSize(double w) {
    if (w >= kTabletBreak) return 24.0;
    return 22.0;
  }

  // --- Content max width (for readable line lengths) ---
  /// Get max width for content to prevent overly-wide layouts
  static double contentMaxWidth(ScreenSize size) {
    switch (size) {
      case ScreenSize.desktop:
        return 900.0;
      case ScreenSize.tablet:
        return 700.0;
      case ScreenSize.phone:
        return double.infinity;
    }
  }

  // --- Surah detail ---
  /// Responsive padding for surah detail page
  static EdgeInsets surahDetailPadding(double w) {
    if (w > kTabletBreak) {
      return const EdgeInsets.symmetric(horizontal: 32, vertical: 24);
    }
    if (w > kPhoneBreak) {
      return const EdgeInsets.symmetric(horizontal: 24, vertical: 20);
    }
    return const EdgeInsets.all(16);
  }

  // --- Navbar ---
  /// Icon size for main navigation navbar
  static double navbarIconSize(double w) {
    if (w >= kTabletBreak) return 28.0;
    return 24.0;
  }

  // --- Progress page ---
  /// Should progress page use 2-column layout?
  static bool useProgressTwoColumn(double w) => w >= kTabletBreak;
}
