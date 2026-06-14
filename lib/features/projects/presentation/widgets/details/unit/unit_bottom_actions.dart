import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/l10n/app_localizations.dart';
import 'package:apartment/features/home/domain/entities/project_unit_entity.dart';
import 'package:apartment/core/theme/theme_extension.dart';

class UnitBottomActions extends StatelessWidget {
  final ProjectUnitEntity unit;

  const UnitBottomActions({super.key, required this.unit});

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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                l10n.priceTitle,
                style: TextStyle(
                  fontSize: AppFonts.bodyMedium,
                  color: context.colors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                '${formatter.format(unit.price).trim()} ${l10n.sar}',
                style: TextStyle(
                  fontSize: AppFonts.headlineLarge,
                  fontWeight: FontWeight.bold,
                  color: context.colors.gold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
