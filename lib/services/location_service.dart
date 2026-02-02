import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  // ========================
  // REQUEST LOCATION PERMISSION
  // ========================
  static Future<bool> requestLocationPermission() async {
    try {
      final status = await Permission.location.request();

      return status.isGranted;
    } catch (e) {
      return false;
    }
  }

  // ========================
  // CHECK LOCATION PERMISSION
  // ========================
  static Future<bool> hasLocationPermission() async {
    try {
      final status = await Permission.location.status;
      return status.isGranted;
    } catch (e) {
      return false;
    }
  }

  // ========================
  // GET CURRENT POSITION
  // ========================
  static Future<Position?> getCurrentPosition() async {
    try {
      // Check if location service is enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return null;
      }

      // Check permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Permission denied forever
        return null;
      }

      // Get position
      final position = await Geolocator.getCurrentPosition();

      return position;
    } catch (e) {
      return null;
    }
  }

  // ========================
  // GET LAST KNOWN POSITION
  // ========================
  static Future<Position?> getLastKnownPosition() async {
    try {
      final position = await Geolocator.getLastKnownPosition();
      return position;
    } catch (e) {
      return null;
    }
  }

  // ========================
  // OPEN APP SETTINGS
  // ========================
  static Future<bool> openLocationSettings() async {
    try {
      return await Geolocator.openLocationSettings();
    } catch (e) {
      return false;
    }
  }

  // ========================
  // OPEN APP PERMISSION SETTINGS
  // ========================
  static Future<bool> openPermissionSettings() async {
    try {
      return await openAppSettings();
    } catch (e) {
      return false;
    }
  }

  // ========================
  // GET DISTANCE BETWEEN TWO LOCATIONS
  // ========================
  static double getDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
  }

  // ========================
  // GET BEARING BETWEEN TWO LOCATIONS
  // ========================
  static double getBearing(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    return Geolocator.bearingBetween(lat1, lon1, lat2, lon2);
  }
}
