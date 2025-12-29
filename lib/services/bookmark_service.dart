import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/ayat_bookmark.dart';

class BookmarkService {
  static const _key = 'ayat_bookmarks';

  static Future<List<AyatBookmark>> getAll() async {
    final p = await SharedPreferences.getInstance();
    final raw = p.getStringList(_key) ?? [];
    return raw.map((e) => AyatBookmark.fromJson(jsonDecode(e))).toList();
  }

  static Future<bool> isBookmarked(int surah, int ayat) async {
    final list = await getAll();
    return list.any((e) => e.surah == surah && e.ayat == ayat);
  }

  static Future<void> add(AyatBookmark b) async {
    final p = await SharedPreferences.getInstance();
    final list = await getAll();
    if (list.any((e) => e.surah == b.surah && e.ayat == b.ayat)) return;
    list.add(b);
    await p.setStringList(
      _key,
      list.map((e) => jsonEncode(e.toJson())).toList(),
    );
  }

  static Future<void> remove(int surah, int ayat) async {
    final p = await SharedPreferences.getInstance();
    final list = await getAll();
    list.removeWhere((e) => e.surah == surah && e.ayat == ayat);
    await p.setStringList(
      _key,
      list.map((e) => jsonEncode(e.toJson())).toList(),
    );
  }
}
