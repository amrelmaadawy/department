import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import 'package:apartment/core/theme/app_colors.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/l10n/app_localizations.dart';
import 'package:apartment/features/packages/domain/entities/finishing_package_entity.dart';

class PackageCardHeader extends StatelessWidget {
  final FinishingPackageEntity package;
  final bool isDark;
  final Color titleColor;
  final LinearGradient gradient;
  final IconData featureIcon;

  const PackageCardHeader({
    super.key,
    required this.package,
    required this.isDark,
    required this.titleColor,
    required this.gradient,
    required this.featureIcon,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl,
            AppSpacing.xxl, // Extra space for ribbon
            AppSpacing.xl,
            AppSpacing.lg,
          ),
          decoration: BoxDecoration(
            gradient: gradient,
            border: Border(
              bottom: BorderSide(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.black.withValues(alpha: 0.05),
                width: 1,
              ),
            ),
          ),
          child: Column(
            children: [
              if (package.tier == PackageTier.custom)
                const Padding(
                  padding: EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Icon(
                    FluentIcons.crown_24_filled,
                    color: AppColors.gold,
                    size: 36,
                  ),
                ),
              Text(
                package.title,
                style: TextStyle(
                  fontSize: AppFonts.displayMedium, // Larger
                  fontWeight: FontWeight.w900,
                  color: titleColor,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              if (package.subtitle != null)
                Text(
                  package.subtitle!,
                  style: TextStyle(
                    fontSize: AppFonts.headlineSmall,
                    fontWeight: FontWeight.w600,
                    color: titleColor.withValues(alpha: 0.7),
                    letterSpacing: -0.5,
                  ),
                )
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      package.pricePerSqm
                          .toStringAsFixed(0)
                          .replaceAllMapped(
                            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                            (Match m) => '${m[1]},',
                          ),
                      style: TextStyle(
                        fontSize: AppFonts.displayLarge + 4, // Massive
                        fontWeight: FontWeight.w900,
                        color: titleColor,
                        letterSpacing: -1.5,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      l10n.pricePerSqm,
                      style: TextStyle(
                        fontSize: AppFonts.bodyLarge,
                        fontWeight: FontWeight.w600,
                        color: titleColor.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        // Background Watermark Icon
        Positioned(
          right: -30,
          top: -20,
          child: Icon(
            featureIcon,
            size: 160,
            color: titleColor.withValues(alpha: 0.04),
          ),
        ),
      ],
    );
  }
}
