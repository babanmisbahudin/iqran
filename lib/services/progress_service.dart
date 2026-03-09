import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProgressService {
  static const String _key = 'progress_murajaah';
  static const String _historyKey = 'reading_history';
  static const String _dailyPositionKey = 'daily_position_history'; // Simpan posisi setiap hari
  static const String _dailyTargetKey = 'daily_target_ayat';
  static const int _defaultDailyTarget = 50;
  static const int totalVerses = 6236;

  // Real-time notifiers untuk listener (pattern sama seperti AudioPlayerService)
  static final ValueNotifier<int> versesTodayNotifier = ValueNotifier<int>(0);
  static final ValueNotifier<int> dailyTargetNotifier = ValueNotifier<int>(_defaultDailyTarget);

  // Jumlah ayat per surah (114 surahs) - FIXED
  static const List<int> surahVerseCount = [
    7, 286, 200, 176, 120, 165, 206, 75, 129, 109,   // 1-10
    123, 111, 43, 52, 99, 128, 111, 110, 98, 135,    // 11-20
    112, 78, 118, 64, 77, 227, 93, 88, 69, 60,       // 21-30
    34, 30, 73, 54, 45, 83, 182, 88, 75, 85,         // 31-40 (FIXED: 83,88,75,85)
    54, 53, 89, 59, 37, 35, 38, 29, 18, 45,          // 41-50 (FIXED)
    60, 49, 62, 55, 78, 96, 29, 22, 24, 13,          // 51-60 (FIXED)
    14, 11, 11, 18, 12, 12, 30, 52, 52, 44,          // 61-70 (FIXED)
    28, 28, 20, 56, 40, 31, 50, 40, 46, 42,          // 71-80 (FIXED)
    29, 19, 36, 25, 22, 17, 19, 26, 30, 20,          // 81-90 (FIXED)
    15, 21, 11, 8, 8, 19, 5, 8, 8, 11,               // 91-100 (FIXED)
    11, 8, 3, 9, 5, 4, 7, 3, 6, 3,                   // 101-110 (FIXED)
    5, 4, 5, 6,                                       // 111-114 (FIXED)
  ];

  // ============ HELPER METHODS ============

  /// Hitung jumlah ayat kumulatif dari Surah 1 sampai surah:ayat tertentu
  /// Contoh: Surah 3 ayat 5 = semua ayat Surah 1 + semua ayat Surah 2 + 5 ayat Surah 3
  static int calculateCumulativeVerses(int surah, int ayat) {
    if (surah < 1 || surah > 114) return 0;

    int total = 0;

    // Tambah semua ayat dari surah sebelumnya
    for (int i = 0; i < surah - 1; i++) {
      total += surahVerseCount[i];
    }

    // Tambah ayat dari surah saat ini
    total += ayat;

    return total;
  }

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
      final cumulativeVerses = calculateCumulativeVerses(surah, ayat);

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

      // Simpan posisi kumulatif untuk hari ini
      final dailyPosJson = prefs.getString(_dailyPositionKey) ?? '{}';
      final dailyPos = jsonDecode(dailyPosJson) as Map<String, dynamic>;
      dailyPos[today] = cumulativeVerses;
      await prefs.setString(_dailyPositionKey, jsonEncode(dailyPos));

      // Notify real-time listeners
      final todayCount = await getUniquePagesReadToday();
      versesTodayNotifier.value = todayCount;
    } catch (e) {
      // Fallback: jika history tracking gagal, minimal simpan current position
      await save(surah: surah, ayat: ayat);
    }
  }

  /// Get total ayat yang sudah dibaca berdasarkan posisi terakhir (cumulative)
  static Future<int> getTotalVersesReadFromPosition() async {
    final progress = await load();
    if (progress == null) return 0;

    final surah = progress['surah']!;
    final ayat = progress['ayat']!;

    return calculateCumulativeVerses(surah, ayat);
  }

  /// Get jumlah ayat dibaca hari ini (gunakan unique verse count, bukan position delta)
  /// FIX: Position delta bisa negative jika user jump ke earlier surah
  static Future<int> getVersesReadToday() async {
    // Fix: gunakan unique verse list, bukan position delta (bisa negative!)
    return getUniquePagesReadToday();
  }

  /// Get jumlah ayat unik dibaca hari ini (legacy method - untuk backward compatibility)
  static Future<int> getUniquePagesReadToday() async {
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

  /// Get total ayat yang sudah dibaca (all time) - berdasarkan posisi terakhir
  /// Ini menghitung dari Surah 1 sampai posisi terakhir yang disimpan
  static Future<int> getTotalVersesRead() async {
    return getTotalVersesReadFromPosition();
  }

  /// Reset semua progress dan history
  static Future<void> resetAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
    await prefs.remove(_historyKey);
    await prefs.remove(_dailyPositionKey);
    // JANGAN reset dailyTargetNotifier — target harian user preference tetap
    versesTodayNotifier.value = 0;
  }

  // ============ NOTIFIER INITIALIZATION ============

  /// Initialize notifiers dengan nilai dari SharedPreferences
  static Future<void> initializeNotifiers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedTarget = prefs.getInt(_dailyTargetKey) ?? _defaultDailyTarget;
      dailyTargetNotifier.value = savedTarget;
      final todayCount = await getUniquePagesReadToday();
      versesTodayNotifier.value = todayCount;
    } catch (e) {
      debugPrint('Error initializing notifiers: $e');
    }
  }

  /// Simpan daily target dan update notifier
  static Future<void> saveDailyTarget(int target) async {
    try {
      dailyTargetNotifier.value = target; // Update notifier dulu (sync)
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_dailyTargetKey, target);
    } catch (e) {
      debugPrint('Error saving daily target: $e');
    }
  }

  /// Load daily target dari SharedPreferences
  static Future<int> loadDailyTarget() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_dailyTargetKey) ?? _defaultDailyTarget;
    } catch (e) {
      debugPrint('Error loading daily target: $e');
      return _defaultDailyTarget;
    }
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
