import 'package:flutter/material.dart';
import 'package:apartment/l10n/app_localizations.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/core/theme/theme_extension.dart';

class ContractDetailsCard extends StatelessWidget {
  final Map<String, dynamic> unitData;

  const ContractDetailsCard({super.key, required this.unitData});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
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
          Text(
            l10n.unitAndProjectDetails,
            style: TextStyle(
              fontSize: AppFonts.bodyLarge,
              fontWeight: FontWeight.bold,
              color: context.colors.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Divider(color: context.colors.border, height: 1),
          const SizedBox(height: AppSpacing.md),
          _buildInfoRow(context, FluentIcons.building_24_regular, l10n.projectLabel, unitData['projectName']),
          const SizedBox(height: AppSpacing.md),
          _buildInfoRow(context, FluentIcons.home_24_regular, l10n.unitLabel, unitData['unitName']),
          const SizedBox(height: AppSpacing.md),
          _buildInfoRow(context, FluentIcons.calendar_ltr_24_regular, l10n.contractDateLabel, unitData['contractDate']),
          const SizedBox(height: AppSpacing.md),
          _buildInfoRow(context, FluentIcons.person_24_regular, l10n.ownerNameLabel, unitData['ownerName']),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: context.colors.background,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Icon(icon, size: 20, color: context.colors.gold),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: AppFonts.bodySmall,
                  color: context.colors.textSecondary,
                ),
              ),
              const SizedBox(height: 2), // Minor spacing, no const needed from AppSpacing
              Text(
                value,
                style: TextStyle(
                  fontSize: AppFonts.bodyMedium,
                  fontWeight: FontWeight.bold,
                  color: context.colors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
