import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/theme/app_fonts.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/theme_extension.dart';
import '../../../../../l10n/app_localizations.dart';

class PaymentSummaryCard extends StatelessWidget {
  final double subtotal;
  final double vatPercentage;
  final double downPaymentPercentage;

  const PaymentSummaryCard({
    super.key,
    required this.subtotal,
    this.vatPercentage = 0.15,
    this.downPaymentPercentage = 0.20,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final formatter = NumberFormat.currency(symbol: '', decimalDigits: 0);

    final vatAmount = subtotal * vatPercentage;
    final totalAmount = subtotal + vatAmount;
    final downPaymentAmount = totalAmount * downPaymentPercentage;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.paymentSummary,
            style: TextStyle(
              fontSize: AppFonts.headlineSmall,
              fontWeight: FontWeight.bold,
              color: context.colors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _buildSummaryRow(
            context: context,
            title: l10n.subtotal,
            amount: subtotal,
            formatter: formatter,
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildSummaryRow(
            context: context,
            title: l10n.vat,
            amount: vatAmount,
            formatter: formatter,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: Divider(height: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.totalAmount,
                style: TextStyle(
                  fontSize: AppFonts.bodyLarge,
                  fontWeight: FontWeight.w600,
                  color: context.colors.textPrimary,
                ),
              ),
              Text(
                '${formatter.format(totalAmount)} ${l10n.sar}',
                style: TextStyle(
                  fontSize: AppFonts.bodyLarge,
                  fontWeight: FontWeight.w600,
                  color: context.colors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: context.colors.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(
                color: context.colors.primary.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.downPayment,
                  style: TextStyle(
                    fontSize: AppFonts.bodyLarge,
                    fontWeight: FontWeight.bold,
                    color: context.colors.primary,
                  ),
                ),
                Text(
                  '${formatter.format(downPaymentAmount)} ${l10n.sar}',
                  style: TextStyle(
                    fontSize: AppFonts.headlineSmall,
                    fontWeight: FontWeight.bold,
                    color: context.colors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow({
    required BuildContext context,
    required String title,
    required double amount,
    required NumberFormat formatter,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: AppFonts.bodyMedium,
            color: context.colors.textSecondary,
          ),
        ),
        Text(
          '${formatter.format(amount)} ${l10n.sar}',
          style: TextStyle(
            fontSize: AppFonts.bodyMedium,
            fontWeight: FontWeight.w600,
            color: context.colors.textPrimary,
          ),
        ),
      ],
    );
  }
}
