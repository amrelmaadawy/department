import 'package:flutter/material.dart';
import 'package:apartment/l10n/app_localizations.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import 'package:apartment/core/theme/app_colors.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/features/home/domain/entities/project_entity.dart';

class ProjectInfoSection extends StatelessWidget {
  final ProjectEntity project;

  const ProjectInfoSection({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Format price beautifully
    String formattedPrice = '';
    if (project.startingPrice >= 1000000) {
      double millions = project.startingPrice / 1000000;
      formattedPrice = '${millions.toStringAsFixed(1)} ${l10n.million}';
    } else {
      formattedPrice = project.startingPrice
          .toStringAsFixed(0)
          .replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (Match m) => '${m[1]},',
          );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            project.name,
            style: const TextStyle(
              fontSize: AppFonts.displaySmall,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                FluentIcons.location_16_regular,
                color: AppColors.textSecondary,
                size: 18,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                project.location,
                style: const TextStyle(
                  fontSize: AppFonts.bodyMedium,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${l10n.startsFrom} ',
                style: const TextStyle(
                  fontSize: AppFonts.headlineSmall,
                  fontWeight: FontWeight.bold,
                  color: AppColors.gold,
                ),
              ),
              Text(
                '$formattedPrice ${project.startingPrice >= 1000000 ? "" : l10n.sar}',
                style: const TextStyle(
                  fontSize: AppFonts.headlineSmall,
                  fontWeight: FontWeight.bold,
                  color: AppColors.gold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
