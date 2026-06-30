import 'package:flutter/material.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import 'package:apartment/features/packages/domain/entities/finishing_package_entity.dart';
import 'package:apartment/features/packages/domain/utils/room_type_helper.dart';
import 'package:apartment/l10n/app_localizations.dart';

class PackageCardRooms extends StatelessWidget {
  final FinishingPackageEntity package;

  const PackageCardRooms({super.key, required this.package});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.packageMaterialsTitle,
            style: TextStyle(
              fontSize: AppFonts.bodyLarge,
              fontWeight: FontWeight.bold,
              color: context.colors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: package.roomTypes.map((roomType) {
              final count = package.itemsForRoom(roomType).length;
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: context.colors.background,
                  borderRadius: BorderRadius.circular(AppRadius.round),
                  border: Border.all(color: context.colors.border),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      RoomTypeHelper.getIcon(roomType),
                      size: 16,
                      color: context.colors.textSecondary,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      '${RoomTypeHelper.translate(roomType)} ($count)',
                      style: TextStyle(
                        fontSize: AppFonts.bodySmall,
                        fontWeight: FontWeight.w600,
                        color: context.colors.textPrimary,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
