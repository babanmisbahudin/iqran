import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/city.dart';

class CityStorageService {
  static const String _selectedCityKey = 'selected_city';

  // ========================
  // SAVE SELECTED CITY
  // ========================
  static Future<bool> saveSelectedCity(City city) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cityJson = jsonEncode(city.toJson());
      return await prefs.setString(_selectedCityKey, cityJson);
    } catch (e) {
      return false;
    }
  }

  // ========================
  // GET SELECTED CITY
  // ========================
  static Future<City?> getSelectedCity() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cityJson = prefs.getString(_selectedCityKey);

      if (cityJson == null) {
        return null;
      }

      final data = jsonDecode(cityJson);
      return City.fromJson(data);
    } catch (e) {
      return null;
    }
  }

  // ========================
  // CLEAR SELECTED CITY
  // ========================
  static Future<bool> clearSelectedCity() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_selectedCityKey);
    } catch (e) {
      return false;
    }
  }

  // ========================
  // CHECK IF CITY IS SELECTED
  // ========================
  static Future<bool> isAnyCitySelected() async {
    try {
      final city = await getSelectedCity();
      return city != null;
    } catch (e) {
      return false;
    }
  }

  // ========================
  // SAVE PRAYER TIMES CACHE
  // ========================
  static Future<bool> savePrayerTimesCache(
    String cityId,
    int year,
    int month,
    String data,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'prayer_times_${cityId}_${year}_$month';
      return await prefs.setString(key, data);
    } catch (e) {
      return false;
    }
  }

  // ========================
  // GET PRAYER TIMES CACHE
  // ========================
  static Future<String?> getPrayerTimesCache(
    String cityId,
    int year,
    int month,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'prayer_times_${cityId}_${year}_$month';
      return prefs.getString(key);
    } catch (e) {
      return null;
    }
  }

  // ========================
  // CLEAR PRAYER TIMES CACHE
  // ========================
  static Future<bool> clearPrayerTimesCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();

      for (final key in keys) {
        if (key.startsWith('prayer_times_')) {
          await prefs.remove(key);
        }
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  // ========================
  // SAVE FASTING TRACKER
  // ========================
  static Future<bool> saveFastingTracker(
    int year,
    Map<String, bool> trackerData,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'fasting_tracker_$year';
      final jsonData = jsonEncode(trackerData);
      return await prefs.setString(key, jsonData);
    } catch (e) {
      return false;
    }
  }

  // ========================
  // GET FASTING TRACKER
  // ========================
  static Future<Map<String, bool>> getFastingTracker(int year) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'fasting_tracker_$year';
      final jsonData = prefs.getString(key);

      if (jsonData == null) {
        return {};
      }

      final data = jsonDecode(jsonData) as Map<String, dynamic>;
      return data.map((k, v) => MapEntry(k, v as bool));
    } catch (e) {
      return {};
    }
  }

  // ========================
  // UPDATE FASTING STATUS
  // ========================
  static Future<bool> updateFastingStatus(
    int year,
    DateTime date,
    bool isDone,
  ) async {
    try {
      final tracker = await getFastingTracker(year);
      final dateString = date.toString().split(' ')[0]; // YYYY-MM-DD
      tracker[dateString] = isDone;

      return await saveFastingTracker(year, tracker);
    } catch (e) {
      return false;
    }
  }

  // ========================
  // GET FASTING STATUS FOR DATE
  // ========================
  static Future<bool?> getFastingStatusForDate(
    int year,
    DateTime date,
  ) async {
    try {
      final tracker = await getFastingTracker(year);
      final dateString = date.toString().split(' ')[0]; // YYYY-MM-DD
      return tracker[dateString];
    } catch (e) {
      return null;
    }
  }
}
