import 'package:apartment/core/theme/app_radius.dart';
import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/features/home/domain/entities/project_entity.dart';
import 'package:apartment/core/theme/theme_extension.dart';

class ProjectInfoSection extends StatelessWidget {
  final ProjectEntity project;

  const ProjectInfoSection({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (project.isFeatured) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
              decoration: BoxDecoration(
                color: context.colors.gold.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: context.colors.gold.withValues(alpha: 0.5)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(FluentIcons.star_16_filled, color: context.colors.gold, size: 16),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    'مُميز',
                    style: TextStyle(
                      fontSize: AppFonts.labelMedium,
                      fontWeight: FontWeight.bold,
                      color: context.colors.gold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
          Text(
            project.name,
            style: TextStyle(
              fontSize: AppFonts.displaySmall,
              fontWeight: FontWeight.bold,
              color: context.colors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                FluentIcons.location_16_regular,
                color: context.colors.textSecondary,
                size: 18,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                project.location,
                style: TextStyle(
                  fontSize: AppFonts.bodyMedium,
                  color: context.colors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                FluentIcons.slide_size_20_regular,
                color: context.colors.textSecondary,
                size: 16,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'مساحة البناء: ${project.buildingArea.toStringAsFixed(0)} م²',
                style: TextStyle(
                  fontSize: AppFonts.bodyMedium,
                  color: context.colors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }
}
