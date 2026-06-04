import 'package:flutter/material.dart';
import 'package:apartment/core/theme/app_colors.dart';
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
            CustomButton(
              text: l10n.bookUnitBtn,
              onPressed: () {
                // TODO: Pass unit id or unit entity later to the contract screen
                context.push(AppRouter.unitContract);
              },
            ),
          ],
        ),
      ),
    );
  }
}
