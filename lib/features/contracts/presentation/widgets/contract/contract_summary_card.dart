import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import 'package:apartment/core/theme/app_colors.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/l10n/app_localizations.dart';

import '../../../domain/entities/contract_type.dart';
import '../../../../design_studio/presentation/cubit/design_context_cubit.dart';
import '../../../../../core/di/injection_container.dart';

class ContractSummaryCard extends StatelessWidget {
  final ContractType contractType;
  final double? finishingTotal;

  const ContractSummaryCard({
    super.key, 
    required this.contractType,
    this.finishingTotal,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final unit = sl<DesignContextCubit>().state.selectedUnit;
    
    final title = contractType == ContractType.unit 
        ? l10n.unitSummaryTitle 
        : 'ملخص مقاولة التشطيب';
        
    final icon = contractType == ContractType.unit 
        ? FluentIcons.building_retail_24_regular 
        : FluentIcons.paint_brush_24_regular;
        
    final price = contractType == ContractType.unit 
        ? (unit?.price ?? 0.0) 
        : (finishingTotal ?? 0.0);
    return Container(
      margin: const EdgeInsets.all(AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: AppColors.border.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary),
              const SizedBox(width: AppSpacing.sm),
              Text(
                title,
                style: const TextStyle(
                  fontSize: AppFonts.headlineSmall,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(color: AppColors.background),
          const SizedBox(height: AppSpacing.md),
          
          if (unit != null) ...[
            _buildInfoRow('المشروع', 'لؤلؤة الرياض', FluentIcons.location_24_regular),
            const SizedBox(height: AppSpacing.sm),
            _buildInfoRow('نوع الوحدة', 'وحدة ${unit.title} - ${unit.area} متر مربع', FluentIcons.home_24_regular),
            const SizedBox(height: AppSpacing.sm),
            _buildInfoRow('الدور', 'الدور ${unit.floor}', FluentIcons.layer_24_regular),
          ] else ...[
            _buildInfoRow('المشروع', 'لؤلؤة الرياض', FluentIcons.location_24_regular),
            const SizedBox(height: AppSpacing.sm),
            _buildInfoRow('التفاصيل', 'قيد التحميل...', FluentIcons.info_24_regular),
          ],
          
          if (contractType == ContractType.finishing) ...[
            const SizedBox(height: AppSpacing.sm),
            _buildInfoRow('نوع التشطيب', 'تشطيب مخصص كامل', FluentIcons.color_24_regular),
          ],
          
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  contractType == ContractType.unit ? l10n.priceTitle : 'إجمالي التشطيب',
                  style: const TextStyle(
                    fontSize: AppFonts.bodyMedium,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  '${price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} ${l10n.sar}',
                  style: const TextStyle(
                    fontSize: AppFonts.headlineSmall,
                    fontWeight: FontWeight.bold,
                    color: AppColors.gold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.textSecondary),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: AppFonts.bodyMedium,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: AppFonts.bodyMedium,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
