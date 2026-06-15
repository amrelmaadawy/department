import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_router.dart';

import '../../../../core/theme/theme_extension.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/project_entity.dart';

class FeaturedProjectCard extends StatelessWidget {
  final ProjectEntity project;

  const FeaturedProjectCard({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(
        AppRouter.projectDetails,
        extra: {
          'project': project,
          'heroTag': 'featured_project_${project.id}',
        },
      ),
      child: Container(
        width: 220,
        decoration: BoxDecoration(
          color: context.colors.white,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: context.colors.border),
          boxShadow: [
            BoxShadow(
              color: context.colors.darkOverlay.withValues(alpha: 0.03),
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
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(AppRadius.md),
                    ),
                    child: Hero(
                      tag: 'project_image_${project.id}',
                      child: project.imagePath.isEmpty
                          ? Container(
                              width: double.infinity,
                              color: context.colors.primary.withValues(alpha: 0.1),
                              child: Icon(Icons.image_not_supported,
                                  color: context.colors.textSecondary, size: 40),
                            )
                          : project.imagePath.startsWith('http')
                            ? Image.network(
                                Uri.encodeFull(project.imagePath),
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                    width: double.infinity,
                                    color: context.colors.primary
                                        .withValues(alpha: 0.1),
                                    child: Icon(Icons.broken_image,
                                        color: context.colors.textSecondary),
                                  ),
                                )
                              : Image.asset(
                                  project.imagePath,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                    ),
                  ),
                  if (project.images.length > 1)
                    Positioned(
                      top: AppSpacing.sm,
                      right: AppSpacing.sm,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.photo_library_outlined,
                              color: Colors.white,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${project.images.length}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                              textDirection: TextDirection.ltr,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Details
            Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.name,
                    style: TextStyle(
                      color: context.colors.textPrimary,
                      fontSize: AppFonts.bodyMedium,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    project.location,
                    style: TextStyle(
                      color: context.colors.textSecondary,
                      fontSize: AppFonts.bodySmall,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      Icon(
                        Icons.apartment,
                        size: 16,
                        color: context.colors.textSecondary,
                      ),
                      SizedBox(width: 4),
                      Text(
                        '${project.apartmentsCount} وحدات',
                        style: TextStyle(
                          color: context.colors.textSecondary,
                          fontSize: AppFonts.bodySmall,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      Icon(
                        Icons.straighten,
                        size: 16,
                        color: context.colors.textSecondary,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'مساحة البناء: ${project.buildingArea.toStringAsFixed(0)} م²',
                        style: TextStyle(
                          color: context.colors.textSecondary,
                          fontSize: AppFonts.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
