import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import 'package:apartment/core/theme/theme_extension.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/features/home/domain/entities/project_unit_entity.dart';
import 'package:apartment/l10n/app_localizations.dart';


class UnitCostEstimationCard extends StatelessWidget {
  final ProjectUnitEntity unit;

  const UnitCostEstimationCard({super.key, required this.unit});

  String _formatPrice(double price) {
    return price
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // MOCK FINISHING COST CALCULATION (e.g. 25% of base price for Luxury Package)
    final double finishingCost = unit.price * 0.25;
    final double totalCost = unit.price + finishingCost;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: context.colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: context.colors.border, width: 1),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: context.colors.gold.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Icon(
                    FluentIcons.receipt_money_24_regular,
                    color: context.colors.gold,
                  ),
                ),
                SizedBox(width: AppSpacing.sm),
                Text(
                  l10n.costEstimateTitle,
                  style: TextStyle(
                    fontSize: AppFonts.headlineSmall,
                    fontWeight: FontWeight.bold,
                    color: context.colors.primary,
                  ),
                ),
              ],
            ),
          ),

          Divider(height: 1, color: context.colors.border),

          // Cost Breakdown
          Padding(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                _buildCostRow(
                  context: context,
                  title: l10n.basicUnitPrice,
                  subtitle: l10n.semiFinished,
                  amount: _formatPrice(unit.price),
                  currency: l10n.sar,
                ),
                SizedBox(height: AppSpacing.md),
                _buildCostRow(
                  context: context,
                  title: l10n.estimatedFinishingCost,
                  subtitle: l10n.basedOnLuxuryPackage,
                  amount: _formatPrice(finishingCost),
                  currency: l10n.sar,
                  icon: FluentIcons.diamond_24_regular,
                ),
              ],
            ),
          ),

          // Total
          Container(
            padding: EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: context.colors.background.withValues(alpha: 0.5),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(AppRadius.lg),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.totalExpectedCost,
                  style: TextStyle(
                    fontSize: AppFonts.bodyMedium,
                    color: context.colors.textSecondary,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      _formatPrice(totalCost),
                      style: TextStyle(
                        fontSize: AppFonts.headlineSmall,
                        fontWeight: FontWeight.bold,
                        color: context.colors.gold,
                      ),
                    ),
                    SizedBox(width: 4),
                    Text(
                      l10n.sar,
                      style: TextStyle(
                        fontSize: AppFonts.bodyMedium,
                        fontWeight: FontWeight.bold,
                        color: context.colors.gold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCostRow({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String amount,
    required String currency,
    IconData? icon,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 16, color: context.colors.gold),
                    SizedBox(width: 4),
                  ],
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: AppFonts.bodyMedium,
                      fontWeight: FontWeight.bold,
                      color: context.colors.primary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: AppFonts.labelMedium,
                  color: context.colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              amount,
              style: TextStyle(
                fontSize: AppFonts.bodyLarge,
                fontWeight: FontWeight.bold,
                color: context.colors.primary,
              ),
            ),
            SizedBox(width: 4),
            Text(
              currency,
              style: TextStyle(
                fontSize: AppFonts.labelMedium,
                color: context.colors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
