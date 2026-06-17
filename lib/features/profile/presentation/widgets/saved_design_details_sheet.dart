import 'package:apartment/features/projects/domain/entities/saved_design_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extension.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../../core/di/injection_container.dart';
import '../cubit/profile_cubit.dart';
import '../../../projects/presentation/cubit/share_design_cubit.dart' as import_share;
import '../../../../../l10n/app_localizations.dart';
import 'package:apartment/core/utils/responsive_builder.dart';

class SavedDesignDetailsSheet extends StatelessWidget {
  final SavedDesignEntity design;

  const SavedDesignDetailsSheet({
    super.key,
    required this.design,
  });

  static void show(BuildContext context, SavedDesignEntity design) {
    final profileCubit = context.read<ProfileCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      constraints: BoxConstraints(
        maxWidth: context.maxContainerWidth,
      ),
      builder: (bottomSheetContext) {
        return BlocProvider.value(
          value: profileCubit,
          child: SavedDesignDetailsSheet(design: design),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
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
              margin: const EdgeInsets.only(top: AppSpacing.md, bottom: AppSpacing.lg),
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
                    'تفاصيل التصميم المفضل',
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
                    IconButton(
                      icon: const Icon(FluentIcons.heart_24_filled, color: Colors.red),
                      onPressed: () {
                        final targetId = design.finishingOrderId > 0 ? design.finishingOrderId : design.id;
                        context.read<ProfileCubit>().toggleFavoriteDesign(
                          targetId,
                          design.imageUrls.isNotEmpty ? design.imageUrls.first : '',
                        );
                        Navigator.pop(context);
                      },
                    ),
                    /*
                      if (design.imageUrls.isNotEmpty)
                        BlocProvider(
                          create: (context) => sl<import_share.ShareDesignCubit>(),
                          child: BlocConsumer<import_share.ShareDesignCubit, import_share.ShareDesignState>(
                            listener: (context, state) {
                              if (state is import_share.ShareDesignError) {
                                AppToast.showError(context, state.message);
                              }
                            },
                            builder: (context, state) {
                              final isSharing = state is import_share.ShareDesignLoading;
                              return IconButton(
                                icon: isSharing
                                    ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: context.colors.textSecondary))
                                    : Icon(FluentIcons.share_android_24_regular, color: context.colors.textSecondary),
                                onPressed: isSharing ? null : () {
                                  context.read<import_share.ShareDesignCubit>().shareDesign(
                                    imagePath: design.imageUrls.first,
                                    text: AppLocalizations.of(context)!.shareDesignText,
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      */
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

          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image Viewer
                  Container(
                    height: 300,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.xl),
                      color: context.colors.border.withValues(alpha: 0.1),
                    ),
                    child: design.imageUrls.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(FluentIcons.image_24_regular, size: 48, color: context.colors.textSecondary.withValues(alpha: 0.5)),
                                const SizedBox(height: AppSpacing.sm),
                                Text('الصورة غير متوفرة', style: TextStyle(color: context.colors.textSecondary)),
                              ],
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(AppRadius.xl),
                            child: Image.network(
                              design.imageUrls.first,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, progress) {
                                if (progress == null) return child;
                                return Shimmer.fromColors(
                                  baseColor: context.colors.border.withValues(alpha: 0.5),
                                  highlightColor: context.colors.border.withValues(alpha: 0.1),
                                  child: Container(color: Colors.white),
                                );
                              },
                              errorBuilder: (context, _, _) => const Center(
                                child: Icon(FluentIcons.image_off_24_regular, size: 48),
                              ),
                            ),
                          ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),

                  // Details Card
                  Container(
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
                        _buildDetailRow(context, 'اسم التصميم', design.name.isNotEmpty ? design.name : 'بدون اسم'),
                        const Divider(height: AppSpacing.xl),
                        if (design.projectName.isNotEmpty) ...[
                          _buildDetailRow(context, 'المشروع', design.projectName),
                          const Divider(height: AppSpacing.xl),
                        ],
                        if (design.unitName.isNotEmpty) ...[
                          _buildDetailRow(context, 'الوحدة', design.unitName),
                          const Divider(height: AppSpacing.xl),
                        ],
                        if (design.roomName.isNotEmpty) ...[
                          _buildDetailRow(context, 'الغرفة', design.roomName),
                          const Divider(height: AppSpacing.xl),
                        ],
                        _buildDetailRow(context, 'النمط', design.style.isNotEmpty ? design.style : 'غير محدد'),
                        const Divider(height: AppSpacing.xl),
                        _buildDetailRow(context, 'رقم الشقة', design.apartmentId.toString()),
                        const Divider(height: AppSpacing.xl),
                        if (design.createdAt != null) ...[
                          _buildDetailRow(context, 'تاريخ التصميم', '${design.createdAt!.day}/${design.createdAt!.month}/${design.createdAt!.year}'),
                          const Divider(height: AppSpacing.xl),
                        ],
                        _buildDetailRow(context, 'التكلفة', '${design.totalCost.toStringAsFixed(0)} ريال', isPrimary: true),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxxl),
                ],
              ),
            ),
          ),
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
            fontSize: AppFonts.bodyMedium,
            color: context.colors.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isPrimary ? AppFonts.bodyLarge : AppFonts.bodyMedium,
            fontWeight: FontWeight.bold,
            color: isPrimary ? context.colors.primary : context.colors.textPrimary,
          ),
        ),
      ],
    );
  }
}
