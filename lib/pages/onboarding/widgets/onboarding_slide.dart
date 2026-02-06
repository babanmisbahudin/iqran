import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class OnboardingSlide extends StatelessWidget {
  final String title;
  final String description;
  final String? lottieAsset;
  final String? imageAsset;
  final bool isLast;

  const OnboardingSlide({
    Key? key,
    required this.title,
    required this.description,
    this.lottieAsset,
    this.imageAsset,
    this.isLast = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Top spacing
          const SizedBox(height: 40),

          // Animation or image
          if (lottieAsset != null)
            Expanded(
              child: Lottie.asset(
                lottieAsset!,
                fit: BoxFit.contain,
              ),
            )
          else if (imageAsset != null)
            Expanded(
              child: Image.asset(
                imageAsset!,
                fit: BoxFit.contain,
              ),
            )
          else
            const Expanded(
              child: SizedBox.shrink(),
            ),

          const SizedBox(height: 40),

          // Title
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          // Description
          Text(
            description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  height: 1.6,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 60),
        ],
      ),
    );
  }
}
