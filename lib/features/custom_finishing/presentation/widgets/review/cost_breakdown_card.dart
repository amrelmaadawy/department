import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_fonts.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../cubit/custom_finishing_state.dart';

class CostBreakdownCard extends StatelessWidget {
  final CustomFinishingState state;

  const CostBreakdownCard({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: const Color(
          0xFFFBF9F1,
        ), // Very light premium beige background from reference
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              l10n.costDetails,
              style: const TextStyle(
                fontSize: AppFonts.headlineMedium,
                fontWeight: FontWeight.bold,
                color: AppColors.gold,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          _buildCostRow(
            l10n.totalMaterials,
            state.materialsCost,
            isTotal: false,
          ),
          const SizedBox(height: AppSpacing.md),
          _buildCostRow(
            l10n.totalWorkmanship,
            state.workmanshipCost,
            isTotal: false,
          ),
          const SizedBox(height: AppSpacing.md),
          _buildCostRow(l10n.vatAmount, state.vatAmount, isTotal: false),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
            child: Divider(color: AppColors.border.withValues(alpha: 0.5)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.totalAmount,
                style: const TextStyle(
                  fontSize: AppFonts.headlineSmall,
                  fontWeight: FontWeight.bold,
                  color: AppColors.gold,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    state.totalEstimatedCost
                        .toStringAsFixed(0)
                        .replaceAllMapped(
                          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                          (Match m) => '${m[1]},',
                        ),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: AppColors.gold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'ج.م',
                    style: TextStyle(
                      fontSize: AppFonts.bodyMedium,
                      fontWeight: FontWeight.bold,
                      color: AppColors.gold,
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
    String title,
    double amount, {
    required bool isTotal,
    bool isFaded = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: isTotal ? AppFonts.headlineSmall : AppFonts.bodyLarge,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: isTotal
                ? AppColors.primary
                : AppColors.textPrimary.withValues(alpha: isFaded ? 0.5 : 0.7),
          ),
        ),
        Text(
          '${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} ج.م',
          style: TextStyle(
            fontSize: isTotal ? AppFonts.headlineMedium : AppFonts.bodyLarge,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            color: isTotal
                ? AppColors.primary
                : AppColors.textPrimary.withValues(alpha: isFaded ? 0.5 : 1.0),
          ),
        ),
      ],
    );
  }
}
