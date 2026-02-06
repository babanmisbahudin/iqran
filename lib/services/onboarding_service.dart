import 'package:shared_preferences/shared_preferences.dart';

class OnboardingService {
  static late SharedPreferences _prefs;

  // Keys for SharedPreferences
  static const String _keyFirstLaunchCompleted = 'first_launch_completed';
  static const String _keyLastOnboardingDate = 'last_onboarding_date';
  static const String _keyTutorialCompleted = 'tutorial_completed';
  static const String _keySurahTourShown = 'surah_tour_shown';

  // Initialize the service
  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Check if this is the first launch (user has never seen onboarding)
  static Future<bool> isFirstLaunch() async {
    final completed = _prefs.getBool(_keyFirstLaunchCompleted) ?? false;
    return !completed;
  }

  // Mark first launch as completed
  static Future<void> completeFirstLaunch() async {
    await _prefs.setBool(_keyFirstLaunchCompleted, true);
  }

  // Check if daily onboarding should be shown
  // Returns true only if:
  // 1. First launch is completed AND
  // 2. Today's date is different from last_onboarding_date
  static Future<bool> shouldShowDailyOnboarding() async {
    final isFirst = await isFirstLaunch();

    // Don't show daily onboarding on first launch
    if (isFirst) {
      return false;
    }

    final lastDateStr = _prefs.getString(_keyLastOnboardingDate);

    // If never shown, don't show (handled by first launch flow)
    if (lastDateStr == null) {
      return false;
    }

    // Compare dates (ignore time)
    final today = DateTime.now();
    final todayStr = _formatDate(today);

    return lastDateStr != todayStr;
  }

  // Mark daily onboarding as shown today
  static Future<void> markOnboardingShown() async {
    final today = DateTime.now();
    final todayStr = _formatDate(today);
    await _prefs.setString(_keyLastOnboardingDate, todayStr);
  }

  // Check if user has completed the tutorial tour
  static Future<bool> hasTutorialCompleted() async {
    return _prefs.getBool(_keyTutorialCompleted) ?? false;
  }

  // Mark tutorial as completed
  static Future<void> markTutorialComplete() async {
    await _prefs.setBool(_keyTutorialCompleted, true);
  }

  // Reset tutorial (for replay)
  static Future<void> resetTutorial() async {
    await _prefs.setBool(_keyTutorialCompleted, false);
  }

  // Check if user has seen the SurahDetailPage tour
  static Future<bool> hasSurahTourBeenShown() async {
    return _prefs.getBool(_keySurahTourShown) ?? false;
  }

  // Mark SurahDetailPage tour as shown
  static Future<void> markSurahTourShown() async {
    await _prefs.setBool(_keySurahTourShown, true);
  }

  // Helper: Format date as YYYY-MM-DD
  static String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  // Reset all onboarding data (for testing/resetting)
  static Future<void> resetAll() async {
    await _prefs.remove(_keyFirstLaunchCompleted);
    await _prefs.remove(_keyLastOnboardingDate);
    await _prefs.remove(_keyTutorialCompleted);
    await _prefs.remove(_keySurahTourShown);
  }
}
