import 'package:apartment/core/network/api_endpoints.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import 'package:apartment/features/packages/domain/entities/package_item_entity.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

class PackageMaterialItemWidget extends StatelessWidget {
  final PackageItemEntity item;

  const PackageMaterialItemWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final imageUrl = item.material.images.isNotEmpty
        ? '${ApiEndpoints.imageBaseUrl}${item.material.images.first}'
        : null;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: context.colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: context.colors.border.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: imageUrl != null
                ? CachedNetworkImage(
                    imageUrl: imageUrl,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                    placeholder: (ctx, url) => Container(
                      width: 56,
                      height: 56,
                      color: ctx.colors.border,
                    ),
                    errorWidget: (ctx, url, err) => _placeholderIcon(context),
                  )
                : _placeholderIcon(context),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.material.name,
                  style: TextStyle(
                    fontSize: AppFonts.bodyMedium,
                    fontWeight: FontWeight.w600,
                    color: context.colors.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${item.material.unit} · ${item.material.finalUnitPrice.toStringAsFixed(0)} ر.س',
                  style: TextStyle(
                    fontSize: AppFonts.bodySmall,
                    color: context.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholderIcon(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      color: context.colors.border.withValues(alpha: 0.5),
      child: Icon(
        FluentIcons.image_24_regular,
        color: context.colors.textSecondary,
      ),
    );
  }
}
