import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import 'package:apartment/core/theme/app_colors.dart';
import 'package:apartment/features/packages/domain/entities/finishing_package_entity.dart';

class PackageCardStyles {
  static Color getBackgroundColor(PackageTier tier) {
    switch (tier) {
      case PackageTier.luxury:
        return const Color(0xFF1E1E1E); // Rich dark grey
      case PackageTier.custom:
        return const Color(0xFF0A0A0A); // Pitch black
      default:
        return AppColors.white;
    }
  }

  static Color getTitleColor(PackageTier tier) {
    switch (tier) {
      case PackageTier.luxury:
      case PackageTier.custom:
        return AppColors.gold;
      default:
        return AppColors.primary;
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

  static LinearGradient getHeaderGradient(PackageTier tier) {
    switch (tier) {
      case PackageTier.economic:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFFFFF),
            Color(0xFFFBF4E6), // Warm goldish white
          ],
        );
      case PackageTier.standard:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFFFFF),
            Color(0xFFE8F0F6), // Cool icy silver
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
