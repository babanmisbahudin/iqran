class Surah {
  final int nomor;
  final String nama;
  final String namaLatin;
  final int jumlahAyat;

  Surah({
    required this.nomor,
    required this.nama,
    required this.namaLatin,
    required this.jumlahAyat,
  });

  factory Surah.fromJson(Map<String, dynamic> json) {
    return Surah(
      nomor: json['nomor'],
      nama: json['nama'],
      namaLatin: json['namaLatin'],
      jumlahAyat: json['jumlahAyat'],
    );
  }

  factory Surah.fromMap(Map<String, dynamic> map) {
    return Surah(
      nomor: map['nomor'],
      nama: map['nama'],
      namaLatin: map['nama_latin'],
      jumlahAyat: map['jumlah_ayat'],
    );
  }
}
