import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import 'package:apartment/core/theme/app_colors.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/core/widgets/custom_button.dart';
import 'package:apartment/l10n/app_localizations.dart';
import 'package:apartment/features/packages/domain/entities/finishing_package_entity.dart';

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
              color: _getBackgroundColor(),
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
                // Header / Gradient Area
                Stack(
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
                        gradient: _getHeaderGradient(),
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
                              color: _getTitleColor(),
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
                                color: _getTitleColor().withValues(alpha: 0.7),
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
                                    fontSize:
                                        AppFonts.displayLarge + 4, // Massive
                                    fontWeight: FontWeight.w900,
                                    color: _getTitleColor(),
                                    letterSpacing: -1.5,
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                Text(
                                  l10n.pricePerSqm,
                                  style: TextStyle(
                                    fontSize: AppFonts.bodyLarge,
                                    fontWeight: FontWeight.w600,
                                    color: _getTitleColor().withValues(
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
                        _getFeatureIcon(),
                        size: 160,
                        color: _getTitleColor().withValues(alpha: 0.04),
                      ),
                    ),
                  ],
                ),

                // Features List
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                    vertical: AppSpacing.xl,
                  ),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.transparent : Colors.white,
                  ),
                  child: Column(
                    children: package.features
                        .map((feature) => _buildFeatureRow(feature, isDark))
                        .toList(),
                  ),
                ),

                // Action Button
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.xl,
                    0,
                    AppSpacing.xl,
                    AppSpacing.xl,
                  ),
                  child: package.tier == PackageTier.custom
                      ? Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.gold.withValues(alpha: 0.2),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                color: AppColors.gold,
                                width: 2,
                              ),
                              backgroundColor: AppColors.gold.withValues(
                                alpha: 0.05,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppRadius.md,
                                ),
                              ),
                              minimumSize: const Size(double.infinity, 56),
                            ),
                            child: Text(
                              package.buttonText,
                              style: const TextStyle(
                                fontSize: AppFonts.headlineSmall,
                                fontWeight: FontWeight.bold,
                                color: AppColors.gold,
                              ),
                            ),
                          ),
                        )
                      : CustomButton(
                          text: package.buttonText,
                          onPressed: () {},
                          backgroundColor: isDark
                              ? const Color(0xFF8B6914) // Vibrant dark gold
                              : AppColors.gold,
                        ),
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

  Widget _buildFeatureRow(String feature, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: AppSpacing.lg,
      ), // Increased spacing
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 2),
            padding: const EdgeInsets.all(6), // Larger badge
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.gold.withValues(alpha: 0.2)
                  : AppColors.gold.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(_getFeatureIcon(), size: 16, color: AppColors.gold),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              feature,
              style: TextStyle(
                fontSize: AppFonts.headlineSmall, // Even more readable
                fontWeight: FontWeight.w600,
                color: isDark
                    ? Colors.white.withValues(alpha: 0.95)
                    : AppColors.textPrimary.withValues(alpha: 0.85),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (package.tier) {
      case PackageTier.luxury:
        return const Color(0xFF1E1E1E); // Rich dark grey
      case PackageTier.custom:
        return const Color(0xFF0A0A0A); // Pitch black
      default:
        return AppColors.white;
    }
  }

  Color _getTitleColor() {
    switch (package.tier) {
      case PackageTier.luxury:
      case PackageTier.custom:
        return AppColors.gold;
      default:
        return AppColors.primary;
    }
  }

  IconData _getFeatureIcon() {
    switch (package.tier) {
      case PackageTier.custom:
      case PackageTier.luxury:
        return FluentIcons.star_16_filled;
      default:
        return FluentIcons.checkmark_16_filled;
    }
  }

  LinearGradient _getHeaderGradient() {
    switch (package.tier) {
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
