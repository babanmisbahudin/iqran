class DailyStats {
  final String date; // Format: "YYYY-MM-DD"
  final int uniqueVersesRead; // Jumlah ayat unik dibaca
  final bool hasActivity; // Ada bacaan atau tidak

  DailyStats({
    required this.date,
    required this.uniqueVersesRead,
    required this.hasActivity,
  });

  /// Create from JSON
  factory DailyStats.fromJson(Map<String, dynamic> json) {
    return DailyStats(
      date: json['date'] as String,
      uniqueVersesRead: json['uniqueVersesRead'] as int,
      hasActivity: json['hasActivity'] as bool,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() => {
        'date': date,
        'uniqueVersesRead': uniqueVersesRead,
        'hasActivity': hasActivity,
      };
}
