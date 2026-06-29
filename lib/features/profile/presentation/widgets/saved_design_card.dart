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
              color: AppColors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: context.colors.border.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
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
                  : const Icon(FluentIcons.image_24_regular),
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
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  if (design.projectName.isNotEmpty)
                    Text(
                      '${design.projectName} - ${design.unitName.isNotEmpty ? design.unitName : "غير محدد"}',
                      style: TextStyle(
                        fontSize: AppFonts.labelMedium,
                        color: context.colors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'النمط: ${design.style.isNotEmpty ? design.style : "غير محدد"}',
                    style: TextStyle(
                      fontSize: AppFonts.bodyMedium,
                      color: context.colors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Toggle Favorite Button
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
}
