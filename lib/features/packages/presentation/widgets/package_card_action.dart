import 'package:flutter/material.dart';

import 'package:apartment/core/theme/app_colors.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/core/widgets/custom_button.dart';
import 'package:apartment/features/packages/domain/entities/finishing_package_entity.dart';

class PackageCardAction extends StatelessWidget {
  final FinishingPackageEntity package;
  final bool isDark;

  const PackageCardAction({
    super.key,
    required this.package,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
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
    );
  }
}
