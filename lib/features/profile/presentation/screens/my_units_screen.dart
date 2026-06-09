import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';

import '../../../../l10n/app_localizations.dart';

class MyUnitsScreen extends StatelessWidget {
  const MyUnitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    // Mock Data for VIP Units
    final List<Map<String, dynamic>> myUnits = [
      {
        'projectName': 'The Pearl Resort',
        'unitName': l10n.mockUnitName,
        'status': l10n.statusFinishing,
        'progress': 0.65, // 65% completed
        'image': 'assets/images/unit_villa.png',
      },
      {
        'projectName': 'Downtown Heights',
        'unitName': l10n.mockUnitDuplex,
        'status': l10n.statusDelivered,
        'progress': 1.0,
        'image': 'assets/images/unit_duplex.png',
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0.0,
        title: Text(
          l10n.profileMenuMyUnits,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: AppFonts.headlineSmall,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(FluentIcons.ios_arrow_rtl_24_regular, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.xl),
        itemCount: myUnits.length,
        separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.lg),
        itemBuilder: (context, index) {
          final unit = myUnits[index];
          return _buildUnitCard(context, unit, l10n);
        },
      ),
    );
  }

  Widget _buildUnitCard(BuildContext context, Map<String, dynamic> unit, AppLocalizations l10n) {
    final bool isCompleted = unit['progress'] == 1.0;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Header
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
            child: Stack(
              children: [
                // Fallback icon if image is missing, wrapped in placeholder
                Container(
                  height: 160,
                  width: double.infinity,
                  color: AppColors.border,
                  child: Image.asset(
                    unit['image'],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      FluentIcons.building_24_regular,
                      size: 40,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                // Status Badge
                Positioned(
                  top: AppSpacing.sm,
                  right: AppSpacing.sm,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: isCompleted ? AppColors.success.withValues(alpha: 0.9) : AppColors.gold.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(AppRadius.round),
                    ),
                    child: Text(
                      unit['status'],
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: AppFonts.bodySmall,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Details
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  unit['projectName'],
                  style: const TextStyle(
                    color: AppColors.gold,
                    fontSize: AppFonts.bodyMedium,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  unit['unitName'],
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: AppFonts.bodyLarge,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: AppSpacing.lg),
                
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (!isCompleted) {
                            context.push('/unit-progress');
                          }
                        },
                        icon: Icon(
                          isCompleted ? FluentIcons.checkmark_24_regular : FluentIcons.data_trending_24_regular,
                          size: 20,
                        ),
                        label: Text(isCompleted ? l10n.statusDelivered : l10n.trackFinishing),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isCompleted ? AppColors.success : AppColors.primary,
                          foregroundColor: AppColors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.lg),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    OutlinedButton.icon(
                      onPressed: () {
                        context.push('/unit-contract');
                      },
                      icon: const Icon(FluentIcons.document_pdf_24_regular, size: 20),
                      label: Text(l10n.contractBtn),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textPrimary,
                        side: const BorderSide(color: AppColors.border),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md, horizontal: AppSpacing.lg),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
