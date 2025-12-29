import 'package:shared_preferences/shared_preferences.dart';

class AudioService {
  static const _keyQari = 'selected_qari';

  /// 🔑 key = internal, value = label
  static const Map<String, String> qariList = {
    'juhany': 'Abdullah Al-Juhany',
    'sudais': 'Abdurrahman As-Sudais',
    'afasy': 'Misyari Rasyid Al-Afasy',
    'yasser': 'Yasser Al-Dosari',
  };

  /// 🔗 folder CDN (WAJIB cocok dengan equran)
  static const Map<String, String> qariFolder = {
    'juhany': 'Abdullah-Al-Juhany',
    'sudais': 'Abdurrahman-as-Sudais',
    'afasy': 'Misyari-Rasyid-Al-Afasy',
    'yasser': 'Yasser-Al-Dosari',
  };

  static Future<void> saveQari(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyQari, key);
  }

  static Future<String> loadQari() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_keyQari);

    // ⛑️ proteksi value lama
    if (saved == null || !qariList.containsKey(saved)) {
      final def = qariList.keys.first;
      await prefs.setString(_keyQari, def);
      return def;
    }

    return saved;
  }

  /// ✅ INI YANG SEBELUMNYA HILANG
  static Future<String> getAudioUrl(int surahNumber) async {
    final qari = await loadQari();
    final folder = qariFolder[qari]!;

    final surah = surahNumber.toString().padLeft(3, '0');

    return 'https://cdn.equran.id/audio-full/$folder/$surah.mp3';
  }
}
