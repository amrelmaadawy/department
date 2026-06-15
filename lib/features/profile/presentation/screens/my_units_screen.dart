import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';

import '../../../../l10n/app_localizations.dart';
import 'package:apartment/core/theme/theme_extension.dart';


class MyUnitsScreen extends StatelessWidget {
  const MyUnitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    // Mock Data for VIP Units
    final List<Map<String, dynamic>> myUnits = [
      {
        'projectName': 'The Pearl Resort',
        'unitName': 'Unit A1',
        'status': l10n.statusFinishing,
        'progress': 0.65, // 65% completed
        'image': null,
      },
      {
        'projectName': 'Downtown Heights',
        'unitName': 'Duplex 202',
        'status': l10n.statusDelivered,
        'progress': 1.0,
        'image': null,
      },
    ];

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: context.colors.white,
        elevation: 0,
        scrolledUnderElevation: 0.0,
        title: Text(
          l10n.profileMenuMyUnits,
          style: TextStyle(
            color: context.colors.textPrimary,
            fontSize: AppFonts.headlineSmall,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(FluentIcons.ios_arrow_rtl_24_regular, color: context.colors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(AppSpacing.xl),
        itemCount: myUnits.length,
        separatorBuilder: (context, index) => SizedBox(height: AppSpacing.lg),
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
        color: context.colors.white,
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
                  color: context.colors.border,
                  child: unit['image'] != null ? Image.asset(
                    unit['image'],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      FluentIcons.building_24_regular,
                      size: 40,
                      color: context.colors.textSecondary,
                    ),
                  ) : Center(child: Icon(FluentIcons.home_24_regular, size: 40, color: context.colors.textSecondary)),
                ),
                // Status Badge
                Positioned(
                  top: AppSpacing.sm,
                  right: AppSpacing.sm,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: isCompleted ? context.colors.success.withValues(alpha: 0.9) : context.colors.gold.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(AppRadius.round),
                    ),
                    child: Text(
                      unit['status'],
                      style: TextStyle(
                        color: context.colors.white,
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
            padding: EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  unit['projectName'],
                  style: TextStyle(
                    color: context.colors.gold,
                    fontSize: AppFonts.bodyMedium,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: AppSpacing.xs),
                Text(
                  unit['unitName'],
                  style: TextStyle(
                    color: context.colors.textPrimary,
                    fontSize: AppFonts.bodyLarge,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                SizedBox(height: AppSpacing.lg),
                
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
                          backgroundColor: isCompleted ? context.colors.success : context.colors.primary,
                          foregroundColor: context.colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.lg),
                          ),
                          padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                        ),
                      ),
                    ),
                    SizedBox(width: AppSpacing.md),
                    OutlinedButton.icon(
                      onPressed: () {
                        context.push('/unit-contract');
                      },
                      icon: Icon(FluentIcons.document_pdf_24_regular, size: 20),
                      label: Text(l10n.contractBtn),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: context.colors.textPrimary,
                        side: BorderSide(color: context.colors.border),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                        ),
                        padding: EdgeInsets.symmetric(vertical: AppSpacing.md, horizontal: AppSpacing.lg),
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
