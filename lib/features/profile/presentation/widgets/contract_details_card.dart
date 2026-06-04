import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';

class ContractDetailsCard extends StatelessWidget {
  final Map<String, dynamic> unitData;

  const ContractDetailsCard({super.key, required this.unitData});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.5),
        ),
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'تفاصيل الوحدة والمشروع',
            style: TextStyle(
              fontSize: AppFonts.bodyLarge,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: AppSpacing.md),
          _buildInfoRow(FluentIcons.building_24_regular, 'المشروع', unitData['projectName']),
          const SizedBox(height: AppSpacing.md),
          _buildInfoRow(FluentIcons.home_24_regular, 'الوحدة', unitData['unitName']),
          const SizedBox(height: AppSpacing.md),
          _buildInfoRow(FluentIcons.calendar_ltr_24_regular, 'تاريخ التعاقد', unitData['contractDate']),
          const SizedBox(height: AppSpacing.md),
          _buildInfoRow(FluentIcons.person_24_regular, 'اسم المالك', unitData['ownerName']),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Icon(icon, size: 20, color: AppColors.gold),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: AppFonts.bodySmall,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 2), // Minor spacing, no const needed from AppSpacing
              Text(
                value,
                style: const TextStyle(
                  fontSize: AppFonts.bodyMedium,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
