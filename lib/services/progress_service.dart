import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ProgressService {
  static const String _key = 'progress_murajaah';
  static const String _historyKey = 'reading_history';
  static const int totalVerses = 6236;

  // ============ EXISTING METHODS (unchanged) ============

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

  // ============ NEW METHODS (History Tracking) ============

  /// Simpan verse dengan tracking history (timestamp otomatis)
  static Future<void> saveWithHistory({
    required int surah,
    required int ayat,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Update current position (existing behavior)
      await save(surah: surah, ayat: ayat);

      // Update reading history
      final today = _getTodayDateString();
      final verseId = '$surah:$ayat';

      final historyJson = prefs.getString(_historyKey) ?? '{}';
      final history = jsonDecode(historyJson) as Map<String, dynamic>;

      // Get today's verses or create empty list
      final todayVerses = List<String>.from(history[today] ?? []);

      // Add verse if not already present (uniqueness check)
      if (!todayVerses.contains(verseId)) {
        todayVerses.add(verseId);
        history[today] = todayVerses;

        await prefs.setString(_historyKey, jsonEncode(history));
      }
    } catch (e) {
      // Fallback: jika history tracking gagal, minimal simpan current position
      await save(surah: surah, ayat: ayat);
    }
  }

  /// Get jumlah ayat unik dibaca hari ini
  static Future<int> getVersesReadToday() async {
    final prefs = await SharedPreferences.getInstance();
    final today = _getTodayDateString();

    final historyJson = prefs.getString(_historyKey) ?? '{}';
    final history = jsonDecode(historyJson) as Map<String, dynamic>;

    final todayVerses = List<String>.from(history[today] ?? []);
    return todayVerses.length;
  }

  /// Get reading history untuk N hari terakhir
  /// Returns Map<date, List<verseIds>>
  static Future<Map<String, List<String>>> getHistory(int days) async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getString(_historyKey) ?? '{}';
    final allHistory = jsonDecode(historyJson) as Map<String, dynamic>;

    final result = <String, List<String>>{};
    final today = DateTime.now();

    for (int i = 0; i < days; i++) {
      final date = today.subtract(Duration(days: i));
      final dateString = _formatDate(date);
      result[dateString] = List<String>.from(allHistory[dateString] ?? []);
    }

    return result;
  }

  /// Get total ayat unik yang pernah dibaca (all time)
  static Future<int> getTotalVersesRead() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getString(_historyKey) ?? '{}';
    final history = jsonDecode(historyJson) as Map<String, dynamic>;

    final allVerses = <String>{};
    for (final dayVerses in history.values) {
      allVerses.addAll(List<String>.from(dayVerses));
    }

    return allVerses.length;
  }

  /// Reset semua progress dan history
  static Future<void> resetAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
    await prefs.remove(_historyKey);
  }

  // ============ HELPER METHODS ============

  static String _getTodayDateString() {
    final now = DateTime.now();
    return _formatDate(now);
  }

  static String _formatDate(DateTime date) {
    final year = date.year;
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }
}
