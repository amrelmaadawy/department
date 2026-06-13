import 'package:flutter/material.dart';

import '../../../../../core/theme/app_fonts.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../cubit/custom_finishing_state.dart';
import '../../../../../core/di/injection_container.dart';
import '../../../../design_studio/presentation/cubit/design_context_cubit.dart';
import 'package:apartment/core/theme/theme_extension.dart';

class CostBreakdownCard extends StatelessWidget {
  final CustomFinishingState state;

  const CostBreakdownCard({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final designContext = sl<DesignContextCubit>().state;
    final unit = designContext.selectedUnit;
    final unitPrice = unit?.price ?? 0.0;
    final finishingCost = state.totalEstimatedCost;
    final grandTotal = unitPrice > 0
        ? unitPrice + finishingCost
        : finishingCost;

    return Container(
      padding: EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: context
            .colors
            .white, // Maps to dark elevated color in dark mode, white in light mode
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: context.colors.gold.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              l10n.costDetails,
              style: TextStyle(
                fontSize: AppFonts.headlineMedium,
                fontWeight: FontWeight.bold,
                color: context.colors.gold,
              ),
            ),
          ),
          SizedBox(height: AppSpacing.xl),
          if (unit != null) ...[
            _buildCostRow(
              context,
              l10n.unitPriceWithTitle(unit.title),
              unitPrice,
              isTotal: false,
            ),
            SizedBox(height: AppSpacing.md),
          ],
          _buildCostRow(
            context,
            l10n.totalMaterials,
            state.materialsCost,
            isTotal: false,
            isFaded: true,
          ),
          SizedBox(height: AppSpacing.xs),
          _buildCostRow(
            context,
            l10n.totalWorkmanship,
            state.workmanshipCost,
            isTotal: false,
            isFaded: true,
          ),
          SizedBox(height: AppSpacing.xs),
          _buildCostRow(
            context,
            l10n.vatAmount,
            state.vatAmount,
            isTotal: false,
            isFaded: true,
          ),
          SizedBox(height: AppSpacing.md),
          _buildCostRow(
            context,
            l10n.totalFinishingCost,
            finishingCost,
            isTotal: false,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
            child: Divider(color: context.colors.border.withValues(alpha: 0.5)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  l10n.totalAmount,
                  style: TextStyle(
                    fontSize: AppFonts.headlineSmall,
                    fontWeight: FontWeight.bold,
                    color: context.colors.gold,
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    grandTotal
                        .toStringAsFixed(0)
                        .replaceAllMapped(
                          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                          (Match m) => '${m[1]},',
                        ),
                    style: TextStyle(
                      fontSize: AppFonts.displayMedium,
                      fontWeight: FontWeight.w900,
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
        ],
      ),
    );
  }

  Widget _buildCostRow(
    BuildContext context,
    String title,
    double amount, {
    required bool isTotal,
    bool isFaded = false,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: isTotal ? AppFonts.headlineSmall : AppFonts.bodyLarge,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              color: isTotal
                  ? context.colors.primary
                  : context.colors.textPrimary.withValues(
                      alpha: isFaded ? 0.5 : 0.7,
                    ),
            ),
          ),
        ),
        SizedBox(width: AppSpacing.sm),
        Text(
          '${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} ${l10n.sar}',
          style: TextStyle(
            fontSize: isTotal ? AppFonts.headlineMedium : AppFonts.bodyLarge,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            color: isTotal
                ? context.colors.primary
                : context.colors.textPrimary.withValues(
                    alpha: isFaded ? 0.5 : 1.0,
                  ),
          ),
        ),
      ],
    );
  }
}
