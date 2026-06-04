import 'package:flutter/material.dart';

import 'package:apartment/core/theme/app_colors.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_spacing.dart';

class PackageCardFeatures extends StatelessWidget {
  final List<String> features;
  final bool isDark;
  final IconData featureIcon;

  const PackageCardFeatures({
    super.key,
    required this.features,
    required this.isDark,
    required this.featureIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.xl,
      ),
      decoration: BoxDecoration(
        color: isDark ? Colors.transparent : Colors.white,
      ),
      child: Column(
        children: features
            .map((feature) => _buildFeatureRow(feature, isDark))
            .toList(),
      ),
    );
  }

  Widget _buildFeatureRow(String feature, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: AppSpacing.lg,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 2),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.gold.withValues(alpha: 0.2)
                  : AppColors.gold.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(featureIcon, size: 16, color: AppColors.gold),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              feature,
              style: TextStyle(
                fontSize: AppFonts.headlineSmall,
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
}
