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
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            project.name,
            style: TextStyle(
              fontSize: AppFonts.displaySmall,
              fontWeight: FontWeight.bold,
              color: context.colors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                FluentIcons.location_16_regular,
                color: context.colors.textSecondary,
                size: 18,
              ),
              SizedBox(width: AppSpacing.xs),
              Text(
                project.location,
                style: TextStyle(
                  fontSize: AppFonts.bodyMedium,
                  color: context.colors.textSecondary,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }
}
