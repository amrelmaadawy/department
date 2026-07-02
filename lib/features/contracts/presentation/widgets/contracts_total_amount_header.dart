import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_radius.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import '../../../../l10n/app_localizations.dart';

class ContractsTotalAmountHeader extends StatelessWidget {
  final double totalCost;

  const ContractsTotalAmountHeader({
    super.key,
    required this.totalCost,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(
          color: context.colors.gold.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: context.colors.gold.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.colors.gold.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              FluentIcons.receipt_money_24_filled,
              size: 32,
              color: context.colors.gold,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.totalAmount,
            style: TextStyle(
              fontSize: AppFonts.bodyMedium,
              color: context.colors.textPrimary.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                totalCost.toStringAsFixed(0),
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: context.colors.primary,
                  height: 1.0,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                l10n.sar,
                style: TextStyle(
                  fontSize: AppFonts.bodyLarge,
                  fontWeight: FontWeight.bold,
                  color: context.colors.gold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
