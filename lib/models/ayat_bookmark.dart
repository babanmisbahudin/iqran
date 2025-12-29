class AyatBookmark {
  final int surah;
  final String surahName;
  final int ayat;
  final String arab;

  AyatBookmark({
    required this.surah,
    required this.surahName,
    required this.ayat,
    required this.arab,
  });

  Map<String, dynamic> toJson() => {
        'surah': surah,
        'surahName': surahName,
        'ayat': ayat,
        'arab': arab,
      };

  factory AyatBookmark.fromJson(Map<String, dynamic> j) => AyatBookmark(
        surah: j['surah'],
        surahName: j['surahName'],
        ayat: j['ayat'],
        arab: j['arab'],
      );
}
