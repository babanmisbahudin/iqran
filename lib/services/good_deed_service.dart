import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/good_deed.dart';

class GoodDeedService {
  static const String _dedsKey = 'good_deeds_list';
  static const String _totalExpKey = 'total_exp';
  static const String _levelKey = 'good_deed_level';

  // Default good deeds dengan EXP values
  static final defaultDeeds = {
    'puasa': {'title': 'Puasa', 'exp': 50},
    'infaq': {'title': 'Infaq', 'exp': 30},
    'tilawah': {'title': 'Tilawah', 'exp': 20},
    'dzikir': {'title': 'Dzikir', 'exp': 15},
    'sedekah': {'title': 'Sedekah', 'exp': 35},
    'berbuat_baik': {'title': 'Berbuat Baik', 'exp': 25},
  };

  // ========================
  // ADD GOOD DEED
  // ========================
  static Future<void> addGoodDeed(GoodDeed deed) async {
    final prefs = await SharedPreferences.getInstance();
    final deeds = await getAllDeeds();

    deeds.add(deed);
    await prefs.setString(
      _dedsKey,
      jsonEncode(deeds.map((d) => d.toJson()).toList()),
    );

    // Update total EXP if completed
    if (deed.isCompleted) {
      await _addExp(deed.expPoints);
    }
  }

  // ========================
  // UPDATE GOOD DEED
  // ========================
  static Future<void> updateGoodDeed(GoodDeed deed) async {
    final prefs = await SharedPreferences.getInstance();
    final deeds = await getAllDeeds();

    final index = deeds.indexWhere((d) => d.id == deed.id);
    if (index != -1) {
      final oldDeed = deeds[index];
      deeds[index] = deed;

      await prefs.setString(
        _dedsKey,
        jsonEncode(deeds.map((d) => d.toJson()).toList()),
      );

      // Update EXP if completion status changed
      if (!oldDeed.isCompleted && deed.isCompleted) {
        await _addExp(deed.expPoints);
      } else if (oldDeed.isCompleted && !deed.isCompleted) {
        await _subtractExp(deed.expPoints);
      }
    }
  }

  // ========================
  // DELETE GOOD DEED
  // ========================
  static Future<void> deleteGoodDeed(String deedId) async {
    final prefs = await SharedPreferences.getInstance();
    final deeds = await getAllDeeds();

    final deed = deeds.firstWhere(
      (d) => d.id == deedId,
      orElse: () => GoodDeed(
        id: '',
        title: '',
        category: '',
        expPoints: 0,
        date: DateTime.now(),
        isCompleted: false,
        isCustom: false,
      ),
    );

    deeds.removeWhere((d) => d.id == deedId);
    await prefs.setString(
      _dedsKey,
      jsonEncode(deeds.map((d) => d.toJson()).toList()),
    );

    // Remove EXP if deed was completed
    if (deed.id.isNotEmpty && deed.isCompleted) {
      await _subtractExp(deed.expPoints);
    }
  }

  // ========================
  // GET ALL DEEDS
  // ========================
  static Future<List<GoodDeed>> getAllDeeds() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_dedsKey);

    if (data == null || data.isEmpty) {
      return [];
    }

    try {
      final list = jsonDecode(data) as List;
      return list.map((item) => GoodDeed.fromJson(item)).toList();
    } catch (e) {
      return [];
    }
  }

  // ========================
  // GET DEEDS BY DATE
  // ========================
  static Future<List<GoodDeed>> getDeedsByDate(DateTime date) async {
    final deeds = await getAllDeeds();
    final dateStr = date.toIso8601String().split('T')[0];

    return deeds
        .where((deed) => deed.date.toIso8601String().split('T')[0] == dateStr)
        .toList();
  }

  // ========================
  // GET TODAY'S DEEDS
  // ========================
  static Future<List<GoodDeed>> getTodayDeeds() async {
    return getDeedsByDate(DateTime.now());
  }

  // ========================
  // GET DEEDS BY CATEGORY
  // ========================
  static Future<List<GoodDeed>> getDeedsByCategory(String category) async {
    final deeds = await getAllDeeds();
    return deeds.where((deed) => deed.category == category).toList();
  }

  // ========================
  // GET TOTAL EXP
  // ========================
  static Future<int> getTotalExp() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_totalExpKey) ?? 0;
  }

  // ========================
  // GET LEVEL & EXP PROGRESS
  // ========================
  static Future<Map<String, dynamic>> getLevelInfo() async {
    final totalExp = await getTotalExp();
    final level = (totalExp / 500).floor() + 1; // Level every 500 EXP
    final expForCurrentLevel = totalExp % 500;
    const expForNextLevel = 500;
    final levelProgress = expForCurrentLevel / expForNextLevel;

    return {
      'level': level,
      'totalExp': totalExp,
      'expForCurrentLevel': expForCurrentLevel,
      'expForNextLevel': expForNextLevel,
      'levelProgress': levelProgress,
    };
  }

  // ========================
  // GET COMPLETED DEEDS COUNT
  // ========================
  static Future<int> getCompletedCount() async {
    final deeds = await getAllDeeds();
    return deeds.where((deed) => deed.isCompleted).length;
  }

  // ========================
  // GET COMPLETED DEEDS TODAY
  // ========================
  static Future<int> getCompletedTodayCount() async {
    final deeds = await getTodayDeeds();
    return deeds.where((deed) => deed.isCompleted).length;
  }

  // ========================
  // GET EXP EARNED TODAY
  // ========================
  static Future<int> getExpEarnedToday() async {
    final deeds = await getTodayDeeds();
    int totalExp = 0;
    for (final deed in deeds) {
      if (deed.isCompleted) {
        totalExp += deed.expPoints;
      }
    }
    return totalExp;
  }

  // ========================
  // PRIVATE HELPER METHODS
  // ========================
  static Future<void> _addExp(int exp) async {
    final prefs = await SharedPreferences.getInstance();
    final currentExp = await getTotalExp();
    await prefs.setInt(_totalExpKey, currentExp + exp);
  }

  static Future<void> _subtractExp(int exp) async {
    final prefs = await SharedPreferences.getInstance();
    final currentExp = await getTotalExp();
    await prefs.setInt(_totalExpKey, (currentExp - exp).clamp(0, 999999));
  }

  // ========================
  // RESET ALL
  // ========================
  static Future<void> resetAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_dedsKey);
    await prefs.remove(_totalExpKey);
    await prefs.remove(_levelKey);
  }
}
