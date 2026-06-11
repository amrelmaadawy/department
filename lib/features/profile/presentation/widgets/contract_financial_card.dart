import 'package:flutter/material.dart';
import 'package:apartment/l10n/app_localizations.dart';


import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import 'package:apartment/core/theme/theme_extension.dart';


class ContractFinancialCard extends StatelessWidget {
  final Map<String, dynamic> financialData;

  const ContractFinancialCard({super.key, required this.financialData});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        color: context.colors.primary,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [
          BoxShadow(
            color: context.colors.primary.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.financialSummary,
            style: TextStyle(
              fontSize: AppFonts.bodyLarge,
              fontWeight: FontWeight.bold,
              color: context.colors.gold,
            ),
          ),
          SizedBox(height: AppSpacing.lg),
          _buildFinancialRow(context, l10n.totalContractValue, financialData['totalPrice']),
          SizedBox(height: AppSpacing.md),
          Divider(color: context.colors.white, height: 1, thickness: 0.2),
          SizedBox(height: AppSpacing.md),
          _buildFinancialRow(context, l10n.paidAmountLabel, financialData['paidAmount']),
          SizedBox(height: AppSpacing.md),
          _buildFinancialRow(context, l10n.remainingAmountLabel, financialData['remainingAmount'], isHighlight: true),
        ],
      ),
    );
  }

  Widget _buildFinancialRow(BuildContext context, String label, String value, {bool isHighlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: AppFonts.bodyMedium,
            color: context.colors.white.withValues(alpha: 0.8),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isHighlight ? AppFonts.headlineSmall : AppFonts.bodyLarge,
            fontWeight: FontWeight.bold,
            color: isHighlight ? context.colors.gold : context.colors.white,
          ),
        ),
      ],
    );
  }
}
