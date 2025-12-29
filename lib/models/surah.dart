class Surah {
  final int nomor;
  final String nama;
  final String namaLatin;
  final int jumlahAyat;
  final String tempatTurun;

  Surah({
    required this.nomor,
    required this.nama,
    required this.namaLatin,
    required this.jumlahAyat,
    required this.tempatTurun,
  });

  factory Surah.fromJson(Map<String, dynamic> j) => Surah(
        nomor: j['nomor'],
        nama: j['nama'],
        namaLatin: j['namaLatin'],
        jumlahAyat: j['jumlahAyat'],
        tempatTurun: j['tempatTurun'],
      );
}
