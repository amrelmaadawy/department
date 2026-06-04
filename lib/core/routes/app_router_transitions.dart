import 'package:flutter/material.dart';

class AppRouterTransitions {
  static Widget slideUpFromBottom(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const begin = Offset(0.0, 1.0); // Slide up from bottom
    const end = Offset.zero;
    const curve = Curves.easeOutCubic;

    var tween = Tween(
      begin: begin,
      end: end,
    ).chain(CurveTween(curve: curve));

    return SlideTransition(
      position: animation.drive(tween),
      child: child,
    );
  }

  static Widget slideFromRight(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const begin = Offset(1.0, 0.0); // Slide from right
    const end = Offset.zero;
    const curve = Curves.easeOutCubic;

    var tween = Tween(
      begin: begin,
      end: end,
    ).chain(CurveTween(curve: curve));

    return SlideTransition(
      position: animation.drive(tween),
      child: child,
    );
  }

  static Widget fadeTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(opacity: animation, child: child);
  }
}
