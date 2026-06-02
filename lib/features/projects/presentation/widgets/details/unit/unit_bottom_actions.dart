import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import 'package:apartment/core/theme/app_colors.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/core/widgets/custom_button.dart';
import 'package:apartment/core/routes/app_router.dart';
import 'package:apartment/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class UnitBottomActions extends StatelessWidget {
  const UnitBottomActions({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Outlined Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                onPressed: () {
                  context.push(AppRouter.packages);
                },
                icon: const Icon(
                  FluentIcons.apps_24_regular,
                  size: 20,
                  color: AppColors.gold,
                ),
                label: Text(
                  l10n.readyPackagesBtn,
                  style: const TextStyle(
                    fontSize: AppFonts.bodyMedium,
                    fontWeight: FontWeight.bold,
                    color: AppColors.gold,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.gold, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Solid Button
            CustomButton(
              text: l10n.startFinishingBtn,
              onPressed: () {
                context.push(AppRouter.customFinishing);
              },
            ),
          ],
        ),
      ),
    );
  }
}
