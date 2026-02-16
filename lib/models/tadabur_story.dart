/// Tadabur Story Model - Cerita dari Ayat Al-Quran
class TadabourStory {
  final int id;
  final String judul;
  final int surah;
  final String ayat; // Contoh: "1:1-7" atau "2:255"
  final String deskripsi;
  final String cerita;
  final String pelajaran;
  final DateTime? createdAt;

  TadabourStory({
    required this.id,
    required this.judul,
    required this.surah,
    required this.ayat,
    required this.deskripsi,
    required this.cerita,
    required this.pelajaran,
    this.createdAt,
  });

  // Convert to Map for JSON serialization
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'judul': judul,
      'surah': surah,
      'ayat': ayat,
      'deskripsi': deskripsi,
      'cerita': cerita,
      'pelajaran': pelajaran,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  // Create from Map (for JSON deserialization)
  factory TadabourStory.fromMap(Map<String, dynamic> map) {
    return TadabourStory(
      id: map['id'] as int,
      judul: map['judul'] as String,
      surah: map['surah'] as int,
      ayat: map['ayat'] as String,
      deskripsi: map['deskripsi'] as String,
      cerita: map['cerita'] as String,
      pelajaran: map['pelajaran'] as String,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : null,
    );
  }
}
