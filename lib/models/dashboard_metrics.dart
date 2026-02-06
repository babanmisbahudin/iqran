import 'reading_streak.dart';

/// Model yang mengagregasi semua metrics untuk dashboard
class DashboardMetrics {
  /// Total ayat yang pernah dibaca (all-time)
  final int totalVersesRead;

  /// Jumlah surah yang sudah selesai
  final int totalSurahCompleted;

  /// Persentase keseluruhan Al-Qur'an yang sudah dibaca (0-100)
  final double completionPercentage;

  /// Ayat yang dibaca hari ini
  final int versesReadToday;

  /// Target ayat per hari
  final int dailyTarget;

  /// Progress hari ini vs target (0-100)
  final double todayProgressPercentage;

  /// Reading streak info
  final ReadingStreak streak;

  /// Average verses per hari (30 hari terakhir)
  final int monthlyAverageVerses;

  /// Data verses per hari (7 hari terakhir, index 0 = hari paling lama)
  final List<int> last7DaysVerses;

  /// Waktu terakhir diperbaharui
  final DateTime lastUpdated;

  DashboardMetrics({
    required this.totalVersesRead,
    required this.totalSurahCompleted,
    required this.completionPercentage,
    required this.versesReadToday,
    required this.dailyTarget,
    required this.todayProgressPercentage,
    required this.streak,
    required this.monthlyAverageVerses,
    required this.last7DaysVerses,
    required this.lastUpdated,
  });

  /// Factory untuk create empty metrics
  factory DashboardMetrics.empty() {
    return DashboardMetrics(
      totalVersesRead: 0,
      totalSurahCompleted: 0,
      completionPercentage: 0.0,
      versesReadToday: 0,
      dailyTarget: 50,
      todayProgressPercentage: 0.0,
      streak: ReadingStreak.empty(),
      monthlyAverageVerses: 0,
      last7DaysVerses: List.filled(7, 0),
      lastUpdated: DateTime.now(),
    );
  }

  @override
  String toString() =>
      'DashboardMetrics(total: $totalVersesRead, complete: $totalSurahCompleted%, today: $versesReadToday)';
}
