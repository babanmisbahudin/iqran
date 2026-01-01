import 'package:shared_preferences/shared_preferences.dart';

class OfflineStatusService {
  static const _readyKey = 'offline_ready';
  static const _progressKey = 'offline_progress';

  static Future<void> setReady(bool value) async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(_readyKey, value);
  }

  static Future<bool> isReady() async {
    final p = await SharedPreferences.getInstance();
    return p.getBool(_readyKey) ?? false;
  }

  static Future<void> saveProgress(int current) async {
    final p = await SharedPreferences.getInstance();
    await p.setInt(_progressKey, current);
  }

  static Future<int> getProgress() async {
    final p = await SharedPreferences.getInstance();
    return p.getInt(_progressKey) ?? 0;
  }

  static Future<void> clearProgress() async {
    final p = await SharedPreferences.getInstance();
    await p.remove(_progressKey);
  }
}
