import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/prayer_time.dart';
import '../models/city.dart';

class PrayerService {
  static const String _baseUrl =
      'https://cdn.statically.io/gh/lakuapik/jadwalsholatorg/master';

  // ========================
  // FETCH CITIES
  // ========================
  static Future<List<City>> fetchCities() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/kota.json'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((city) => City.fromJson(city)).toList();
      } else {
        throw Exception('Failed to fetch cities: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching cities: $e');
    }
  }

  // ========================
  // FETCH PRAYER TIMES
  // ========================
  static Future<List<PrayerTime>> fetchPrayerTimes({
    required String cityId,
    required int year,
    required int month,
  }) async {
    try {
      final monthStr = month.toString().padLeft(2, '0');
      final url = '$_baseUrl/adzan/$cityId/$year/$monthStr.json';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Handle berbagai struktur response dari API
        List<dynamic> prayerList = [];

        if (data is List) {
          prayerList = data;
        } else if (data is Map && data.containsKey('data')) {
          prayerList = data['data'];
        } else if (data is Map) {
          // Jika response adalah map dengan keys berupa tanggal
          prayerList = data.values.toList();
        }

        return prayerList
            .map((item) {
              try {
                return PrayerTime.fromJson(item);
              } catch (e) {
                return null;
              }
            })
            .whereType<PrayerTime>()
            .toList();
      } else {
        throw Exception(
            'Failed to fetch prayer times: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching prayer times: $e');
    }
  }

  // ========================
  // GET TODAY'S PRAYER TIMES
  // ========================
  static Future<PrayerTime?> getTodayPrayerTimes({
    required String cityId,
  }) async {
    try {
      final now = DateTime.now();
      final times = await fetchPrayerTimes(
        cityId: cityId,
        year: now.year,
        month: now.month,
      );

      if (times.isEmpty) return null;

      // Find today's prayer time
      final todayStr = now.day.toString();
      final today = times.firstWhere(
        (time) => time.date.contains(todayStr),
        orElse: () => times.first,
      );

      return today;
    } catch (e) {
      throw Exception('Error getting today prayer times: $e');
    }
  }

  // ========================
  // PARSE TIME STRING
  // ========================
  static DateTime parseTime(String timeStr) {
    try {
      final parts = timeStr.split(':');
      if (parts.length != 2) throw Exception('Invalid time format');

      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);

      final now = DateTime.now();
      return DateTime(now.year, now.month, now.day, hour, minute);
    } catch (e) {
      throw Exception('Error parsing time: $e');
    }
  }

  // ========================
  // GET NEXT PRAYER
  // ========================
  static Map<String, dynamic> getNextPrayer(PrayerTime prayerTime) {
    final now = DateTime.now();

    final prayers = [
      {'name': 'Subuh', 'time': parseTime(prayerTime.fajr)},
      {'name': 'Terbit', 'time': parseTime(prayerTime.sunrise)},
      {'name': 'Dzuhur', 'time': parseTime(prayerTime.dhuhr)},
      {'name': 'Ashar', 'time': parseTime(prayerTime.asr)},
      {'name': 'Maghrib', 'time': parseTime(prayerTime.maghrib)},
      {'name': 'Isya', 'time': parseTime(prayerTime.isha)},
    ];

    for (final prayer in prayers) {
      final prayerTime = prayer['time'] as DateTime;
      if (now.isBefore(prayerTime)) {
        final duration = prayerTime.difference(now);
        return {
          'name': prayer['name'],
          'time': prayerTime,
          'duration': duration,
          'hours': duration.inHours,
          'minutes': duration.inMinutes % 60,
          'seconds': duration.inSeconds % 60,
        };
      }
    }

    // If all prayers have passed, next prayer is Subuh tomorrow
    final tomorrowSubuh = parseTime(prayerTime.fajr).add(const Duration(days: 1));
    final duration = tomorrowSubuh.difference(now);

    return {
      'name': 'Subuh (Besok)',
      'time': tomorrowSubuh,
      'duration': duration,
      'hours': duration.inHours,
      'minutes': duration.inMinutes % 60,
      'seconds': duration.inSeconds % 60,
    };
  }
}
