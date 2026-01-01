import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class QuranDB {
  static Database? _db;

  static Future<Database> get instance async {
    if (_db != null) return _db!;
    _db = await _init();
    return _db!;
  }

  static Future<Database> _init() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'quran.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, _) async {
        await db.execute('''
          CREATE TABLE surah (
            nomor INTEGER PRIMARY KEY,
            nama TEXT,
            nama_latin TEXT,
            jumlah_ayat INTEGER
          )
        ''');

        await db.execute('''
          CREATE TABLE ayat (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            surah INTEGER,
            nomor INTEGER,
            arab TEXT,
            latin TEXT,
            indo TEXT
          )
        ''');
      },
    );
  }
}
