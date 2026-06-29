import 'package:apartment/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/theme_extension.dart';
import '../../../../../core/widgets/app_toast.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../cubit/save_design_cubit.dart';
import '../../cubit/save_design_state.dart';
import '../../cubit/share_design_cubit.dart' as import_share;
import '../../cubit/download_image_cubit.dart';
import '../../cubit/download_image_state.dart';

class AiRendersActionBar extends StatelessWidget {
  final int orderId;
  final String currentRenderUrl;

  const AiRendersActionBar({
    super.key,
    required this.orderId,
    required this.currentRenderUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Download Button
            BlocConsumer<DownloadImageCubit, DownloadImageState>(
              listener: (context, state) {
                if (state is DownloadImageSuccess) {
                  AppToast.showSuccess(context, state.message);
                } else if (state is DownloadImageError) {
                  AppToast.showError(context, state.message);
                }
              },
              builder: (context, state) {
                final isDownloading = state is DownloadImageLoading;
                return ElevatedButton(
                  onPressed: isDownloading ? null : () {
                    context.read<DownloadImageCubit>().downloadImage(
                      currentRenderUrl,
                      successMessage: AppLocalizations.of(context)!.aiRendersDownloadSuccess,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.colors.white,
                    foregroundColor: context.colors.textPrimary,
                    elevation: 0,
                    side: BorderSide(color: context.colors.border),
                    padding: const EdgeInsets.all(14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
                  ),
                  child: isDownloading 
                      ? SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: context.colors.textPrimary))
                      : const Icon(Icons.save_alt_outlined, size: 28),
                );
              },
            ),
            const SizedBox(width: AppSpacing.sm),
            
            // Share Button
            BlocConsumer<import_share.ShareDesignCubit, import_share.ShareDesignState>(
              listener: (context, state) {
                if (state is import_share.ShareDesignError) {
                  AppToast.showError(context, state.message);
                }
              },
              builder: (context, state) {
                final isSharing = state is import_share.ShareDesignLoading;
                return ElevatedButton(
                  onPressed: isSharing ? null : () {
                    context.read<import_share.ShareDesignCubit>().shareDesign(
                      imagePath: currentRenderUrl,
                      text: AppLocalizations.of(context)!.shareDesignText,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.colors.gold.withValues(alpha: 0.1),
                    foregroundColor: context.colors.gold,
                    elevation: 0,
                    padding: const EdgeInsets.all(14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
                  ),
                  child: isSharing 
                      ? SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: context.colors.gold))
                      : const Icon(FluentIcons.share_android_24_regular, size: 24),
                );
              },
            ),
            const SizedBox(width: AppSpacing.md),

            // Save Design Button
            Expanded(
              child: BlocConsumer<SaveDesignCubit, SaveDesignState>(
                listener: (context, state) {
                  if (state is SaveDesignSuccess) {
                    AppToast.showSuccess(context, 'تم حفظ التصميم بنجاح.');
                  } else if (state is SaveDesignError) {
                    AppToast.showError(context, state.message);
                  }
                },
                builder: (context, state) {
                  final isLoading = state is SaveDesignLoading;
                  return ElevatedButton.icon(
                    onPressed: isLoading
                        ? null
                        : () {
                            context.read<SaveDesignCubit>().saveDesign(
                                  orderId,
                                  currentRenderUrl,
                                );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.colors.primary,
                      foregroundColor: context.colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
                      elevation: 0,
                    ),
                    icon: isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.white),
                          )
                        : const Icon(FluentIcons.save_24_regular, size: 24),
                    label: Builder(
                      builder: (context) => Text(
                        isLoading
                            ? AppLocalizations.of(context)!.aiRendersSaving
                            : AppLocalizations.of(context)!.aiRendersSaveDesign,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
