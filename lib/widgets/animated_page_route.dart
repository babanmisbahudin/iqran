import 'package:flutter/material.dart';

/// Custom page route dengan berbagai animasi transition
class AnimatedPageRoute extends PageRouteBuilder {
  final Widget page;
  final AnimationType animationType;

  AnimatedPageRoute({
    required this.page,
    this.animationType = AnimationType.slideFromRight,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            switch (animationType) {
              case AnimationType.slideFromRight:
                return _slideFromRight(animation, secondaryAnimation, child);
              case AnimationType.slideFromLeft:
                return _slideFromLeft(animation, secondaryAnimation, child);
              case AnimationType.fadeAndScale:
                return _fadeAndScale(animation, secondaryAnimation, child);
              case AnimationType.slideAndFade:
                return _slideAndFade(animation, secondaryAnimation, child);
            }
          },
          transitionDuration: const Duration(milliseconds: 400),
        );

  static Widget _slideFromRight(
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const begin = Offset(1.0, 0.0);
    const end = Offset.zero;
    const curve = Curves.easeInOutCubic;

    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
    var offsetAnimation = animation.drive(tween);

    const secondaryBegin = Offset(-0.3, 0.0);

    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset.zero,
        end: secondaryBegin,
      ).animate(secondaryAnimation),
      child: SlideTransition(
        position: offsetAnimation,
        child: FadeTransition(
          opacity: animation,
          child: child,
        ),
      ),
    );
  }

  static Widget _slideFromLeft(
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const begin = Offset(-1.0, 0.0);
    const end = Offset.zero;
    const curve = Curves.easeInOutCubic;

    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
    var offsetAnimation = animation.drive(tween);

    return SlideTransition(
      position: offsetAnimation,
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }

  static Widget _fadeAndScale(
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.8, end: 1.0).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
        ),
        child: child,
      ),
    );
  }

  static Widget _slideAndFade(
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const begin = Offset(0.0, 0.3);
    const end = Offset.zero;
    const curve = Curves.easeOutCubic;

    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
    var offsetAnimation = animation.drive(tween);

    return SlideTransition(
      position: offsetAnimation,
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }
}

enum AnimationType {
  slideFromRight,
  slideFromLeft,
  fadeAndScale,
  slideAndFade,
}
