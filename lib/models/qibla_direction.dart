class QiblaDirection {
  final double bearing;              // Arah dalam derajat (0-360)
  final double userLatitude;         // Latitude user
  final double userLongitude;        // Longitude user
  final double distanceToKaaba;      // Jarak ke Kaaba dalam km
  final DateTime timestamp;          // Waktu perhitungan

  static const double kaabahLatitude = 21.4225;
  static const double kaabahLongitude = 39.8262;

  QiblaDirection({
    required this.bearing,
    required this.userLatitude,
    required this.userLongitude,
    required this.distanceToKaaba,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  factory QiblaDirection.fromJson(Map<String, dynamic> json) {
    return QiblaDirection(
      bearing: (json['bearing'] ?? 0).toDouble(),
      userLatitude: (json['userLatitude'] ?? 0).toDouble(),
      userLongitude: (json['userLongitude'] ?? 0).toDouble(),
      distanceToKaaba: (json['distanceToKaaba'] ?? 0).toDouble(),
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bearing': bearing,
      'userLatitude': userLatitude,
      'userLongitude': userLongitude,
      'distanceToKaaba': distanceToKaaba,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  String get directionName {
    if (bearing >= 337.5 || bearing < 22.5) return 'Utara';
    if (bearing >= 22.5 && bearing < 67.5) return 'Timur Laut';
    if (bearing >= 67.5 && bearing < 112.5) return 'Timur';
    if (bearing >= 112.5 && bearing < 157.5) return 'Tenggara';
    if (bearing >= 157.5 && bearing < 202.5) return 'Selatan';
    if (bearing >= 202.5 && bearing < 247.5) return 'Barat Daya';
    if (bearing >= 247.5 && bearing < 292.5) return 'Barat';
    return 'Barat Laut';
  }

  String get formattedDistance {
    if (distanceToKaaba < 1) {
      return '${(distanceToKaaba * 1000).toStringAsFixed(0)} meter';
    }
    return '${distanceToKaaba.toStringAsFixed(1)} km';
  }

  @override
  String toString() => 'QiblaDirection($bearing°, $directionName)';
}
