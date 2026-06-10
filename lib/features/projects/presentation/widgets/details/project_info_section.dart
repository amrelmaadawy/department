import 'package:flutter/material.dart';
import 'package:apartment/l10n/app_localizations.dart';
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
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            project.name,
            style: TextStyle(
              fontSize: AppFonts.displaySmall,
              fontWeight: FontWeight.bold,
              color: context.colors.primary,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${l10n.startsFrom} ',
                style: TextStyle(
                  fontSize: AppFonts.headlineSmall,
                  fontWeight: FontWeight.bold,
                  color: context.colors.gold,
                ),
              ),
              Text(
                '$formattedPrice ${project.startingPrice >= 1000000 ? "" : l10n.sar}',
                style: TextStyle(
                  fontSize: AppFonts.headlineSmall,
                  fontWeight: FontWeight.bold,
                  color: context.colors.gold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
