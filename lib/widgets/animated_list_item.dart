import 'package:flutter/material.dart';

/// Animated list item dengan entrance animation untuk list/grid items
class AnimatedListItem extends StatefulWidget {
  final Widget child;
  final int index;
  final Duration delayMultiplier;
  final Duration enteranceDuration;
  final VoidCallback? onTap;

  const AnimatedListItem({
    super.key,
    required this.child,
    required this.index,
    this.delayMultiplier = const Duration(milliseconds: 50),
    this.enteranceDuration = const Duration(milliseconds: 500),
    this.onTap,
  });

  @override
  State<AnimatedListItem> createState() => _AnimatedListItemState();
}

class _AnimatedListItemState extends State<AnimatedListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.enteranceDuration,
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(-0.3, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    final delay = widget.delayMultiplier * widget.index;
    Future.delayed(delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: GestureDetector(
          onTap: widget.onTap,
          child: widget.child,
        ),
      ),
    );
  }
}
