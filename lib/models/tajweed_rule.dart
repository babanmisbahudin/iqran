import 'package:flutter/material.dart';

/// Model untuk tajweed rule (hukum tajweed)
class TajweedRule {
  /// Unique identifier
  final String id;

  /// Nama hukum (Inggris)
  final String name;

  /// Nama hukum (Arabic)
  final String arabicName;

  /// Warna untuk highlight
  final Color color;

  /// Deskripsi singkat
  final String description;

  /// Deskripsi lengkap dengan penjelasan detail
  final String fullDescription;

  /// Contoh-contoh penerapan
  final List<String> examples;

  /// Pattern untuk detect (bisa regex atau simple text)
  final List<String> patterns;

  TajweedRule({
    required this.id,
    required this.name,
    required this.arabicName,
    required this.color,
    required this.description,
    required this.fullDescription,
    required this.examples,
    required this.patterns,
  });

  /// Default tajweed rules
  static List<TajweedRule> getDefaultRules() => [
        TajweedRule(
          id: 'qalqala',
          name: 'Qalqala',
          arabicName: 'القلقلة',
          color: const Color(0xFFE53935), // Red
          description: 'Trembling sound',
          fullDescription:
              'Qalqala adalah getaran suara pada huruf ق، ط، ب، ج، د ketika mempunyai sukun.',
          examples: ['ق (Qaf)', 'ط (Tha)', 'ب (Ba)', 'ج (Jeem)', 'د (Dal)'],
          patterns: ['ق', 'ط', 'ب', 'ج', 'د'],
        ),
        TajweedRule(
          id: 'ghunnah',
          name: 'Ghunnah',
          arabicName: 'الغنة',
          color: const Color(0xFF1E88E5), // Blue
          description: 'Nasal sound',
          fullDescription:
              'Ghunnah adalah suara dengung dari hidung pada huruf ن dan م ketika bertasydid atau sebelum ba.',
          examples: ['نّ (Nun tasydid)', 'مّ (Meem tasydid)', 'نب (Nun ba)'],
          patterns: ['نّ', 'مّ', 'نب', 'نج', 'نح', 'نخ'],
        ),
        TajweedRule(
          id: 'tashdeed',
          name: 'Tashdeed',
          arabicName: 'التشديد',
          color: const Color(0xFF8E24AA), // Purple
          description: 'Double letter',
          fullDescription:
              'Tashdeed (tasydid) menunjukkan penggandaan huruf dengan menekan/menguat bacaannya.',
          examples: ['مّ', 'نّ', 'رّ', 'لّ'],
          patterns: ['ّ'], // Shadda character
        ),
        TajweedRule(
          id: 'makhraj',
          name: 'Makhraj',
          arabicName: 'المخارج',
          color: const Color(0xFF43A047), // Green
          description: 'Articulation point',
          fullDescription:
              'Makhraj adalah tempat keluarnya huruf dalam mulut/tenggorokan saat membacanya.',
          examples: [
            'Throat letters: ء ه ع غ',
            'Throat letters: خ ح',
            'Tongue letters: ج ش ي'
          ],
          patterns: ['ء', 'ه', 'ع', 'غ', 'خ', 'ح', 'ج', 'ش', 'ي'],
        ),
        TajweedRule(
          id: 'madd',
          name: 'Madd',
          arabicName: 'المد',
          color: const Color(0xFFFB8C00), // Orange
          description: 'Lengthening vowel',
          fullDescription:
              'Madd adalah perpanjangan suara pada huruf alif, waw, atau ya dengan durasi tertentu.',
          examples: ['آ', 'ا', 'و', 'ي'],
          patterns: ['ا', 'و', 'ي'],
        ),
      ];

  @override
  String toString() => 'TajweedRule(id: $id, name: $name)';
}
