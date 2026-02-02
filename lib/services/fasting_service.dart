import '../models/fasting_schedule.dart';

class FastingService {
  // Jadwal puasa sunnah tahun 2026 (berbasis Hijri 1447-1448)
  // Data dari Kementerian Agama RI
  static final List<FastingSchedule> fastingSchedules2026 = [
    // JANUARI
    FastingSchedule(
      date: DateTime(2026, 1, 5),
      type: 'ayyamul-bidh',
      description: 'Ayyamul Bidh (3 hari)\n13, 14, 15 Rajab',
    ),
    FastingSchedule(
      date: DateTime(2026, 1, 5),
      type: 'ayyamul-bidh',
      description: '',
    ),
    FastingSchedule(
      date: DateTime(2026, 1, 6),
      type: 'ayyamul-bidh',
      description: '',
    ),
    // Senin-Kamis throughout January
    FastingSchedule(
      date: DateTime(2026, 1, 5),
      type: 'senin-kamis',
      description: 'Puasa Senin-Kamis',
    ),
    FastingSchedule(
      date: DateTime(2026, 1, 8),
      type: 'senin-kamis',
      description: 'Puasa Senin-Kamis',
    ),

    // FEBRUARI
    FastingSchedule(
      date: DateTime(2026, 2, 2),
      type: 'senin-kamis',
      description: 'Puasa Senin-Kamis',
    ),
    FastingSchedule(
      date: DateTime(2026, 2, 5),
      type: 'senin-kamis',
      description: 'Puasa Senin-Kamis',
    ),
    FastingSchedule(
      date: DateTime(2026, 2, 9),
      type: 'senin-kamis',
      description: 'Puasa Senin-Kamis',
    ),
    FastingSchedule(
      date: DateTime(2026, 2, 12),
      type: 'senin-kamis',
      description: 'Puasa Senin-Kamis',
    ),
    FastingSchedule(
      date: DateTime(2026, 2, 16),
      type: 'senin-kamis',
      description: 'Puasa Senin-Kamis',
    ),
    FastingSchedule(
      date: DateTime(2026, 2, 19),
      type: 'senin-kamis',
      description: 'Puasa Senin-Kamis',
    ),
    FastingSchedule(
      date: DateTime(2026, 2, 23),
      type: 'senin-kamis',
      description: 'Puasa Senin-Kamis',
    ),
    FastingSchedule(
      date: DateTime(2026, 2, 26),
      type: 'senin-kamis',
      description: 'Puasa Senin-Kamis',
    ),
    FastingSchedule(
      date: DateTime(2026, 2, 13),
      type: 'ayyamul-bidh',
      description: 'Ayyamul Bidh (3 hari)\n13, 14, 15 Syaban',
    ),
    FastingSchedule(
      date: DateTime(2026, 2, 14),
      type: 'ayyamul-bidh',
      description: '',
    ),
    FastingSchedule(
      date: DateTime(2026, 2, 15),
      type: 'ayyamul-bidh',
      description: '',
    ),

    // MARET
    FastingSchedule(
      date: DateTime(2026, 3, 2),
      type: 'senin-kamis',
      description: 'Puasa Senin-Kamis',
    ),
    FastingSchedule(
      date: DateTime(2026, 3, 5),
      type: 'senin-kamis',
      description: 'Puasa Senin-Kamis',
    ),
    FastingSchedule(
      date: DateTime(2026, 3, 9),
      type: 'senin-kamis',
      description: 'Puasa Senin-Kamis',
    ),
    FastingSchedule(
      date: DateTime(2026, 3, 12),
      type: 'senin-kamis',
      description: 'Puasa Senin-Kamis',
    ),
    FastingSchedule(
      date: DateTime(2026, 3, 16),
      type: 'senin-kamis',
      description: 'Puasa Senin-Kamis',
    ),
    FastingSchedule(
      date: DateTime(2026, 3, 19),
      type: 'senin-kamis',
      description: 'Puasa Senin-Kamis',
    ),
    FastingSchedule(
      date: DateTime(2026, 3, 23),
      type: 'senin-kamis',
      description: 'Puasa Senin-Kamis',
    ),
    FastingSchedule(
      date: DateTime(2026, 3, 26),
      type: 'senin-kamis',
      description: 'Puasa Senin-Kamis',
    ),
    FastingSchedule(
      date: DateTime(2026, 3, 30),
      type: 'senin-kamis',
      description: 'Puasa Senin-Kamis',
    ),

    // APRIL
    FastingSchedule(
      date: DateTime(2026, 4, 2),
      type: 'senin-kamis',
      description: 'Puasa Senin-Kamis',
    ),
    FastingSchedule(
      date: DateTime(2026, 4, 6),
      type: 'senin-kamis',
      description: 'Puasa Senin-Kamis',
    ),
    FastingSchedule(
      date: DateTime(2026, 4, 9),
      type: 'senin-kamis',
      description: 'Puasa Senin-Kamis',
    ),
    FastingSchedule(
      date: DateTime(2026, 4, 13),
      type: 'senin-kamis',
      description: 'Puasa Senin-Kamis',
    ),
    FastingSchedule(
      date: DateTime(2026, 4, 16),
      type: 'senin-kamis',
      description: 'Puasa Senin-Kamis',
    ),
    FastingSchedule(
      date: DateTime(2026, 4, 20),
      type: 'senin-kamis',
      description: 'Puasa Senin-Kamis',
    ),
    FastingSchedule(
      date: DateTime(2026, 4, 23),
      type: 'senin-kamis',
      description: 'Puasa Senin-Kamis',
    ),
    FastingSchedule(
      date: DateTime(2026, 4, 27),
      type: 'senin-kamis',
      description: 'Puasa Senin-Kamis',
    ),
    FastingSchedule(
      date: DateTime(2026, 4, 30),
      type: 'senin-kamis',
      description: 'Puasa Senin-Kamis',
    ),

    // Ramadan 2026: 23 Feb - 25 Mar (berbeda dengan gregorian)
    // Puasa Syawwal (6 hari setelah Eid)
    FastingSchedule(
      date: DateTime(2026, 3, 27),
      type: 'syawwal',
      description: 'Puasa Syawwal (6 hari)\nSetelah Eid Al-Fitr',
    ),
    FastingSchedule(
      date: DateTime(2026, 3, 28),
      type: 'syawwal',
      description: '',
    ),
    FastingSchedule(
      date: DateTime(2026, 3, 29),
      type: 'syawwal',
      description: '',
    ),
    FastingSchedule(
      date: DateTime(2026, 3, 30),
      type: 'syawwal',
      description: '',
    ),
    FastingSchedule(
      date: DateTime(2026, 3, 31),
      type: 'syawwal',
      description: '',
    ),
    FastingSchedule(
      date: DateTime(2026, 4, 1),
      type: 'syawwal',
      description: '',
    ),

    // MAY - Arafah & Eid
    FastingSchedule(
      date: DateTime(2026, 5, 22),
      type: 'arafah',
      description: 'Puasa Arafah\n(9 Dzulhijjah)',
    ),
    FastingSchedule(
      date: DateTime(2026, 5, 2),
      type: 'senin-kamis',
      description: 'Puasa Senin-Kamis',
    ),
    FastingSchedule(
      date: DateTime(2026, 5, 6),
      type: 'senin-kamis',
      description: 'Puasa Senin-Kamis',
    ),
    FastingSchedule(
      date: DateTime(2026, 5, 11),
      type: 'senin-kamis',
      description: 'Puasa Senin-Kamis',
    ),
    FastingSchedule(
      date: DateTime(2026, 5, 14),
      type: 'senin-kamis',
      description: 'Puasa Senin-Kamis',
    ),
    FastingSchedule(
      date: DateTime(2026, 5, 18),
      type: 'senin-kamis',
      description: 'Puasa Senin-Kamis',
    ),
    FastingSchedule(
      date: DateTime(2026, 5, 21),
      type: 'senin-kamis',
      description: 'Puasa Senin-Kamis',
    ),
    FastingSchedule(
      date: DateTime(2026, 5, 25),
      type: 'senin-kamis',
      description: 'Puasa Senin-Kamis',
    ),
    FastingSchedule(
      date: DateTime(2026, 5, 28),
      type: 'senin-kamis',
      description: 'Puasa Senin-Kamis',
    ),
  ];

  // ========================
  // GET FASTING SCHEDULE BY MONTH
  // ========================
  static List<FastingSchedule> getFastingByMonth(int year, int month) {
    return fastingSchedules2026
        .where((f) => f.date.year == year && f.date.month == month)
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  // ========================
  // GET FASTING SCHEDULE BY YEAR
  // ========================
  static List<FastingSchedule> getFastingByYear(int year) {
    return fastingSchedules2026
        .where((f) => f.date.year == year)
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  // ========================
  // GET TODAY'S FASTING (IF ANY)
  // ========================
  static List<FastingSchedule> getTodayFasting() {
    final now = DateTime.now();
    return fastingSchedules2026
        .where((f) =>
            f.date.year == now.year &&
            f.date.month == now.month &&
            f.date.day == now.day)
        .toList();
  }

  // ========================
  // GET UPCOMING FASTING
  // ========================
  static List<FastingSchedule> getUpcomingFasting({int days = 30}) {
    final now = DateTime.now();
    final endDate = now.add(Duration(days: days));

    return fastingSchedules2026
        .where((f) => f.date.isAfter(now) && f.date.isBefore(endDate))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  // ========================
  // GET FASTING TYPES
  // ========================
  static List<String> getFastingTypes() {
    return ['senin-kamis', 'ayyamul-bidh', 'syawwal', 'arafah'];
  }

  // ========================
  // GET FASTING BY TYPE
  // ========================
  static List<FastingSchedule> getFastingByType(String type) {
    return fastingSchedules2026.where((f) => f.type == type).toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }
}
