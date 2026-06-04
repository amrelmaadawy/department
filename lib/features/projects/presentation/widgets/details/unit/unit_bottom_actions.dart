import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:apartment/core/theme/app_colors.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/core/widgets/custom_button.dart';
import 'package:apartment/core/routes/app_router.dart';
import 'package:apartment/l10n/app_localizations.dart';
import 'package:apartment/features/home/domain/entities/project_unit_entity.dart';
import 'package:go_router/go_router.dart';

class UnitBottomActions extends StatelessWidget {
  final ProjectUnitEntity unit;

  const UnitBottomActions({super.key, required this.unit});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final formatter = NumberFormat.currency(symbol: 'EGP ', decimalDigits: 0);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'السعر الإجمالي', // Ideally from l10n, using hardcoded Arabic for now as l10n might not have it
                    style: TextStyle(
                      fontSize: AppFonts.labelMedium,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    formatter.format(unit.price),
                    style: const TextStyle(
                      fontSize: AppFonts.headlineSmall,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: CustomButton(
                text: l10n.bookUnitBtn,
                onPressed: () {
                  context.push(AppRouter.unitContract);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
