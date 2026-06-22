import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/theme/app_fonts.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/theme_extension.dart';
import '../../../../../home/domain/entities/unit_room_entity.dart';
import 'package:apartment/l10n/app_localizations.dart';

class RoomOverviewCard extends StatelessWidget {
  final UnitRoomEntity room;

  const RoomOverviewCard({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: context.colors.primary.withValues(alpha: 0.05),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getIconForRoomType(room.type),
                  color: context.colors.gold,
                  size: 24,
                ),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      room.name,
                      style: TextStyle(
                        fontSize: AppFonts.headlineSmall,
                        fontWeight: FontWeight.bold,
                        color: context.colors.textPrimary,
                      ),
                    ),
                    if (room.typeLabel != room.name && room.typeLabel.isNotEmpty)
                      Text(
                        room.typeLabel,
                        style: TextStyle(
                          fontSize: AppFonts.bodyMedium,
                          color: context.colors.textSecondary,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                context,
                icon: Icons.aspect_ratio,
                label: l10n.roomArea,
                value: room.area > 0 ? '${room.area} م²' : l10n.areaNotSpecified,
              ),
              if (room.length != null && room.width != null) ...[
                Container(
                  width: 1,
                  height: 40,
                  color: context.colors.border,
                ),
                _buildStatItem(
                  context,
                  icon: Icons.straighten,
                  label: l10n.roomDimensions,
                  value: '${room.length} × ${room.width} م',
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: context.colors.primary,
          size: 24,
        ),
        SizedBox(height: AppSpacing.sm),
        Text(
          label,
          style: TextStyle(
            fontSize: AppFonts.labelSmall,
            color: context.colors.textSecondary,
          ),
        ),
        SizedBox(height: AppSpacing.xs),
        Text(
          value,
          style: TextStyle(
            fontSize: AppFonts.bodyLarge,
            fontWeight: FontWeight.bold,
            color: context.colors.textPrimary,
          ),
        ),
      ],
    );
  }

  IconData _getIconForRoomType(String type) {
    switch (type) {
      case 'bedroom':
        return FluentIcons.bed_24_regular;
      case 'bathroom':
        return FluentIcons.drop_24_regular;
      case 'kitchen':
        return FluentIcons.food_24_regular;
      case 'living_room':
        return FluentIcons.tv_24_regular;
      case 'men_majlis':
      case 'women_majlis':
        return FluentIcons.conference_room_24_regular;
      case 'laundry':
        return FluentIcons.weather_blowing_snow_24_regular;
      case 'entrance':
        return FluentIcons.door_arrow_left_24_regular;
      default:
        return FluentIcons.building_24_regular;
    }
  }
}
