import 'package:apartment/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/theme_extension.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';


class ProfileStatsCard extends StatelessWidget {
  final int designsCount;
  final int contractsCount;
  final int unitsCount;
  final double totalSpent;

  final String designsLabel;
  final String contractsLabel;
  final String unitsLabel;
  final String totalSpentLabel;

  const ProfileStatsCard({
    super.key,
    required this.designsCount,
    required this.contractsCount,
    required this.unitsCount,
    required this.totalSpent,
    required this.designsLabel,
    required this.contractsLabel,
    required this.unitsLabel,
    required this.totalSpentLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.colors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.08),
            blurRadius: 24,
            spreadRadius: -4,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem(context, totalSpent, totalSpentLabel, isCurrency: true),
              _buildDivider(context),
              _buildStatItem(context, unitsCount, unitsLabel),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Divider(color: context.colors.border.withValues(alpha: 0.5), height: 32),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem(context, contractsCount, contractsLabel),
              _buildDivider(context),
              _buildStatItem(context, designsCount, designsLabel),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, num count, String label, {bool isCurrency = false}) {
    String displayValue = isCurrency 
        ? '${count.toStringAsFixed(0)} ر.س' 
        : count.toString();

    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            displayValue,
            style: TextStyle(
              fontSize: isCurrency ? AppFonts.headlineSmall : AppFonts.headlineMedium,
              fontWeight: FontWeight.w800,
              color: context.colors.gold,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            style: TextStyle(
              fontSize: AppFonts.bodyMedium,
              fontWeight: FontWeight.w600,
              color: context.colors.textPrimary.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Container(
      height: 40,
      width: 1,
      color: context.colors.border.withValues(alpha: 0.5),
    );
  }
}
