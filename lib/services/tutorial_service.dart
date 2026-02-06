import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import '../utils/feature_tour_keys.dart';

class TutorialService {
  static late SharedPreferences _prefs;
  static const String _keyTutorialCompleted = 'tutorial_completed';

  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<bool> hasTutorialCompleted() async {
    return _prefs.getBool(_keyTutorialCompleted) ?? false;
  }

  static Future<void> markTutorialComplete() async {
    await _prefs.setBool(_keyTutorialCompleted, true);
  }

  static Future<void> resetTutorial() async {
    await _prefs.setBool(_keyTutorialCompleted, false);
  }

  // Start tutorial - navigates through pages showing showcase
  static void startTutorial(BuildContext context) {
    hasTutorialCompleted().then((completed) {
      if (completed) return;
      // Start with HomePage tour
      // ignore: use_build_context_synchronously
      _startHomePageTour(context);
    });
  }

  // Replay tutorial
  static void replayTutorial(BuildContext context) {
    resetTutorial().then((_) {
      // ignore: use_build_context_synchronously
      startTutorial(context);
    });
  }

  // Start HomePage tour (4 targets)
  static void _startHomePageTour(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ShowCaseWidget.of(context).startShowCase([
        FeatureTourKeys.lastReadSection,
        FeatureTourKeys.statsSection,
        FeatureTourKeys.featureQuran,
        FeatureTourKeys.featureBookmark,
      ]);
    });
  }

  // Start ProgressPage tour (5 targets)
  // ignore: unused_element
  static void _startProgressPageTour(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ShowCaseWidget.of(context).startShowCase([
        FeatureTourKeys.dailyTargetCard,
        FeatureTourKeys.progressChart,
        FeatureTourKeys.metricsSummary,
        FeatureTourKeys.overallProgress,
        FeatureTourKeys.resetButton,
      ]);
    });
  }

  // Start SettingsPage tour (1 target)
  // ignore: unused_element
  static void _startSettingsPageTour(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ShowCaseWidget.of(context).startShowCase([
        FeatureTourKeys.replayTutorialButton,
      ]);
    });
  }

  // Navigation helper for multi-page tour
  static Future<void> navigateAndShowTour(
    BuildContext context,
    int tabIndex,
    VoidCallback? tourFunction,
  ) async {
    // This will be used by MainNavigation to switch tabs during tour
    tourFunction?.call();
  }
}
