import 'dart:math';

import '../models/qibla_direction.dart';

class QiblaService {
  // ========================
  // CALCULATE QIBLA BEARING
  // ========================
  static double calculateQiblaBearing(
    double userLatitude,
    double userLongitude,
  ) {
    const kaabahLat = QiblaDirection.kaabahLatitude;
    const kaabahLon = QiblaDirection.kaabahLongitude;

    final dLon = (kaabahLon - userLongitude) * pi / 180;
    final lat1 = userLatitude * pi / 180;
    const lat2 = kaabahLat * pi / 180;

    final y = sin(dLon) * cos(lat2);
    final x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);

    var bearing = atan2(y, x) * 180 / pi;
    bearing = (bearing + 360) % 360;

    return bearing;
  }

  // ========================
  // CALCULATE DISTANCE TO KAABA
  // ========================
  static double calculateDistanceToKaaba(
    double userLatitude,
    double userLongitude,
  ) {
    const kaabahLat = QiblaDirection.kaabahLatitude;
    const kaabahLon = QiblaDirection.kaabahLongitude;
    const earthRadiusKm = 6371.0;

    final dLat = (kaabahLat - userLatitude) * pi / 180;
    final dLon = (kaabahLon - userLongitude) * pi / 180;

    final lat1 = userLatitude * pi / 180;
    const lat2 = kaabahLat * pi / 180;

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);

    final c = 2 * asin(sqrt(a));
    final distance = earthRadiusKm * c;

    return distance;
  }

  // ========================
  // GET QIBLA DIRECTION
  // ========================
  static QiblaDirection getQiblaDirection(
    double userLatitude,
    double userLongitude,
  ) {
    final bearing = calculateQiblaBearing(userLatitude, userLongitude);
    final distance = calculateDistanceToKaaba(userLatitude, userLongitude);

    return QiblaDirection(
      bearing: bearing,
      userLatitude: userLatitude,
      userLongitude: userLongitude,
      distanceToKaaba: distance,
    );
  }

  // ========================
  // ADJUST BEARING FOR MAGNETIC DECLINATION
  // ========================
  static double adjustBearingForMagneticDeclination(
    double bearing,
    double magneticDeclination,
  ) {
    var adjusted = bearing + magneticDeclination;
    adjusted = (adjusted + 360) % 360;
    return adjusted;
  }

  // ========================
  // NORMALIZE BEARING
  // ========================
  static double normalizeBearing(double bearing) {
    var normalized = bearing % 360;
    if (normalized < 0) {
      normalized += 360;
    }
    return normalized;
  }

  // ========================
  // GET DIRECTION NAME
  // ========================
  static String getDirectionName(double bearing) {
    bearing = normalizeBearing(bearing);

    if (bearing >= 337.5 || bearing < 22.5) return 'Utara';
    if (bearing >= 22.5 && bearing < 67.5) return 'Timur Laut';
    if (bearing >= 67.5 && bearing < 112.5) return 'Timur';
    if (bearing >= 112.5 && bearing < 157.5) return 'Tenggara';
    if (bearing >= 157.5 && bearing < 202.5) return 'Selatan';
    if (bearing >= 202.5 && bearing < 247.5) return 'Barat Daya';
    if (bearing >= 247.5 && bearing < 292.5) return 'Barat';
    return 'Barat Laut'; // 292.5 - 337.5
  }

  // ========================
  // GET BEARING FROM DEVICE HEADING
  // ========================
  static double getBearingFromHeading(
    double deviceHeading,
    double qiblaBearing,
  ) {
    var bearing = qiblaBearing - deviceHeading;
    bearing = normalizeBearing(bearing);
    return bearing;
  }

  // ========================
  // CHECK IF FACING QIBLA
  // ========================
  static bool isFacingQibla(
    double deviceHeading,
    double qiblaBearing, {
    double tolerance = 15.0,
  }) {
    var difference = (qiblaBearing - deviceHeading).abs();

    // Handle wrap-around (e.g., 350 - 10 = 340, but should be 20)
    if (difference > 180) {
      difference = 360 - difference;
    }

    return difference <= tolerance;
  }

  // ========================
  // GET ANGLE OFFSET FOR ARROW
  // ========================
  static double getArrowOffset(
    double deviceHeading,
    double qiblaBearing,
  ) {
    var offset = qiblaBearing - deviceHeading;
    offset = normalizeBearing(offset);
    return offset;
  }
}
