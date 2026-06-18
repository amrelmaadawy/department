import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
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

class AiGalleryDetailsSheet extends StatelessWidget {
  final AiGalleryEntity item;
  final String heroTag;

  const AiGalleryDetailsSheet({
    super.key,
    required this.item,
    required this.heroTag,
  });

  static void show(BuildContext context, AiGalleryEntity item, String heroTag) {
    final profileCubit = context.read<ProfileCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) {
        return BlocProvider.value(
          value: profileCubit,
          child: AiGalleryDetailsSheet(item: item, heroTag: heroTag),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileCubit = context.read<ProfileCubit>();
    
    return Container(
      height: MediaQuery.of(context).size.height * 0.90,
      decoration: BoxDecoration(
        color: context.colors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: AppSpacing.md, bottom: AppSpacing.sm),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: context.colors.border,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'تفاصيل التصميم',
                    style: TextStyle(
                      fontSize: AppFonts.headlineSmall,
                      fontWeight: FontWeight.bold,
                      color: context.colors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  children: [
                    BlocBuilder<ProfileCubit, ProfileState>(
                      builder: (context, state) {
                        bool isFavorite = false;
                        if (state is ProfileLoaded) {
                          isFavorite = state.profile.savedDesigns.any((d) => d.id == item.orderId || (d.imageUrls.isNotEmpty && d.imageUrls.first == item.url));
                        }
                        return IconButton(
                          icon: Icon(
                            isFavorite ? FluentIcons.heart_24_filled : FluentIcons.heart_24_regular,
                            color: isFavorite ? Colors.red : context.colors.textSecondary,
                          ),
                          onPressed: () {
                            profileCubit.toggleFavoriteDesign(item.orderId, item.url);
                          },
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(FluentIcons.dismiss_24_regular, color: context.colors.textSecondary),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Interactive Image Viewer
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.xl),
                child: InteractiveViewer(
                  minScale: 1.0,
                  maxScale: 5.0,
                  child: Hero(
                    tag: heroTag,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: context.colors.border.withValues(alpha: 0.1),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: item.url,
                        fit: BoxFit.contain,
                        progressIndicatorBuilder: (context, url, progress) {
                          return Shimmer.fromColors(
                            baseColor: context.colors.border.withValues(alpha: 0.3),
                            highlightColor: context.colors.border.withValues(alpha: 0.1),
                            child: Container(color: Colors.white),
                          );
                        },
                        errorWidget: (context, url, error) => Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(FluentIcons.image_off_24_regular, size: 48, color: context.colors.textSecondary.withValues(alpha: 0.5)),
                              const SizedBox(height: AppSpacing.sm),
                              Text('الصورة غير متوفرة', style: TextStyle(color: context.colors.textSecondary)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          // Details Card
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: context.colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 15,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(color: context.colors.border.withValues(alpha: 0.2)),
                ),
                child: Column(
                  children: [
                    _buildDetailRow(context, 'اسم الغرفة', item.roomName.isNotEmpty ? item.roomName : 'بدون اسم'),
                    const Divider(height: AppSpacing.xl),
                    if (item.projectName.isNotEmpty) ...[
                      _buildDetailRow(context, 'المشروع', item.projectName),
                      const Divider(height: AppSpacing.xl),
                    ],
                    if (item.unitName.isNotEmpty) ...[
                      _buildDetailRow(context, 'الوحدة', item.unitName),
                      const Divider(height: AppSpacing.xl),
                    ],
                    _buildDetailRow(context, 'رقم الطلب', '#${item.orderId}', isPrimary: true),
                    const Divider(height: AppSpacing.xl),
                    _buildDetailRow(context, 'تاريخ الإنشاء', item.createdAt != null ? '${item.createdAt!.day}/${item.createdAt!.month}/${item.createdAt!.year}' : 'غير متوفر'),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value, {bool isPrimary = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: AppFonts.bodyLarge,
            color: context.colors.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isPrimary ? AppFonts.headlineSmall : AppFonts.bodyLarge,
            fontWeight: FontWeight.bold,
            color: isPrimary ? context.colors.primary : context.colors.textPrimary,
          ),
        ),
      ],
    );
  }
}
