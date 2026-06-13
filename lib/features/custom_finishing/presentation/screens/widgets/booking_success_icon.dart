import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:apartment/core/theme/theme_extension.dart';

class BookingSuccessIcon extends StatelessWidget {
  final Animation<double> scaleAnimation;
  final Animation<double> pulseAnimation;

  const BookingSuccessIcon({
    super.key,
    required this.scaleAnimation,
    required this.pulseAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scaleAnimation,
      child: Center(
        child: ScaleTransition(
          scale: pulseAnimation,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer glowing ring
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: context.colors.gold.withValues(alpha: 0.1),
                ),
              ),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [context.colors.gold, Color(0xFFE5B962)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: context.colors.gold.withValues(alpha: 0.5),
                      blurRadius: 40,
                      spreadRadius: 5,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Icon(
                  FluentIcons.checkmark_48_filled,
                  color: context.colors.white,
                  size: 55,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
