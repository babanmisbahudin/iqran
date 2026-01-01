class Ayat {
  final int nomor;
  final String arab;
  final String latin;
  final String indo;

  Ayat({
    required this.nomor,
    required this.arab,
    required this.latin,
    required this.indo,
  });

  factory Ayat.fromJson(Map<String, dynamic> json) {
    return Ayat(
      nomor: json['nomorAyat'],
      arab: json['teksArab'],
      latin: json['teksLatin'],
      indo: json['teksIndonesia'],
    );
  }

  factory Ayat.fromMap(Map<String, dynamic> map) {
    return Ayat(
      nomor: map['nomor'],
      arab: map['arab'],
      latin: map['latin'],
      indo: map['indo'],
    );
  }
}
