import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class FeatureCard extends StatefulWidget {
  final IconData? icon;
  final String? lottieAsset;
  final String title;
  final String description;
  final Color gradientColor;
  final VoidCallback onTap;
  final int? animationIndex;
  final Duration entranceDelay;

  const FeatureCard({
    super.key,
    this.icon,
    this.lottieAsset,
    required this.title,
    required this.description,
    required this.gradientColor,
    required this.onTap,
    this.animationIndex = 0,
    this.entranceDelay = const Duration(milliseconds: 0),
  }) : assert(icon != null || lottieAsset != null, 'Either icon or lottieAsset must be provided');

  @override
  State<FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<FeatureCard>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  late AnimationController _entranceController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _entranceController, curve: Curves.easeOutCubic),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _entranceController, curve: Curves.easeOutCubic),
    );

    Future.delayed(widget.entranceDelay, () {
      if (mounted) {
        _entranceController.forward();
      }
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: GestureDetector(
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) {
            setState(() => _isPressed = false);
            widget.onTap();
          },
          onTapCancel: () => setState(() => _isPressed = false),
          child: AnimatedScale(
            scale: _isPressed ? 0.95 : 1.0,
            duration: const Duration(milliseconds: 150),
            child: AnimatedOpacity(
              opacity: _isPressed ? 0.7 : 1.0,
              duration: const Duration(milliseconds: 150),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: LinearGradient(
                    colors: [
                      widget.gradientColor.withValues(alpha: 0.15),
                      widget.gradientColor.withValues(alpha: 0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(
                    color: widget.gradientColor.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.gradientColor.withValues(alpha: 0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: widget.gradientColor.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.all(14),
                        child: _buildIconWidget(),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        widget.title,
                        style:
                            Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: cs.onSurface,
                                  fontSize: 15,
                                ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.description,
                        style:
                            Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: cs.onSurfaceVariant,
                                  fontSize: 12,
                                ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconWidget() {
    if (widget.lottieAsset != null) {
      return SizedBox(
        width: 56,
        height: 56,
        child: Lottie.asset(
          widget.lottieAsset!,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              widget.icon ?? Icons.star,
              color: widget.gradientColor,
              size: 28,
            );
          },
        ),
      );
    }
    return Icon(
      widget.icon ?? Icons.star,
      color: widget.gradientColor,
      size: 28,
    );
  }
}
