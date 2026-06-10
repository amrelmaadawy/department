import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import 'package:apartment/features/packages/domain/entities/finishing_package_entity.dart';
import 'package:apartment/core/theme/theme_extension.dart';


class PackageCardStyles {
  static Color getBackgroundColor(BuildContext context, PackageTier tier) {
    switch (tier) {
      case PackageTier.luxury:
        return const Color(0xFF1E1E1E); // Rich dark grey
      case PackageTier.custom:
        return const Color(0xFF0A0A0A); // Pitch black
      default:
        return context.colors.white;
    }
  }

  static Color getTitleColor(BuildContext context, PackageTier tier) {
    switch (tier) {
      case PackageTier.luxury:
      case PackageTier.custom:
        return context.colors.gold;
      default:
        return context.colors.primary;
    }
  }

  static IconData getFeatureIcon(PackageTier tier) {
    switch (tier) {
      case PackageTier.custom:
      case PackageTier.luxury:
        return FluentIcons.star_16_filled;
      default:
        return FluentIcons.checkmark_16_filled;
    }
  }

  static LinearGradient getHeaderGradient(BuildContext context, PackageTier tier) {
    switch (tier) {
      case PackageTier.economic:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            context.colors.white,
            Color.lerp(context.colors.white, context.colors.gold, 0.05)!,
          ],
        );
      case PackageTier.standard:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            context.colors.white,
            Color.lerp(context.colors.white, context.colors.primary, 0.05)!,
          ],
        );
      case PackageTier.luxury:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF333333), Color(0xFF1A1A1A)],
        );
      case PackageTier.custom:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF222222), Color(0xFF000000)],
        );
    }
  }
}