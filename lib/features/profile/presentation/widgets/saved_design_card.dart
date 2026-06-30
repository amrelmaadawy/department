import 'package:apartment/core/theme/app_colors.dart';
import 'package:apartment/features/projects/domain/entities/saved_design_entity.dart';
import 'package:flutter/material.dart';
import 'package:apartment/core/widgets/app_cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extension.dart';
import '../cubit/profile_cubit.dart';
import 'saved_design_details_sheet.dart';

class SavedDesignCard extends StatelessWidget {
  final SavedDesignEntity design;

  const SavedDesignCard({
    super.key,
    required this.design,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        SavedDesignDetailsSheet.show(context, design);
      },
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: context.colors.white,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.04),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: context.colors.border.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 95,
              height: 95,
              decoration: BoxDecoration(
                color: context.colors.background,
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: design.imageUrls.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      child: AppCachedNetworkImage(
                        imageUrl: design.imageUrls.first,
                        fit: BoxFit.cover,
                        progressIndicatorBuilder: (context, url, progress) {
                          return Shimmer.fromColors(
                            baseColor: context.colors.border.withValues(alpha: 0.5),
                            highlightColor: context.colors.border.withValues(alpha: 0.1),
                            child: Container(color: AppColors.white),
                          );
                        },
                        errorWidget: (context, url, error) => const Icon(FluentIcons.image_off_24_regular),
                      ),
                    )
                  : const Icon(FluentIcons.image_24_regular, size: 32),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    design.name.isNotEmpty ? design.name : 'تصميم بدون اسم',
                    style: TextStyle(
                      fontSize: AppFonts.bodyLarge,
                      fontWeight: FontWeight.bold,
                      color: context.colors.textPrimary,
                      height: 1.3,
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: AppSpacing.xs,
                    runSpacing: AppSpacing.xs,
                    children: [
                      if (design.projectName.isNotEmpty)
                        _buildBadge(
                          context,
                          FluentIcons.building_home_16_regular,
                          '${design.projectName}${design.unitName.isNotEmpty ? " - ${design.unitName}" : ""}',
                        ),
                      if (design.style.isNotEmpty)
                        _buildBadge(
                          context,
                          FluentIcons.color_fill_16_regular,
                          design.style,
                        ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(
                FluentIcons.heart_24_filled,
                color: AppColors.error,
              ),
              onPressed: () {
                final targetId = design.finishingOrderId > 0 ? design.finishingOrderId : design.id;
                context.read<ProfileCubit>().toggleFavoriteDesign(
                      targetId,
                      design.imageUrls.isNotEmpty ? design.imageUrls.first : '',
                    );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(BuildContext context, IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: context.colors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.round),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: context.colors.primary),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: AppFonts.bodySmall,
                fontWeight: FontWeight.w600,
                color: context.colors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
