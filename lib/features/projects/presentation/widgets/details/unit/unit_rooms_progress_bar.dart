import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/features/home/domain/entities/unit_room_entity.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/core/theme/theme_extension.dart';

class UnitRoomsProgressBar extends StatelessWidget {
  final List<UnitRoomEntity> rooms;
  final Set<int> completedRoomIds;
  final void Function(int index)? onRoomSelected;

  const UnitRoomsProgressBar({
    super.key,
    required this.rooms,
    required this.completedRoomIds,
    this.onRoomSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (rooms.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'تقدم الغرف',
                  style: TextStyle(
                    fontSize: AppFonts.headlineSmall,
                    fontWeight: FontWeight.bold,
                    color: context.colors.textPrimary,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
                  decoration: BoxDecoration(
                    color: context.colors.gold.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.round),
                  ),
                  child: Text(
                    '${completedRoomIds.length} من ${rooms.length} (${(rooms.isEmpty ? 0 : (completedRoomIds.length / rooms.length * 100)).toInt()}%)',
                    style: TextStyle(
                      fontSize: AppFonts.labelMedium,
                      fontWeight: FontWeight.bold,
                      color: context.colors.gold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(rooms.length * 2 - 1, (index) {
                if (index.isOdd) {
                  // Connector line
                  final leftRoomIndex = index ~/ 2;
                  final rightRoomIndex = leftRoomIndex + 1;
                  final isLeftCompleted = completedRoomIds.contains(rooms[leftRoomIndex].id);
                  final isRightCompleted = completedRoomIds.contains(rooms[rightRoomIndex].id);
                  
                  // Line is gold if both connected rooms are completed, else grey.
                  // Alternatively, if left is completed, make it gold.
                  final isLineGold = isLeftCompleted && isRightCompleted;

                  return Container(
                    width: 40,
                    margin: const EdgeInsets.only(top: 14), // Align with center of 28px circle
                    height: 2,
                    color: isLineGold ? context.colors.gold : context.colors.border,
                  );
                } else {
                  // Step node
                  final roomIndex = index ~/ 2;
                  final room = rooms[roomIndex];
                  final isCompleted = completedRoomIds.contains(room.id);
                  
                  return GestureDetector(
                    onTap: () => onRoomSelected?.call(roomIndex),
                    child: _buildStepNode(
                      context,
                      title: room.name,
                      isCompleted: isCompleted,
                    ),
                  );
                }
              }),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
      ),
    );
  }

  Widget _buildStepNode(
    BuildContext context, {
    required String title,
    required bool isCompleted,
  }) {
    return SizedBox(
      width: 70, // Fixed width for centering text
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCompleted ? context.colors.gold : context.colors.background,
              border: Border.all(
                color: isCompleted ? context.colors.gold : context.colors.border,
                width: 2,
              ),
            ),
            child: Icon(
              FluentIcons.checkmark_12_filled,
              size: 16,
              color: isCompleted ? context.colors.white : context.colors.border,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: AppFonts.bodySmall,
              fontWeight: isCompleted ? FontWeight.bold : FontWeight.w600,
              color: isCompleted ? context.colors.textPrimary : context.colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
