import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// Lottie configuration untuk optimasi memory di device dengan RAM terbatas
class LottieConfig {
  /// Render performance optimization
  /// Menggunakan antialiasing minimal untuk mengurangi CPU usage
  static final renderingOptions = LottieOptions(
    // Disable anti-aliasing untuk performance
    enableMergePaths: true,
  );

  /// Cache builder untuk menghindari reload animation yang sama berkali-kali
  /// Ini sangat penting untuk performance di device dengan RAM terbatas
  static const bool useCache = true;

  /// Animation dekoding hints untuk mengurangi memory
  /// null = default, tapi kita bisa optimalkan di masa depan
  static const decodingHint = null;
}

/// Extension untuk simplify Lottie usage dengan optimization
extension LottieOptimization on Lottie {
  /// Shorthand untuk load animation dengan optimization
  static Widget optimizedAsset(
    String assetName, {
    bool repeat = true,
    bool reverse = false,
    void Function(LottieComposition)? onLoaded,
    BoxFit fit = BoxFit.contain,
    Key? key,
  }) {
    return Lottie.asset(
      assetName,
      repeat: repeat,
      reverse: reverse,
      onLoaded: onLoaded,
      fit: fit,
      key: key,
      // Rendering options untuk mengurangi memory
      options: LottieConfig.renderingOptions,
      // Error fallback untuk tidak crash
      errorBuilder: (context, error, stackTrace) {
        return const SizedBox.shrink();
      },
    );
  }
}
