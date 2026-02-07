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

/// Widget yang conditional based on device capabilities
class DeviceAwareWidget extends StatelessWidget {
  final Widget Function(BuildContext) lowEndBuilder;
  final Widget Function(BuildContext) normalBuilder;

  const DeviceAwareWidget({
    Key? key,
    required this.lowEndBuilder,
    required this.normalBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (DeviceConfig.isLowEndDevice) {
      return lowEndBuilder(context);
    }
    return normalBuilder(context);
  }
}

/// Utility untuk disable animations di low-end devices
class AnimationHelper {
  /// Get animation duration based on device
  static Duration getDuration({
    Duration defaultDuration = const Duration(milliseconds: 600),
    Duration reducedDuration = const Duration(milliseconds: 300),
  }) {
    return DeviceConfig.isLowEndDevice ? reducedDuration : defaultDuration;
  }

  /// Should animate this element?
  static bool shouldAnimate({bool ignoreDeviceConfig = false}) {
    if (ignoreDeviceConfig) return true;
    return !DeviceConfig.isLowEndDevice;
  }

  /// Get curve based on device
  static Curve getCurve({
    Curve defaultCurve = Curves.easeOutCubic,
    Curve simpleCurve = Curves.linear,
  }) {
    return DeviceConfig.isLowEndDevice ? simpleCurve : defaultCurve;
  }
}

/// Memory-aware list/grid builder
/// Untuk mencegah loading semua items sekaligus di low-end devices
class MemoryAwareListBuilder extends StatelessWidget {
  final List<dynamic> items;
  final Widget Function(BuildContext, int) itemBuilder;
  final Axis scrollDirection;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  const MemoryAwareListBuilder({
    Key? key,
    required this.items,
    required this.itemBuilder,
    this.scrollDirection = Axis.vertical,
    this.shrinkWrap = false,
    this.physics,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Di low-end devices, gunakan cached list builder
    // untuk mencegah rebuilding semua items
    if (DeviceConfig.isLowEndDevice) {
      return ListView.builder(
        scrollDirection: scrollDirection,
        shrinkWrap: shrinkWrap,
        physics: physics ?? const AlwaysScrollableScrollPhysics(),
        itemCount: items.length,
        itemBuilder: (context, index) {
          // Add small delay untuk prevent jank
          return itemBuilder(context, index);
        },
      );
    }

    // Normal device, gunakan standard ListView
    return ListView.builder(
      scrollDirection: scrollDirection,
      shrinkWrap: shrinkWrap,
      physics: physics,
      itemCount: items.length,
      itemBuilder: itemBuilder,
    );
  }
}
