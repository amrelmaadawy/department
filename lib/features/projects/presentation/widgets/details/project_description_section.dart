import 'package:flutter/material.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import 'package:apartment/features/home/domain/entities/project_entity.dart';

class ProjectDescriptionSection extends StatelessWidget {
  final ProjectEntity project;

  const ProjectDescriptionSection({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    if (project.description.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'نظرة عامة', // Or any localized string like l10n.overview
            style: TextStyle(
              fontSize: AppFonts.headlineSmall,
              fontWeight: FontWeight.bold,
              color: context.colors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            project.description,
            style: TextStyle(
              fontSize: AppFonts.bodyLarge,
              color: context.colors.textSecondary,
              height: 1.6, // Good line height for readability
            ),
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }
}
