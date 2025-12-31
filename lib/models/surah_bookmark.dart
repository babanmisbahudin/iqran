class SurahBookmark {
  final int nomor;
  final String nama;

  SurahBookmark({
    required this.nomor,
    required this.nama,
  });

  factory SurahBookmark.fromJson(Map<String, dynamic> json) {
    return SurahBookmark(
      nomor: json['nomor'],
      nama: json['nama'],
    );
  }

  Map<String, dynamic> toJson() => {
        'nomor': nomor,
        'nama': nama,
      };
}
