import 'package:apartment/core/theme/app_colors.dart';
import 'package:apartment/features/projects/domain/entities/saved_design_entity.dart';
import 'package:apartment/features/projects/presentation/cubit/share_design_cubit.dart' as import_share;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extension.dart';
import '../cubit/profile_cubit.dart';
import 'package:apartment/core/utils/responsive_builder.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/widgets/app_toast.dart';
import 'saved_design_details_content.dart';

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
      backgroundColor: AppColors.transparent,
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    design.name.isNotEmpty ? design.name : 'تفاصيل التصميم المفضل',
                    style: TextStyle(
                      fontSize: AppFonts.headlineSmall,
                      fontWeight: FontWeight.bold,
                      color: context.colors.textPrimary,
                    ),
                    maxLines: 2,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(FluentIcons.heart_24_filled, color: AppColors.error),
                      onPressed: () {
                        final targetId = design.finishingOrderId > 0 ? design.finishingOrderId : design.id;
                        context.read<ProfileCubit>().toggleFavoriteDesign(
                          targetId,
                          design.imageUrls.isNotEmpty ? design.imageUrls.first : '',
                        );
                        Navigator.pop(context);
                      },
                    ),
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
            child: SavedDesignDetailsContent(design: design),
          ),
        ],
      ),
    );
  }
}
