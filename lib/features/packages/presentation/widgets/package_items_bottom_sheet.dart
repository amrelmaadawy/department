import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import 'package:apartment/core/network/api_endpoints.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import 'package:apartment/features/packages/domain/entities/finishing_package_entity.dart';
import 'package:apartment/features/packages/domain/entities/package_item_entity.dart';
import 'package:apartment/l10n/app_localizations.dart';

class PackageItemsBottomSheet extends StatelessWidget {
  final FinishingPackageEntity package;

  const PackageItemsBottomSheet({super.key, required this.package});

  static Future<void> show(
    BuildContext context,
    FinishingPackageEntity package,
  ) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PackageItemsBottomSheet(package: package),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final roomTypes = package.roomTypes;

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      expand: false,
      builder: (_, controller) {
        return Container(
          decoration: BoxDecoration(
            color: context.colors.background,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppRadius.xl),
            ),
          ),
          child: Column(
            children: [
              _buildHandle(context),
              _buildHeader(context, l10n),
              Expanded(
                child: ListView.builder(
                  controller: controller,
                  padding: const EdgeInsets.all(AppSpacing.md),
                  itemCount: roomTypes.length,
                  itemBuilder: (context, index) {
                    final roomType = roomTypes[index];
                    final items = package.itemsForRoom(roomType);
                    return _RoomMaterialsGroup(
                      roomType: roomType,
                      items: items,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHandle(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: AppSpacing.md),
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: context.colors.border,
          borderRadius: BorderRadius.circular(AppRadius.round),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.packageMaterialsTitle,
                  style: TextStyle(
                    fontSize: AppFonts.headlineMedium,
                    fontWeight: FontWeight.bold,
                    color: context.colors.textPrimary,
                  ),
                ),
                Text(
                  package.name,
                  style: TextStyle(
                    fontSize: AppFonts.bodyMedium,
                    color: context.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: context.colors.gold.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(
                color: context.colors.gold.withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              '${package.calculatedPrice.toStringAsFixed(0)} ر.س',
              style: TextStyle(
                fontSize: AppFonts.bodyLarge,
                fontWeight: FontWeight.bold,
                color: context.colors.gold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoomMaterialsGroup extends StatelessWidget {
  final String roomType;
  final List<PackageItemEntity> items;

  const _RoomMaterialsGroup({
    required this.roomType,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Row(
            children: [
              Icon(
                FluentIcons.home_24_filled,
                size: 16,
                color: context.colors.gold,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                _translateRoomType(roomType),
                style: TextStyle(
                  fontSize: AppFonts.bodyLarge,
                  fontWeight: FontWeight.bold,
                  color: context.colors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        ...items.map((item) => _MaterialItem(item: item)),
        const SizedBox(height: AppSpacing.md),
      ],
    );
  }

  String _translateRoomType(String type) {
    const translations = {
      'kitchen': 'المطبخ',
      'salon': 'الصالون',
      'bedroom': 'غرفة النوم',
      'bathroom': 'الحمام',
      'balcony': 'البلكونة',
      'living_room': 'غرفة المعيشة',
    };
    return translations[type] ?? type;
  }
}

class _MaterialItem extends StatelessWidget {
  final PackageItemEntity item;

  const _MaterialItem({required this.item});

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
