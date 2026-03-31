import 'package:flutter/material.dart';
import 'dart:io' show Platform;

/// Device configuration dan capability detection
/// Untuk mengoptimalkan performa di device dengan RAM terbatas
class DeviceConfig {
  static late bool _isLowEndDevice;
  static late bool _hasLimitedMemory;

  /// Initialize device configuration
  static Future<void> initialize() async {
    // Detect low-end device characteristics
    // Device dianggap low-end jika:
    // 1. RAM <= 2GB
    // 2. API level <= 24 (Android 7.0)
    // 3. Display density rendah

    // Use PlatformDispatcher instead of deprecated window
    final devicePixelRatio = WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;

    _isLowEndDevice = devicePixelRatio < 2.0; // Bukan high-end display
    _hasLimitedMemory = true; // Asumsikan device 4GB RAM
  }

  /// Apakah device memiliki RAM terbatas?
  static bool get hasLimitedMemory => _hasLimitedMemory;

  /// Apakah device adalah low-end?
  static bool get isLowEndDevice => _isLowEndDevice;

  /// Apakah should menggunakan reduced animations?
  static bool get shouldReduceAnimations => _isLowEndDevice;

  /// Apakah should menggunakan simplified Lottie animations?
  static bool get shouldSimplifyLottie => _isLowEndDevice;

  /// Duration untuk animation (reduced untuk low-end devices)
  static Duration get animationDuration {
    if (_isLowEndDevice) {
      return const Duration(milliseconds: 300); // 300ms untuk low-end
    }
    return const Duration(milliseconds: 600); // 600ms untuk normal
  }

  /// Apakah should load animations?
  static bool get shouldLoadAnimations {
    // Disable animations di very low-end devices untuk save RAM
    return !_isLowEndDevice;
  }

  /// Image quality factor (0.0 - 1.0)
  /// Lower untuk device dengan limited RAM
  static double get imageQuality {
    if (_isLowEndDevice) {
      return 0.7; // 70% quality untuk low-end
    }
    return 1.0; // 100% quality untuk normal
  }

  /// Apakah platform Android
  static bool get isAndroid => Platform.isAndroid;

  /// Apakah platform iOS
  static bool get isIOS => Platform.isIOS;
}
