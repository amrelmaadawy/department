import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/core/widgets/custom_button.dart';
import 'package:apartment/features/packages/domain/entities/finishing_package_entity.dart';
import 'package:apartment/core/theme/theme_extension.dart';


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
                    color: context.colors.gold.withValues(alpha: 0.2),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: OutlinedButton(
                onPressed: () {
                  // Custom package might have a different flow later, but for now navigate to custom finishing
                  context.push('/custom-finishing');
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: context.colors.gold,
                    width: 2,
                  ),
                  backgroundColor: context.colors.gold.withValues(
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
                  style: TextStyle(
                    fontSize: AppFonts.headlineSmall,
                    fontWeight: FontWeight.bold,
                    color: context.colors.gold,
                  ),
                ),
              ),
            )
          : CustomButton(
              text: package.buttonText,
              onPressed: () {
                context.push('/custom-finishing');
              },
              backgroundColor: isDark
                  ? const Color(0xFF8B6914) // Vibrant dark gold
                  : context.colors.gold,
            ),
    );
  }
}
