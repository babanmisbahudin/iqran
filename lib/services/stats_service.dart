import 'package:iqran/models/daily_stats.dart';
import 'progress_service.dart';

class StatsService {
  static const int totalVerses = 6236;

  /// Hitung estimasi tanggal hatam berdasarkan target harian
  /// Returns null jika sudah selesai atau target tidak valid
  static Future<DateTime?> estimateCompletionDate({
    required int dailyTarget,
  }) async {
    final totalRead = await ProgressService.getTotalVersesRead();
    final remaining = totalVerses - totalRead;

    // Sudah selesai
    if (remaining <= 0) return null;

    // Target tidak valid
    if (dailyTarget <= 0) return null;

    final daysNeeded = (remaining / dailyTarget).ceil();
    return DateTime.now().add(Duration(days: daysNeeded));
  }

  /// Get daily statistics untuk N hari terakhir
  static Future<List<DailyStats>> getDailyStats(int days) async {
    final history = await ProgressService.getHistory(days);

    final stats = history.entries.map((entry) {
      return DailyStats(
        date: entry.key,
        uniqueVersesRead: entry.value.length,
        hasActivity: entry.value.isNotEmpty,
      );
    }).toList();

    // Sort by date (newest first)
    stats.sort((a, b) => b.date.compareTo(a.date));

    return stats;
  }

  /// Hitung rata-rata ayat per hari (N hari terakhir)
  static Future<double> getAverageDailyVerses(int days) async {
    final stats = await getDailyStats(days);
    if (stats.isEmpty) return 0.0;

    final total =
        stats.fold<int>(0, (sum, stat) => sum + stat.uniqueVersesRead);
    return total / stats.length;
  }

  /// Get jumlah ayat yang tersisa sampai hatam
  static Future<int> getRemainingVerses() async {
    final totalRead = await ProgressService.getTotalVersesRead();
    return totalVerses - totalRead;
  }

  /// Get persentase progress (ayat unik / total ayat)
  static Future<double> getProgressPercentage() async {
    final totalRead = await ProgressService.getTotalVersesRead();
    return totalRead / totalVerses;
  }
}
