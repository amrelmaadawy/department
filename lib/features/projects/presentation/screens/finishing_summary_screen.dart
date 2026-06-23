import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:apartment/core/theme/theme_extension.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/l10n/app_localizations.dart';
import 'package:apartment/core/routes/app_router.dart';
import 'package:apartment/features/home/domain/entities/project_unit_entity.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

class FinishingSummaryScreen extends StatelessWidget {
  final ProjectUnitEntity unit;
  final double totalFinishingCost;

  const FinishingSummaryScreen({
    super.key,
    required this.unit,
    required this.totalFinishingCost,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final formatter = NumberFormat.currency(symbol: '', decimalDigits: 0);

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: Text(
          'ملخص التشطيب',
          style: TextStyle(
            fontSize: AppFonts.headlineSmall,
            fontWeight: FontWeight.bold,
            color: context.colors.textPrimary,
          ),
        ),
        centerTitle: true,
        backgroundColor: context.colors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(FluentIcons.arrow_left_24_regular, color: context.colors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                // Unit Info Card
                Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: context.colors.white,
                    borderRadius: BorderRadius.circular(AppRadius.xl),
                    border: Border.all(color: context.colors.border.withValues(alpha: 0.5)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: context.colors.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(FluentIcons.building_home_24_regular, color: context.colors.primary),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              unit.title,
                              style: TextStyle(
                                fontSize: AppFonts.bodyLarge,
                                fontWeight: FontWeight.bold,
                                color: context.colors.textPrimary,
                              ),
                            ),
                            Text(
                              unit.locationTypeLabel,
                              style: TextStyle(
                                fontSize: AppFonts.bodySmall,
                                color: context.colors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${formatter.format(unit.price).trim()} ${l10n.sar}',
                        style: TextStyle(
                          fontSize: AppFonts.bodyMedium,
                          fontWeight: FontWeight.bold,
                          color: context.colors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                
                // Details Header
                Text(
                  'تفاصيل تكلفة التشطيب', // Hardcoded as fallback or could use l10n
                  style: TextStyle(
                    fontSize: AppFonts.headlineSmall,
                    fontWeight: FontWeight.bold,
                    color: context.colors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                
                // Finishing Details
                Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: context.colors.white,
                    borderRadius: BorderRadius.circular(AppRadius.xl),
                    border: Border.all(color: context.colors.gold.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'إجمالي التكلفة الإضافية',
                            style: TextStyle(
                              fontSize: AppFonts.bodyLarge,
                              color: context.colors.textPrimary,
                            ),
                          ),
                          Text(
                            '+${formatter.format(totalFinishingCost).trim()} ${l10n.sar}',
                            style: TextStyle(
                              fontSize: AppFonts.bodyLarge,
                              fontWeight: FontWeight.bold,
                              color: context.colors.success,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Grand Total & Submit
          Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'الإجمالي النهائي (الوحدة + التشطيب)',
                    style: TextStyle(
                      fontSize: AppFonts.bodySmall,
                      color: context.colors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '${formatter.format(unit.price + totalFinishingCost).trim()} ${l10n.sar}',
                    style: TextStyle(
                      fontSize: AppFonts.displaySmall,
                      fontWeight: FontWeight.bold,
                      color: context.colors.gold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  ElevatedButton(
                    onPressed: () {
                      context.push(
                        AppRouter.contractsReview,
                        extra: {
                          'totalFinishingCost': totalFinishingCost,
                          'unit': unit,
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.colors.primary,
                      foregroundColor: context.colors.white,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                      ),
                    ),
                    child: Text(
                      l10n.reviewAndSignContracts,
                      style: const TextStyle(
                        fontSize: AppFonts.bodyLarge,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
