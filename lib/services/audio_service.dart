import 'package:shared_preferences/shared_preferences.dart';

class AudioService {
  static const _keyQari = 'selected_qari';

  static const Map<String, String> qariList = {
    'al_juhany': 'Abdullah Al-Juhany',
    'al_qasim': 'Abdul Muhsin Al-Qasim',
    'as_sudais': 'Abdurrahman As-Sudais',
    'al_dossari': 'Ibrahim Al-Dossari',
    'al_afasy': 'Misyari Rasyid Al-Afasy',
    'yasser': 'Yasser Al-Dosari',
  };

  static Future<void> saveQari(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyQari, key);
  }

  static Future<String> loadQari() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyQari) ?? 'al_afasy';
  }

  static String getQariName(String key) {
    return qariList[key] ?? 'Unknown';
  }
}
