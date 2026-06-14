import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_router.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../home/domain/entities/project_entity.dart';
import 'package:apartment/core/theme/theme_extension.dart';

class ProjectListCard extends StatelessWidget {
  final ProjectEntity project;

  const ProjectListCard({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // Calculate responsive sizes instead of hardcoded values.
    // 30% of screen width keeps it proportional across devices.
    // Clamp prevents it from getting too large on tablets or too small on tiny phones.
    final double cardHeight = (screenWidth * 0.3).clamp(110.0, 160.0);
    final double imageWidth = cardHeight;

    return GestureDetector(
      onTap: () => context.push(
        AppRouter.projectDetails,
        extra: {'project': project, 'heroTag': 'list_project_${project.id}'},
      ),
      child: Container(
        height: cardHeight,
        margin: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: context.colors.white,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: context.colors.border),
          boxShadow: [
            BoxShadow(
              color: context.colors.darkOverlay.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Image (Leading edge - RTL compliant)
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                right: Radius.circular(AppRadius.md),
              ),
              child: Hero(
                tag: 'list_project_${project.id}',
                child: project.imagePath.startsWith('http')
                    ? Image.network(
                        project.imagePath,
                        width: imageWidth,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Container(
                          width: imageWidth,
                          height: double.infinity,
                          color: context.colors.primary.withValues(alpha: 0.1),
                          child: Icon(Icons.broken_image,
                              color: context.colors.textSecondary),
                        ),
                      )
                    : Image.asset(
                        project.imagePath,
                        width: imageWidth,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
              ),
            ),

            // Details (Trailing edge)
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
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
                    SizedBox(height: 4),
                    Text(
                      project.location,
                      style: TextStyle(
                        color: context.colors.textSecondary,
                        fontSize: AppFonts.bodySmall,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Spacer(),
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
