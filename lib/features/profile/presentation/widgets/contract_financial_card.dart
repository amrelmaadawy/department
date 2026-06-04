import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';

class ContractFinancialCard extends StatelessWidget {
  final Map<String, dynamic> financialData;

  const ContractFinancialCard({super.key, required this.financialData});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'الملخص المالي',
            style: TextStyle(
              fontSize: AppFonts.bodyLarge,
              fontWeight: FontWeight.bold,
              color: AppColors.gold,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildFinancialRow('إجمالي قيمة التعاقد', financialData['totalPrice']),
          const SizedBox(height: AppSpacing.md),
          const Divider(color: AppColors.white, height: 1, thickness: 0.2),
          const SizedBox(height: AppSpacing.md),
          _buildFinancialRow('المدفوع (مقدم + أقساط)', financialData['paidAmount']),
          const SizedBox(height: AppSpacing.md),
          _buildFinancialRow('المتبقي', financialData['remainingAmount'], isHighlight: true),
        ],
      ),
    );
  }

  Widget _buildFinancialRow(String label, String value, {bool isHighlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: AppFonts.bodyMedium,
            color: AppColors.white.withValues(alpha: 0.8),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isHighlight ? AppFonts.headlineSmall : AppFonts.bodyLarge,
            fontWeight: FontWeight.bold,
            color: isHighlight ? AppColors.gold : AppColors.white,
          ),
        ),
      ],
    );
  }
}
