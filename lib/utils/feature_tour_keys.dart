import 'package:flutter/material.dart';

/// Global keys for feature tour showcase targets
/// Organized by page (HomePage: 4, ProgressPage: 5, SurahDetailPage: 6, SettingsPage: 1)
class FeatureTourKeys {
  // HomePage keys (4)
  static final GlobalKey lastReadSection = GlobalKey();
  static final GlobalKey statsSection = GlobalKey();
  static final GlobalKey featureQuran = GlobalKey();
  static final GlobalKey featureBookmark = GlobalKey();

  // ProgressPage keys (5)
  static final GlobalKey dailyTargetCard = GlobalKey();
  static final GlobalKey progressChart = GlobalKey();
  static final GlobalKey metricsSummary = GlobalKey();
  static final GlobalKey overallProgress = GlobalKey();
  static final GlobalKey resetButton = GlobalKey();

  // SettingsPage keys (1)
  static final GlobalKey replayTutorialButton = GlobalKey();

  // SurahDetailPage keys (6) - assigned dynamically
  static GlobalKey tajweedToggle = GlobalKey();
  static GlobalKey surahBookmark = GlobalKey();
  static GlobalKey latinToggle = GlobalKey();
  static GlobalKey translateToggle = GlobalKey();
  static GlobalKey tapAyatGesture = GlobalKey();
  static GlobalKey audioPanel = GlobalKey();

  /// Dispose all keys to free memory
  static void dispose() {
    // No need to manually dispose GlobalKeys, but you can reset them if needed
  }
}
