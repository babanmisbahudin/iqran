import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AnimatedCharacterCard extends StatefulWidget {
  final String lottieAsset;
  final String? fallbackImage;
  final String? heroTag;

  const AnimatedCharacterCard({
    Key? key,
    required this.lottieAsset,
    this.fallbackImage,
    this.heroTag,
  }) : super(key: key);

  @override
  State<AnimatedCharacterCard> createState() => _AnimatedCharacterCardState();
}

class _AnimatedCharacterCardState extends State<AnimatedCharacterCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;
  bool _lottieLoadFailed = false;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      height: 300,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            cs.primary.withValues(alpha: 0.15),
            cs.primary.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: cs.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (_lottieLoadFailed && widget.fallbackImage != null) {
      return _buildFallbackImage();
    }

    return _buildLottieAnimation();
  }

  Widget _buildLottieAnimation() {
    return Lottie.asset(
      widget.lottieAsset,
      fit: BoxFit.contain,
      onLoaded: (composition) {
        // Animation loaded successfully
      },
      errorBuilder: (context, error, stackTrace) {
        // If Lottie fails and we have fallback, show it
        if (widget.fallbackImage != null) {
          Future.microtask(() {
            if (mounted) {
              setState(() => _lottieLoadFailed = true);
            }
          });
        }
        return _buildShimmer(context);
      },
    );
  }

  Widget _buildFallbackImage() {
    return Image.asset(
      widget.fallbackImage!,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return _buildShimmer(context);
      },
    );
  }

  Widget _buildShimmer(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Center(
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.95, end: 1.05).animate(
          CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
        ),
        child: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: cs.primary.withValues(alpha: 0.2),
          ),
          child: Center(
            child: Icon(
              Icons.person,
              size: 60,
              color: cs.primary.withValues(alpha: 0.5),
            ),
          ),
        ),
      ),
    );
  }
}
