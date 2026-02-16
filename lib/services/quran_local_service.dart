import 'package:flutter/services.dart';
import '../models/surah.dart';
import '../models/ayat.dart';
import '../data/quran_data.dart';

/// Local Quran Service - provides Quran data without API
/// All data is embedded in the app as JSON asset
class QuranLocalService {
  static bool _initialized = false;

  /// Initialize Quran data from assets (call once on app startup)
  static Future<void> initialize() async {
    if (_initialized) return;

    try {
      final jsonString = await rootBundle.loadString('assets/data/quran_data.json');
      await QuranData.initializeAyatData(jsonString);
      _initialized = true;
    } catch (e) {
      _initialized = false;
    }
  }

  /// Fetch all surahs from local data
  static Future<List<Surah>> fetchSurah() async {
    await initialize();
    return QuranData.allSurahs;
  }

  /// Fetch ayat for a specific surah from local data
  static Future<List<Ayat>> fetchAyat(int surahNumber) async {
    await initialize();
    return QuranData.getAyatBySurah(surahNumber);
  }

  /// Search surah by name (Latin or Arabic)
  static List<Surah> searchSurah(String query) {
    return QuranData.allSurahs
        .where((surah) =>
            surah.namaLatin.toLowerCase().contains(query.toLowerCase()) ||
            surah.nama.contains(query))
        .toList();
  }

  /// Get surah by number
  static Surah? getSurahByNumber(int number) {
    try {
      return QuranData.allSurahs.firstWhere((s) => s.nomor == number);
    } catch (e) {
      return null;
    }
  }

  /// Get ayat count for a surah
  static int getAyatCount(int surahNumber) {
    final surah = getSurahByNumber(surahNumber);
    return surah?.jumlahAyat ?? 0;
  }

  /// Check if data is initialized
  static bool get isInitialized => _initialized;
}
