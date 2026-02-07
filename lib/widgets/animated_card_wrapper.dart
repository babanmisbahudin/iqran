import 'package:flutter/material.dart';

/// Reusable animated card wrapper dengan entrance animation dan interactive effects
class AnimatedCardWrapper extends StatefulWidget {
  final Widget child;
  final Duration entranceDelay;
  final Duration enteranceDuration;
  final VoidCallback? onTap;
  final bool enableScaleOnTap;
  final Curve curve;

  const AnimatedCardWrapper({
    super.key,
    required this.child,
    this.entranceDelay = const Duration(milliseconds: 0),
    this.enteranceDuration = const Duration(milliseconds: 600),
    this.onTap,
    this.enableScaleOnTap = true,
    this.curve = Curves.easeOutCubic,
  });

  @override
  State<AnimatedCardWrapper> createState() => _AnimatedCardWrapperState();
}

class _AnimatedCardWrapperState extends State<AnimatedCardWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _entranceController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      duration: widget.enteranceDuration,
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _entranceController, curve: widget.curve),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _entranceController, curve: widget.curve),
    );

    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _entranceController, curve: widget.curve),
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
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: GestureDetector(
            onTapDown: widget.enableScaleOnTap
                ? (_) => setState(() => _isPressed = true)
                : null,
            onTapUp: widget.enableScaleOnTap
                ? (_) {
                    setState(() => _isPressed = false);
                    widget.onTap?.call();
                  }
                : null,
            onTapCancel: widget.enableScaleOnTap
                ? () => setState(() => _isPressed = false)
                : null,
            onTap: !widget.enableScaleOnTap ? widget.onTap : null,
            child: AnimatedScale(
              scale: _isPressed ? 0.95 : 1.0,
              duration: const Duration(milliseconds: 100),
              child: AnimatedOpacity(
                opacity: _isPressed ? 0.8 : 1.0,
                duration: const Duration(milliseconds: 100),
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
