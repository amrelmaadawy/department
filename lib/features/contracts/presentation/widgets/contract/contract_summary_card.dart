import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';


import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/l10n/app_localizations.dart';

import '../../../domain/entities/contract_type.dart';
import '../../../../design_studio/presentation/cubit/design_context_cubit.dart';
import '../../../../../core/di/injection_container.dart';
import 'package:apartment/core/theme/theme_extension.dart';

class ContractSummaryCard extends StatelessWidget {
  final ContractType contractType;
  final double? finishingTotal;
  final dynamic unit;

  const ContractSummaryCard({
    super.key, 
    required this.contractType,
    this.finishingTotal,
    this.unit,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final unit = this.unit ?? sl<DesignContextCubit>().state.selectedUnit;
    
    final title = contractType == ContractType.unit 
        ? l10n.unitSummaryTitle 
        : l10n.finishingContractSummary;
        
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
        color: context.colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: context.colors.border.withValues(alpha: 0.1),
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
              Icon(icon, color: context.colors.primary),
              const SizedBox(width: AppSpacing.sm),
              Text(
                title,
                style: TextStyle(
                  fontSize: AppFonts.headlineSmall,
                  fontWeight: FontWeight.bold,
                  color: context.colors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Divider(color: context.colors.background),
          const SizedBox(height: AppSpacing.md),
          
          if (unit != null) ...[
            _buildInfoRow(context, l10n.project, 'Riyadh Project', FluentIcons.location_24_regular),
            const SizedBox(height: AppSpacing.sm),
            _buildInfoRow(context, l10n.unitType, l10n.unitTypeDesc(unit.title, unit.area.toString()), FluentIcons.home_24_regular),
            const SizedBox(height: AppSpacing.sm),
            _buildInfoRow(context, l10n.floor, l10n.floorDesc(unit.floor.toString()), FluentIcons.layer_24_regular),
          ] else ...[
            _buildInfoRow(context, l10n.project, 'Riyadh Project', FluentIcons.location_24_regular),
            const SizedBox(height: AppSpacing.sm),
            _buildInfoRow(context, l10n.details, l10n.loadingStatus, FluentIcons.info_24_regular),
          ],
          
          if (contractType == ContractType.finishing) ...[
            const SizedBox(height: AppSpacing.sm),
            _buildInfoRow(context, l10n.finishingType, l10n.fullCustomFinishing, FluentIcons.color_24_regular),
          ],
          
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: context.colors.background,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  contractType == ContractType.unit ? l10n.priceTitle : l10n.totalFinishingCost,
                  style: TextStyle(
                    fontSize: AppFonts.bodyMedium,
                    color: context.colors.textSecondary,
                  ),
                ),
                Text(
                  '${price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} ${l10n.sar}',
                  style: TextStyle(
                    fontSize: AppFonts.headlineSmall,
                    fontWeight: FontWeight.bold,
                    color: context.colors.gold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: context.colors.textSecondary),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: AppFonts.bodyMedium,
              color: context.colors.textSecondary,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: AppFonts.bodyMedium,
            fontWeight: FontWeight.bold,
            color: context.colors.textPrimary,
          ),
        ),
      ],
    );
  }
}
