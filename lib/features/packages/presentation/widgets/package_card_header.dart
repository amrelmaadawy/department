import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import 'package:apartment/features/packages/domain/entities/finishing_package_entity.dart';
import 'package:apartment/l10n/app_localizations.dart';

class PackageCardHeader extends StatelessWidget {
  final FinishingPackageEntity package;
  final List<String> secondaryBadges;

  const PackageCardHeader({
    super.key,
    required this.package,
    required this.secondaryBadges,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(AppRadius.xl),
      ),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              context.colors.primary,
              context.colors.primary.withValues(alpha: 0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -30,
              top: -30,
              child: Icon(
                FluentIcons.premium_24_filled,
                size: 140,
                color: context.colors.white.withValues(alpha: 0.04),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  package.name,
                  style: TextStyle(
                    fontSize: AppFonts.displaySmall,
                    fontWeight: FontWeight.w900,
                    color: context.colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  package.description,
                  style: TextStyle(
                    fontSize: AppFonts.bodyMedium,
                    color: context.colors.white.withValues(alpha: 0.75),
                    height: 1.5,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (secondaryBadges.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.md),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: secondaryBadges.map((badge) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: context.colors.gold.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(AppRadius.round),
                          border: Border.all(
                            color: context.colors.gold.withValues(alpha: 0.4),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              FluentIcons.checkmark_starburst_16_filled,
                              size: 14,
                              color: context.colors.gold,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              badge,
                              style: TextStyle(
                                fontSize: AppFonts.bodySmall,
                                fontWeight: FontWeight.bold,
                                color: context.colors.white,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
                const SizedBox(height: AppSpacing.xl),
                _buildPriceBox(context, l10n),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceBox(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: context.colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: context.colors.gold.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            l10n.packageTotalPrice,
            style: TextStyle(
              fontSize: AppFonts.bodyMedium,
              color: context.colors.white.withValues(alpha: 0.9),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                package.calculatedPrice
                    .toStringAsFixed(0)
                    .replaceAllMapped(
                      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                      (Match m) => '${m[1]},',
                    ),
                style: TextStyle(
                  fontSize: AppFonts.displayMedium,
                  fontWeight: FontWeight.bold,
                  color: context.colors.gold,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                'ر.س',
                style: TextStyle(
                  fontSize: AppFonts.bodySmall,
                  color: context.colors.gold.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
