import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';

import '../models/surah.dart';
import '../models/ayat.dart';
import 'quran_db.dart';

class QuranService {
  static const _baseUrl = 'https://equran.id/api/v2';

  // =========================
  // FETCH SURAH LOCAL (INSTANT)
  // =========================
  static Future<List<Surah>> fetchSurahLocal() async {
    final db = await QuranDB.instance;

    // Web tidak support database, return empty
    if (db == null) {
      return [];
    }

    final rows = await db.query('surah');
    return rows.map((e) => Surah.fromMap(e)).toList();
  }

  // =========================
  // FETCH SURAH (ONLINE + CACHE)
  // =========================
  static Future<List<Surah>> fetchSurah() async {
    final db = await QuranDB.instance;
    final conn = await Connectivity().checkConnectivity();

    // Web: selalu gunakan API
    if (db == null) {
      final res = await http.get(Uri.parse('$_baseUrl/surat'));
      final List data = jsonDecode(res.body)['data'];
      return data.map((e) => Surah.fromJson(e)).toList();
    }

    if (conn.contains(ConnectivityResult.none)) {
      return fetchSurahLocal();
    }

    final res = await http.get(Uri.parse('$_baseUrl/surat'));
    final List data = jsonDecode(res.body)['data'];

    await db.delete('surah');
    for (final s in data) {
      await db.insert('surah', {
        'nomor': s['nomor'],
        'nama': s['nama'],
        'nama_latin': s['namaLatin'],
        'jumlah_ayat': s['jumlahAyat'],
      });
    }

    return data.map((e) => Surah.fromJson(e)).toList();
  }

  // =========================
  // FETCH AYAT (ONLINE + CACHE)
  // =========================
  static Future<List<Ayat>> fetchAyat(int surah) async {
    final db = await QuranDB.instance;
    final conn = await Connectivity().checkConnectivity();

    // Web: selalu gunakan API
    if (db == null) {
      final res = await http.get(Uri.parse('$_baseUrl/surat/$surah'));
      final List data = jsonDecode(res.body)['data']['ayat'];
      return data.map((e) => Ayat.fromJson(e)).toList();
    }

    if (conn.contains(ConnectivityResult.none)) {
      final rows = await db.query(
        'ayat',
        where: 'surah = ?',
        whereArgs: [surah],
      );
      return rows.map((e) => Ayat.fromMap(e)).toList();
    }

    final res = await http.get(Uri.parse('$_baseUrl/surat/$surah'));
    final List data = jsonDecode(res.body)['data']['ayat'];

    await db.delete('ayat', where: 'surah = ?', whereArgs: [surah]);
    for (final a in data) {
      await db.insert('ayat', {
        'surah': surah,
        'nomor': a['nomorAyat'],
        'arab': a['teksArab'],
        'latin': a['teksLatin'],
        'indo': a['teksIndonesia'],
      });
    }

    return data.map((e) => Ayat.fromJson(e)).toList();
  }
}
