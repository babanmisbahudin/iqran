import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/surah_bookmark.dart';

class SurahBookmarkService {
  static const _key = 'surah_bookmarks';

  static Future<List<SurahBookmark>> getAll() async {
    final p = await SharedPreferences.getInstance();
    final raw = p.getStringList(_key) ?? [];
    return raw.map((e) => SurahBookmark.fromJson(jsonDecode(e))).toList();
  }

  static Future<bool> isBookmarked(int nomor) async {
    final list = await getAll();
    return list.any((e) => e.nomor == nomor);
  }

  static Future<void> add(int nomor, String nama) async {
    final p = await SharedPreferences.getInstance();
    final list = await getAll();

    if (list.any((e) => e.nomor == nomor)) return;

    list.add(SurahBookmark(nomor: nomor, nama: nama));
    await p.setStringList(
      _key,
      list.map((e) => jsonEncode(e.toJson())).toList(),
    );
  }

  static Future<void> remove(int nomor) async {
    final p = await SharedPreferences.getInstance();
    final list = await getAll();

    list.removeWhere((e) => e.nomor == nomor);
    await p.setStringList(
      _key,
      list.map((e) => jsonEncode(e.toJson())).toList(),
    );
  }
}
