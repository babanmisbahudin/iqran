import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/surah.dart';
import '../models/ayat.dart';

class QuranService {
  static const _base = 'https://equran.id/api/v2';

  static Future<List<Surah>> fetchSurah() async {
    final r = await http.get(Uri.parse('$_base/surat'));
    final d = jsonDecode(r.body)['data'] as List;
    return d.map((e) => Surah.fromJson(e)).toList();
  }

  static Future<List<Ayat>> fetchAyat(int nomor) async {
    final r = await http.get(Uri.parse('$_base/surat/$nomor'));
    final d = jsonDecode(r.body)['data']['ayat'] as List;
    return d.map((e) => Ayat.fromJson(e)).toList();
  }
}
