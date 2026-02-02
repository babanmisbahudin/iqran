class PrayerTime {
  final String date;      // "2026-02-02"
  final String fajr;      // "04:35"
  final String sunrise;   // "05:52"
  final String dhuhr;     // "12:15"
  final String asr;       // "15:30"
  final String maghrib;   // "18:25"
  final String isha;      // "19:35"

  PrayerTime({
    required this.date,
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
  });

  factory PrayerTime.fromJson(Map<String, dynamic> json) {
    return PrayerTime(
      date: json['tanggal'] ?? json['date'] ?? '',
      fajr: json['subuh'] ?? json['fajr'] ?? '',
      sunrise: json['terbit'] ?? json['sunrise'] ?? '',
      dhuhr: json['dzuhur'] ?? json['dhuhr'] ?? '',
      asr: json['ashr'] ?? json['asr'] ?? '',
      maghrib: json['maghrib'] ?? '',
      isha: json['isya'] ?? json['isha'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tanggal': date,
      'subuh': fajr,
      'terbit': sunrise,
      'dzuhur': dhuhr,
      'ashr': asr,
      'maghrib': maghrib,
      'isya': isha,
    };
  }

  @override
  String toString() => 'PrayerTime($date: Subuh=$fajr, Terbit=$sunrise, '
      'Dzuhur=$dhuhr, Ashar=$asr, Maghrib=$maghrib, Isya=$isha)';
}
