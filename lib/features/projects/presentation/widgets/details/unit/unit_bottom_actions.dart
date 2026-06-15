import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/l10n/app_localizations.dart';
import 'package:apartment/features/home/domain/entities/project_unit_entity.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import 'package:apartment/core/widgets/custom_button.dart';
import 'package:apartment/core/routes/app_router.dart';

class UnitBottomActions extends StatelessWidget {
  final ProjectUnitEntity unit;
  final double finishingCost;

  const UnitBottomActions({super.key, required this.unit, this.finishingCost = 0.0});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final formatter = NumberFormat.currency(symbol: '', decimalDigits: 0);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: context.colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Price Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    l10n.priceTitle,
                    style: TextStyle(
                      fontSize: AppFonts.bodyMedium,
                      color: context.colors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${formatter.format(unit.price + finishingCost).trim()} ${l10n.sar}',
                    style: TextStyle(
                      fontSize: AppFonts.headlineLarge,
                      fontWeight: FontWeight.bold,
                      color: context.colors.gold,
                    ),
                  ),
                ],
              ),
              
              // Breakdown Row (only if finishing is present)
              if (finishingCost > 0) ...[
                const SizedBox(height: AppSpacing.xs),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.finishingContract,
                      style: TextStyle(
                        fontSize: AppFonts.bodySmall,
                        color: context.colors.textSecondary.withValues(alpha: 0.8),
                      ),
                    ),
                    Text(
                      '+ ${formatter.format(finishingCost).trim()} ${l10n.sar}',
                      style: TextStyle(
                        fontSize: AppFonts.bodySmall,
                        color: context.colors.success,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
              
              SizedBox(height: AppSpacing.md),
              
              // Full Width Action Button
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: l10n.reviewAndSignContracts,
                  onPressed: () {
                    context.push(
                      AppRouter.contractsReview,
                      extra: {
                        'totalFinishingCost': finishingCost,
                        'unit': unit,
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
