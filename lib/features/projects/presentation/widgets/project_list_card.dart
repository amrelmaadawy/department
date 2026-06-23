import 'package:apartment/l10n/app_localizations.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:apartment/core/widgets/app_cached_network_image.dart';
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
        margin: const EdgeInsets.symmetric(
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
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.horizontal(
                    right: Radius.circular(AppRadius.md),
                  ),
                  child: Hero(
                    tag: 'list_project_${project.id}',
                    child: project.imagePath.isEmpty
                        ? Container(
                            width: imageWidth,
                            height: double.infinity,
                            color: context.colors.primary.withValues(alpha: 0.1),
                            child: Icon(Icons.image_not_supported,
                                color: context.colors.textSecondary, size: 30),
                          )
                        : project.imagePath.startsWith('http')
                            ? AppCachedNetworkImage(
                                imageUrl: Uri.encodeFull(project.imagePath),
                                width: imageWidth,
                                height: double.infinity,
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) =>
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
                if (project.images.length > 1)
                  Positioned(
                    top: AppSpacing.sm,
                    right: AppSpacing.sm,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
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
                            size: 12,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            '${project.images.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
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

            // Details (Trailing edge)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
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
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      children: [
                        Icon(FluentIcons.location_16_regular, size: 14, color: context.colors.textSecondary),
                        const SizedBox(width: AppSpacing.xs),
                        Expanded(
                          child: Text(
                            project.location,
                            style: TextStyle(
                              color: context.colors.textSecondary,
                              fontSize: AppFonts.bodySmall,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.apartment,
                              size: 16,
                              color: context.colors.textSecondary,
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Text(
                              AppLocalizations.of(context)!.projectUnitsCount(project.apartmentsCount),
                              style: TextStyle(
                                color: context.colors.textSecondary,
                                fontSize: AppFonts.bodySmall,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.straighten,
                              size: 16,
                              color: context.colors.textSecondary,
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Text(
                              '${project.buildingArea.toStringAsFixed(0)} م²',
                              style: TextStyle(
                                color: context.colors.textSecondary,
                                fontSize: AppFonts.bodySmall,
                              ),
                            ),
                          ],
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
