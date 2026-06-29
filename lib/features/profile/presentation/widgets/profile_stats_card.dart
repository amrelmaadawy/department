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

  final String designsLabel;
  final String contractsLabel;
  final String unitsLabel;

  const ProfileStatsCard({
    super.key,
    required this.designsCount,
    required this.contractsCount,
    required this.unitsCount,
    required this.designsLabel,
    required this.contractsLabel,
    required this.unitsLabel,
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem(context, unitsCount, unitsLabel),
          _buildDivider(context),
          _buildStatItem(context, contractsCount, contractsLabel),
          _buildDivider(context),
          _buildStatItem(context, designsCount, designsLabel),
        ],
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, int count, String label) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: AppFonts.headlineMedium,
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
