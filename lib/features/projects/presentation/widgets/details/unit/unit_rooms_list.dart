import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:shimmer/shimmer.dart';

import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/features/home/domain/entities/project_unit_entity.dart';
import 'package:apartment/features/home/domain/entities/unit_room_entity.dart';
import 'package:apartment/l10n/app_localizations.dart';
import 'package:apartment/core/theme/theme_extension.dart';

class UnitRoomsList extends StatelessWidget {
  final ProjectUnitEntity unit;
  final bool isLoading;

  const UnitRoomsList({
    super.key,
    required this.unit,
    this.isLoading = false,
  });

  Widget _buildShimmer(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;
    final highlightColor = isDark ? Colors.grey[700]! : Colors.grey[100]!;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 3,
        separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.sm),
        itemBuilder: (context, index) => Container(
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                FluentIcons.conference_room_24_filled,
                color: context.colors.primary,
                size: 24,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                l10n.roomsAndAreasDetails,
                style: TextStyle(
                  fontSize: AppFonts.headlineSmall,
                  fontWeight: FontWeight.bold,
                  color: context.colors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          if (isLoading)
            _buildShimmer(context)
          else if (unit.rooms.isEmpty)
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              width: double.infinity,
              decoration: BoxDecoration(
                color: context.colors.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(
                  color: context.colors.border,
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    FluentIcons.info_24_regular,
                    color: context.colors.primary,
                    size: 32,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    l10n.updatingRoomsDataSoon,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: AppFonts.bodyMedium,
                      color: context.colors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: unit.rooms.length,
              separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) {
                final room = unit.rooms[index];
                return _RoomItemCard(room: room);
              },
            ),
        ],
      ),
    );
  }
}

class _RoomItemCard extends StatelessWidget {
  final UnitRoomEntity room;

  const _RoomItemCard({required this.room});

  IconData _getRoomIcon(String type) {
    final t = type.toLowerCase();
    if (t.contains('bed') || t.contains('نوم')) {
      return FluentIcons.bed_24_regular;
    } else if (t.contains('bath') || t.contains('حمام')) {
      return FluentIcons.drop_24_regular;
    } else if (t.contains('kitchen') || t.contains('مطبخ')) {
      return FluentIcons.food_24_regular;
    } else if (t.contains('living') || t.contains('معيشة')) {
      return FluentIcons.tv_24_regular;
    } else if (t.contains('reception') || t.contains('استقبال')) {
      return FluentIcons.couch_24_regular;
    } else if (t.contains('balcony') || t.contains('بلكونة')) {
      return FluentIcons.weather_sunny_24_regular;
    }
    return FluentIcons.conference_room_24_regular;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    // Format area text
    String areaText = '';
    if (room.area > 0) {
      areaText = '${room.area.toStringAsFixed(1)} ${l10n.unitSqMeter}';
    } else {
      areaText = l10n.areaNotSpecified;
    }

    // Format dimensions
    String dimensionsText = '';
    if (room.length != null && room.width != null && room.length! > 0 && room.width! > 0) {
      dimensionsText = '${room.length!.toStringAsFixed(1)} × ${room.width!.toStringAsFixed(1)} ${l10n.unitSqMeter}';
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: context.colors.border,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: context.colors.primary.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getRoomIcon(room.type),
              color: context.colors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  room.name,
                  style: TextStyle(
                    fontSize: AppFonts.bodyLarge,
                    fontWeight: FontWeight.bold,
                    color: context.colors.textPrimary,
                  ),
                ),
                if (room.typeLabel.isNotEmpty && room.typeLabel != room.name) ...[
                  const SizedBox(height: 2),
                  Text(
                    room.typeLabel,
                    style: TextStyle(
                      fontSize: AppFonts.labelMedium,
                      color: context.colors.textSecondary,
                    ),
                  ),
                ]
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                areaText,
                style: TextStyle(
                  fontSize: AppFonts.bodyMedium,
                  fontWeight: FontWeight.w600,
                  color: context.colors.primary,
                ),
              ),
              if (dimensionsText.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  dimensionsText,
                  style: TextStyle(
                    fontSize: AppFonts.labelMedium,
                    color: context.colors.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
