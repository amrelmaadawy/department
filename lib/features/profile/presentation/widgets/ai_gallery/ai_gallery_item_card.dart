import 'package:apartment/core/theme/app_colors.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:apartment/core/widgets/app_cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../core/theme/app_fonts.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/theme_extension.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../domain/entities/ai_gallery_entity.dart';
import '../../cubit/profile_cubit.dart';
import '../../cubit/profile_state.dart';

class AiGalleryItemCard extends StatelessWidget {
  final AiGalleryEntity item;
  final VoidCallback onTap;
  final String heroTag;

  const AiGalleryItemCard({
    super.key,
    required this.item,
    required this.onTap,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    final profileCubit = context.read<ProfileCubit>();
    final state = profileCubit.state;
    bool isFavorite = false;
    
    if (state is ProfileLoaded) {
      isFavorite = state.profile.savedDesigns.any((d) => d.id == item.orderId || (d.imageUrls.isNotEmpty && d.imageUrls.first == item.url));
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.08),
              blurRadius: 15,
              spreadRadius: -2,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Hero(
                tag: heroTag,
                child: AppCachedNetworkImage(
                  imageUrl: item.url,
                  fit: BoxFit.cover,
                  progressIndicatorBuilder: (context, url, progress) {
                    return Shimmer.fromColors(
                      baseColor: context.colors.border.withValues(alpha: 0.3),
                      highlightColor: context.colors.border.withValues(alpha: 0.1),
                      child: Container(color: AppColors.white),
                    );
                  },
                  errorWidget: (context, url, error) => Container(
                    color: context.colors.border.withValues(alpha: 0.2),
                    child: Center(
                      child: Icon(FluentIcons.image_off_24_regular, color: context.colors.textSecondary),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColors.black.withValues(alpha: 0.4),
                      ),
                      child: Text(
                        item.roomName.isNotEmpty ? item.roomName : 'غرفة بدون اسم',
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: AppFonts.bodyMedium,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: AppSpacing.xs,
                right: AppSpacing.xs,
                child: IconButton(
                  icon: Icon(
                    isFavorite ? FluentIcons.heart_24_filled : FluentIcons.heart_24_regular,
                    color: isFavorite ? AppColors.error : AppColors.white,
                    shadows: [
                      Shadow(
                        color: AppColors.black.withValues(alpha: 0.5),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  onPressed: () {
                    profileCubit.toggleFavoriteDesign(item.orderId, item.url);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
