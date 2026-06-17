import 'package:flutter/material.dart';

enum DeviceType {
  mobile,
  tablet,
  desktop,
}

class AppBreakpoints {
  static const double tablet = 600;
  static const double desktop = 900;
}

class AppResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, DeviceType deviceType) builder;

  const AppResponsiveBuilder({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        DeviceType deviceType;
        if (constraints.maxWidth >= AppBreakpoints.desktop) {
          deviceType = DeviceType.desktop;
        } else if (constraints.maxWidth >= AppBreakpoints.tablet) {
          deviceType = DeviceType.tablet;
        } else {
          deviceType = DeviceType.mobile;
        }
        return builder(context, deviceType);
      },
    );
  }
}

extension ResponsiveContext on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;

  bool get isMobile => screenWidth < AppBreakpoints.tablet;
  bool get isTablet => screenWidth >= AppBreakpoints.tablet && screenWidth < AppBreakpoints.desktop;
  bool get isDesktop => screenWidth >= AppBreakpoints.desktop;

  /// Utility to calculate dynamic crossAxisCount based on screen size.
  int get responsiveCrossAxisCount {
    if (isDesktop) return 4;
    if (isTablet) return 3;
    return 2;
  }

  /// Utility for maximum container width on large screens to prevent stretching.
  double get maxContainerWidth => 800.0;
}
