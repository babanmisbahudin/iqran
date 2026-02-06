/// Audio metadata untuk track yang sedang diputar
class AudioMetadata {
  final int surahNumber;
  final String surahName;
  final String surahNameLatin;
  final int ayatCount;
  final String qariName;
  final String qariKey;
  final String audioUrl;
  final Duration? duration;

  /// Untuk playlist support
  final int? previousSurah;
  final int? nextSurah;

  AudioMetadata({
    required this.surahNumber,
    required this.surahName,
    required this.surahNameLatin,
    required this.ayatCount,
    required this.qariName,
    required this.qariKey,
    required this.audioUrl,
    this.duration,
    this.previousSurah,
    this.nextSurah,
  });

  /// Copy with untuk membuat instance baru dengan perubahan tertentu
  AudioMetadata copyWith({
    int? surahNumber,
    String? surahName,
    String? surahNameLatin,
    int? ayatCount,
    String? qariName,
    String? qariKey,
    String? audioUrl,
    Duration? duration,
    int? previousSurah,
    int? nextSurah,
  }) {
    return AudioMetadata(
      surahNumber: surahNumber ?? this.surahNumber,
      surahName: surahName ?? this.surahName,
      surahNameLatin: surahNameLatin ?? this.surahNameLatin,
      ayatCount: ayatCount ?? this.ayatCount,
      qariName: qariName ?? this.qariName,
      qariKey: qariKey ?? this.qariKey,
      audioUrl: audioUrl ?? this.audioUrl,
      duration: duration ?? this.duration,
      previousSurah: previousSurah ?? this.previousSurah,
      nextSurah: nextSurah ?? this.nextSurah,
    );
  }

  @override
  String toString() =>
      'AudioMetadata(surah: $surahNumber, name: $surahName, qari: $qariName)';
}
