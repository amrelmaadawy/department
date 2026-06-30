import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:shimmer/shimmer.dart';
import 'package:apartment/core/theme/app_colors.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import 'package:apartment/core/widgets/app_cached_network_image.dart';
import 'package:apartment/features/projects/domain/entities/saved_design_entity.dart';

class SavedDesignDetailsContent extends StatelessWidget {
  final SavedDesignEntity design;

  const SavedDesignDetailsContent({super.key, required this.design});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImageViewer(context),
          const SizedBox(height: AppSpacing.xl),
          _buildDetailsCard(context),
          const SizedBox(height: AppSpacing.xxxl),
        ],
      ),
    );
  }

  Widget _buildImageViewer(BuildContext context) {
    return Container(
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
                errorWidget: (context, url, error) => const Center(
                  child: Icon(FluentIcons.image_off_24_regular, size: 48),
                ),
              ),
            ),
    );
  }

  Widget _buildDetailsCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.colors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: context.colors.border.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            design.name.isNotEmpty ? design.name : 'تصميم بدون اسم',
            style: TextStyle(
              fontSize: AppFonts.headlineSmall,
              fontWeight: FontWeight.bold,
              color: context.colors.textPrimary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
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
          if (design.style.isNotEmpty) ...[
            _buildDetailRow(context, 'النمط', design.style),
            const Divider(height: AppSpacing.xl),
          ],
          if (design.apartmentId > 0) ...[
            _buildDetailRow(context, 'رقم الشقة', design.apartmentId.toString()),
            const Divider(height: AppSpacing.xl),
          ],
          if (design.createdAt != null) ...[
            _buildDetailRow(
              context,
              'تاريخ التصميم',
              '${design.createdAt!.day}/${design.createdAt!.month}/${design.createdAt!.year}',
            ),
            const Divider(height: AppSpacing.xl),
          ],
          _buildDetailRow(context, 'التكلفة', '${design.totalCost.toStringAsFixed(0)} ريال', isPrimary: true),
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value, {bool isPrimary = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: AppFonts.bodyMedium,
            color: context.colors.textSecondary,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: isPrimary ? AppFonts.bodyLarge : AppFonts.bodyMedium,
              fontWeight: FontWeight.bold,
              color: isPrimary ? context.colors.primary : context.colors.textPrimary,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}
