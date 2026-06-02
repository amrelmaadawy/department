import 'package:apartment/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/project_entity.dart';

class FeaturedProjectCard extends StatelessWidget {
  final ProjectEntity project;

  const FeaturedProjectCard({
    super.key,
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // Format price with commas
    final formattedPrice = project.startingPrice.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );

    return GestureDetector(
      onTap: () => context.push(AppRouter.projectDetails, extra: {'project': project, 'heroTag': 'featured_project_${project.id}'}),
      child: Container(
      width: 220,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkOverlay.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.md)),
              child: Hero(
                tag: 'project_image_${project.id}',
                child: Image.asset(
                  project.imagePath,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          
          // Details
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project.name,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: AppFonts.bodyMedium,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  project.location,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: AppFonts.bodySmall,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Text(
                      '${l10n.startsFrom} ',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: AppFonts.bodySmall,
                      ),
                    ),
                    Text(
                      '$formattedPrice ${l10n.sar}',
                      style: const TextStyle(
                        color: AppColors.gold,
                        fontSize: AppFonts.bodyMedium,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
