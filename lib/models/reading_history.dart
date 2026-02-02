class ReadingHistory {
  final String date; // Format: "YYYY-MM-DD"
  final Set<String> verses; // Format: "surah:ayat" (contoh: "1:5")

  ReadingHistory({
    required this.date,
    required this.verses,
  });

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() => {
        'date': date,
        'verses': verses.toList(),
      };

  /// Create from JSON
  factory ReadingHistory.fromJson(Map<String, dynamic> json) {
    return ReadingHistory(
      date: json['date'] as String,
      verses: Set<String>.from(json['verses'] as List),
    );
  }

  /// Get number of unique verses read
  int get count => verses.length;

  /// Check if this day has any activity
  bool get hasActivity => verses.isNotEmpty;
}
