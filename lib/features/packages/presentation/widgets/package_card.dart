import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import 'package:apartment/core/theme/app_colors.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/core/widgets/custom_button.dart';
import 'package:apartment/l10n/app_localizations.dart';
import 'package:apartment/features/packages/domain/entities/finishing_package_entity.dart';
import 'package_card_header.dart';
import 'package_card_features.dart';
import 'package_card_action.dart';
import 'package_card_styles.dart';

class PackageCard extends StatelessWidget {
  final FinishingPackageEntity package;

  const PackageCard({super.key, required this.package});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark =
        package.tier == PackageTier.custom ||
        package.tier == PackageTier.luxury;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Main Card
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: PackageCardStyles.getBackgroundColor(package.tier),
              borderRadius: BorderRadius.circular(AppRadius.lg),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? AppColors.gold.withValues(alpha: 0.12)
                      : Colors.black.withValues(alpha: 0.1),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
              border: package.tier == PackageTier.custom
                  ? Border.all(
                      color: AppColors.gold.withValues(alpha: 0.5),
                      width: 1.5,
                    )
                  : Border.all(
                      color: AppColors.border.withValues(alpha: 0.3),
                      width: 1,
                    ),
            ),
            child: Column(
              children: [
                PackageCardHeader(
                  package: package,
                  isDark: isDark,
                  titleColor: PackageCardStyles.getTitleColor(package.tier),
                  gradient: PackageCardStyles.getHeaderGradient(package.tier),
                  featureIcon: PackageCardStyles.getFeatureIcon(package.tier),
                ),

                // Features List
                PackageCardFeatures(
                  features: package.features,
                  isDark: isDark,
                  featureIcon: PackageCardStyles.getFeatureIcon(package.tier),
                ),

                // Action Button
                PackageCardAction(
                  package: package,
                  isDark: isDark,
                ),
              ],
            ),
          ),

          // Floating Ribbon / Badge
          if (package.badge != null)
            Positioned(
              top: -12,
              right: 24, // RTL friendly position (usually top left or right)
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.gold, Color(0xFFD4AF37)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.gold.withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  package.badge!,
                  style: const TextStyle(
                    fontSize: AppFonts.bodyLarge,
                    fontWeight: FontWeight.w900,
                    color: AppColors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
