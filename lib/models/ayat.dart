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

  factory Ayat.fromJson(Map<String, dynamic> j) => Ayat(
        nomor: j['nomorAyat'],
        arab: j['teksArab'],
        latin: j['teksLatin'],
        indo: j['teksIndonesia'],
      );
}
