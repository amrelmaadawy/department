import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import 'package:apartment/core/theme/app_colors.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/core/theme/app_spacing.dart';

class UnitFloorPlanViewer extends StatelessWidget {
  final String heroTag;

  const UnitFloorPlanViewer({super.key, required this.heroTag});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 280,
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // The image
          Hero(
            tag: heroTag,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              child: Image.asset(
                'assets/images/floor_plan.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
          // Interactive controls on bottom left
          Positioned(
            bottom: AppSpacing.md,
            left: AppSpacing.md,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadius.md),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  _buildIconButton(FluentIcons.zoom_out_24_regular, () {}),
                  const SizedBox(width: AppSpacing.xs),
                  _buildIconButton(FluentIcons.zoom_in_24_regular, () {}),
                  const SizedBox(width: AppSpacing.sm),
                  Container(width: 1, height: 20, color: AppColors.border),
                  const SizedBox(width: AppSpacing.sm),
                  InkWell(
                    onTap: () {},
                    child: Row(
                      children: [
                        const Icon(
                          FluentIcons.cube_24_regular,
                          size: 18,
                          color: AppColors.gold,
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          '3D',
                          style: TextStyle(
                            fontSize: AppFonts.labelMedium,
                            fontWeight: FontWeight.bold,
                            color: AppColors.gold,
                          ),
                        ),
                      ],
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

  Widget _buildIconButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Icon(icon, size: 20, color: AppColors.textSecondary),
      ),
    );
  }
}
