import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import 'package:apartment/features/home/domain/entities/unit_room_entity.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RoomSelectionBottomSheet extends StatefulWidget {
  final List<UnitRoomEntity> availableRooms;
  final Function(List<int> selectedRoomIds) onApply;

  const RoomSelectionBottomSheet({
    super.key,
    required this.availableRooms,
    required this.onApply,
  });

  @override
  State<RoomSelectionBottomSheet> createState() => _RoomSelectionBottomSheetState();
}

class _RoomSelectionBottomSheetState extends State<RoomSelectionBottomSheet> {
  final Set<int> _selectedIds = {};

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'تحديد الغرف',
                  style: TextStyle(
                    fontSize: AppFonts.headlineSmall,
                    fontWeight: FontWeight.bold,
                    color: context.colors.textPrimary,
                  ),
                ),
                IconButton(
                  onPressed: () => context.pop(),
                  icon: Icon(FluentIcons.dismiss_24_regular, color: context.colors.textPrimary),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          
          // List of Rooms
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              itemCount: widget.availableRooms.length,
              itemBuilder: (context, index) {
                final room = widget.availableRooms[index];
                final isSelected = _selectedIds.contains(room.id);
                return CheckboxListTile(
                  value: isSelected,
                  onChanged: (val) {
                    setState(() {
                      if (val == true) {
                        _selectedIds.add(room.id);
                      } else {
                        _selectedIds.remove(room.id);
                      }
                    });
                  },
                  activeColor: context.colors.primary,
                  title: Text(
                    room.name,
                    style: TextStyle(
                      fontSize: AppFonts.bodyMedium,
                      fontWeight: FontWeight.bold,
                      color: context.colors.textPrimary,
                    ),
                  ),
                  subtitle: room.typeLabel != room.name ? Text(
                    room.typeLabel,
                    style: TextStyle(
                      fontSize: AppFonts.labelSmall,
                      color: context.colors.textSecondary,
                    ),
                  ) : null,
                  secondary: Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: context.colors.primary.withValues(alpha: 0.05),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getIconForRoomType(room.type),
                      color: context.colors.gold,
                      size: 20,
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Action Buttons
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _selectedIds.isEmpty
                        ? null
                        : () {
                            widget.onApply(_selectedIds.toList());
                            context.pop();
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.colors.primary,
                      foregroundColor: context.colors.white,
                      disabledBackgroundColor: context.colors.border,
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                    ),
                    child: const Text(
                      'تطبيق الخامة',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
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
