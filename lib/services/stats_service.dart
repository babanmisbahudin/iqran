import 'package:iqran/models/daily_stats.dart';
import 'package:iqran/models/reading_streak.dart';
import 'package:iqran/models/dashboard_metrics.dart';
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

  /// Calculate reading streak berdasarkan reading history
  static Future<ReadingStreak> calculateReadingStreak() async {
    final history = await ProgressService.getHistory(365); // Check 1 tahun

    if (history.isEmpty) {
      return ReadingStreak.empty();
    }

    // Sort dates descending (most recent first)
    final sortedDates = history.keys.toList()..sort((a, b) => b.compareTo(a));

    int currentStreak = 0;
    int longestStreak = 0;
    int tempStreak = 0;
    DateTime? currentStreakStart;
    DateTime? longestStreakStart;

    // Parse tanggal terakhir
    final today = DateTime.now();
    final todayStr =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    final yesterdayDate = today.subtract(const Duration(days: 1));
    final yesterdayStr =
        '${yesterdayDate.year}-${yesterdayDate.month.toString().padLeft(2, '0')}-${yesterdayDate.day.toString().padLeft(2, '0')}';

    bool readToday = history.containsKey(todayStr) && history[todayStr]!.isNotEmpty;
    bool readYesterday =
        history.containsKey(yesterdayStr) && history[yesterdayStr]!.isNotEmpty;

    // Calculate streaks
    DateTime? lastDate;
    for (final dateStr in sortedDates) {
      if (history[dateStr]!.isEmpty) continue;

      if (lastDate == null) {
        // First activity
        tempStreak = 1;
        currentStreakStart = DateTime.parse(dateStr);
      } else {
        final currentDate = DateTime.parse(dateStr);
        final daysDiff = lastDate.difference(currentDate).inDays;

        if (daysDiff == 1) {
          // Consecutive day
          tempStreak++;
        } else {
          // Streak broken
          if (tempStreak > longestStreak) {
            longestStreak = tempStreak;
            longestStreakStart = currentStreakStart;
          }
          tempStreak = 1;
          currentStreakStart = currentDate;
        }
      }

      lastDate = DateTime.parse(dateStr);
    }

    // Check final streak
    if (tempStreak > longestStreak) {
      longestStreak = tempStreak;
      longestStreakStart = currentStreakStart;
    }

    // Determine current streak (must be recent, not old)
    if (readToday) {
      currentStreak = tempStreak;
    } else if (readYesterday) {
      currentStreak = tempStreak - 1; // Streak about to break
    } else {
      currentStreak = 0;
    }

    return ReadingStreak(
      currentStreak: currentStreak,
      longestStreak: longestStreak,
      currentStreakStartDate: currentStreakStart,
      longestStreakStartDate: longestStreakStart,
      readToday: readToday,
      readYesterday: readYesterday,
    );
  }

  /// Get aggregated dashboard metrics
  static Future<DashboardMetrics> getDashboardMetrics({
    int dailyTarget = 50,
  }) async {
    // Fetch all required data concurrently
    final results = await Future.wait([
      ProgressService.getTotalVersesRead(),
      ProgressService.getVersesReadToday(),
      getProgressPercentage(),
      calculateReadingStreak(),
      getDailyStats(30),
      getDailyStats(7),
    ]);

    final totalVersesRead = results[0] as int;
    final versesReadToday = results[1] as int;
    final completionPercentage = (results[2] as double) * 100;
    final streak = results[3] as ReadingStreak;
    final last30DaysStats = results[4] as List<DailyStats>;
    final last7DaysStats = results[5] as List<DailyStats>;

    // Calculate derived metrics
    final completedSurahs =
        (totalVersesRead / 100).toInt(); // Rough estimate (average surah ~90 ayat)
    final todayProgressPercentage =
        (versesReadToday / dailyTarget * 100).clamp(0, 100).toDouble();
    final monthlyAverageVerses = last30DaysStats.isEmpty
        ? 0
        : (last30DaysStats.fold<int>(0, (sum, stat) => sum + stat.uniqueVersesRead) /
                last30DaysStats.length)
            .toInt();

    // Get last 7 days verses (reverse to oldest first)
    final last7DaysVerses = <int>[];
    for (int i = 6; i >= 0; i--) {
      final dateStr =
          '${DateTime.now().subtract(Duration(days: i)).year}-${DateTime.now().subtract(Duration(days: i)).month.toString().padLeft(2, '0')}-${DateTime.now().subtract(Duration(days: i)).day.toString().padLeft(2, '0')}';
      final stat = last7DaysStats.firstWhere(
        (s) => s.date == dateStr,
        orElse: () => DailyStats(date: dateStr, uniqueVersesRead: 0, hasActivity: false),
      );
      last7DaysVerses.add(stat.uniqueVersesRead);
    }

    return DashboardMetrics(
      totalVersesRead: totalVersesRead,
      totalSurahCompleted: completedSurahs,
      completionPercentage: completionPercentage,
      versesReadToday: versesReadToday,
      dailyTarget: dailyTarget,
      todayProgressPercentage: todayProgressPercentage,
      streak: streak,
      monthlyAverageVerses: monthlyAverageVerses,
      last7DaysVerses: last7DaysVerses,
      lastUpdated: DateTime.now(),
    );
  }
}
