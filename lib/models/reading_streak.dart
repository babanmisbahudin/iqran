/// Model untuk tracking reading streak (kebiasaan membaca berturut-turut)
class ReadingStreak {
  /// Current streak (hari berturut-turut membaca)
  final int currentStreak;

  /// Longest streak all-time
  final int longestStreak;

  /// Tanggal mulai streak saat ini
  final DateTime? currentStreakStartDate;

  /// Tanggal mulai longest streak
  final DateTime? longestStreakStartDate;

  /// Apakah user membaca hari ini
  final bool readToday;

  /// Apakah user membaca kemarin
  final bool readYesterday;

  ReadingStreak({
    required this.currentStreak,
    required this.longestStreak,
    this.currentStreakStartDate,
    this.longestStreakStartDate,
    required this.readToday,
    required this.readYesterday,
  });

  /// Factory untuk create default (no streak)
  factory ReadingStreak.empty() {
    return ReadingStreak(
      currentStreak: 0,
      longestStreak: 0,
      currentStreakStartDate: null,
      longestStreakStartDate: null,
      readToday: false,
      readYesterday: false,
    );
  }

  @override
  String toString() =>
      'ReadingStreak(current: $currentStreak, longest: $longestStreak, readToday: $readToday)';
}
