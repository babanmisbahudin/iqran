class Doa {
  final String id;
  final String title;         // "Doa Sebelum Makan"
  final String arabic;        // Arab text
  final String latin;         // Transliterasi
  final String translation;   // Terjemahan Indonesia

  Doa({
    required this.id,
    required this.title,
    required this.arabic,
    required this.latin,
    required this.translation,
  });

  factory Doa.fromJson(Map<String, dynamic> json) {
    return Doa(
      id: (json['id'] ?? json['ID'] ?? 0).toString(),
      title: json['title'] ?? json['judul'] ?? json['nama'] ?? '',
      arabic: json['arab'] ?? json['arabic'] ?? json['ayat'] ?? '',
      latin: json['latin'] ?? json['transliterasi'] ?? '',
      translation: json['terjemahan'] ?? json['translation'] ?? json['arti'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'arabic': arabic,
      'latin': latin,
      'translation': translation,
    };
  }

  @override
  String toString() => title;
}
