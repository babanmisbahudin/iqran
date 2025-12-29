import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ProgressService {
  static const String _key = 'progress_murajaah';

  /// SIMPAN progress (surah + ayat)
  static Future<void> save({
    required int surah,
    required int ayat,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _key,
      jsonEncode({
        'surah': surah,
        'ayat': ayat,
      }),
    );
  }

  /// LOAD progress
  static Future<Map<String, int>?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);

    if (raw == null) return null;

    final data = jsonDecode(raw);
    return {
      'surah': data['surah'] as int,
      'ayat': data['ayat'] as int,
    };
  }

  /// RESET progress
  static Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
