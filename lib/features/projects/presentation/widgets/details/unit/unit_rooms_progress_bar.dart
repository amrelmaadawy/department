import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/features/home/domain/entities/unit_room_entity.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import 'package:apartment/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class UnitRoomsProgressBar extends StatelessWidget {
  final List<UnitRoomEntity> rooms;
  final Set<int> completedRoomIds;
  final int currentRoomIndex;
  final Map<int, double> roomCosts;
  final void Function(int index)? onRoomSelected;
  final bool showHeader;

  const UnitRoomsProgressBar({
    super.key,
    required this.rooms,
    required this.completedRoomIds,
    this.currentRoomIndex = 0,
    this.roomCosts = const {},
    this.onRoomSelected,
    this.showHeader = true,
  });

  @override
  Widget build(BuildContext context) {
    if (rooms.isEmpty) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showHeader)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.roomsProgress,
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
          // Removed SizedBox to balance the new vertical padding in SingleChildScrollView
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(rooms.length * 2 - 1, (index) {
                if (index.isOdd) {
                  // Connector line
                  final leftRoomIndex = index ~/ 2;
                  final rightRoomIndex = leftRoomIndex + 1;
                  final isLeftCompleted = completedRoomIds.contains(rooms[leftRoomIndex].id);
                  final isRightCompleted = completedRoomIds.contains(rooms[rightRoomIndex].id);
                  
                  final isLineGold = isLeftCompleted && isRightCompleted;

                  return Container(
                    width: 30,
                    margin: const EdgeInsets.only(top: 10), 
                    height: 2,
                    color: isLineGold ? context.colors.gold : context.colors.border,
                  );
                } else {
                  // Step node
                  final roomIndex = index ~/ 2;
                  final room = rooms[roomIndex];
                  final isCompleted = completedRoomIds.contains(room.id);
                  final isCurrent = roomIndex == currentRoomIndex;
                  final cost = roomCosts[room.id] ?? 0.0;
                  
                  return GestureDetector(
                    onTap: () => onRoomSelected?.call(roomIndex),
                    child: _buildStepNode(
                      context,
                      title: room.name,
                      isCompleted: isCompleted,
                      isCurrent: isCurrent,
                      cost: cost,
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
    required bool isCurrent,
    required double cost,
  }) {
    final formatter = NumberFormat.compact();
    
    return SizedBox(
      width: 70, 
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            transform: Matrix4.diagonal3Values(isCurrent ? 1.1 : 1.0, isCurrent ? 1.1 : 1.0, 1.0),
            transformAlignment: Alignment.center,
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCompleted ? context.colors.gold : context.colors.background,
              border: Border.all(
                color: isCurrent 
                  ? context.colors.gold 
                  : isCompleted ? context.colors.gold : context.colors.border,
                width: isCurrent ? 3 : 2,
              ),
              boxShadow: isCurrent 
                ? [
                    BoxShadow(
                      color: context.colors.gold.withValues(alpha: 0.3),
                      blurRadius: 8,
                      spreadRadius: 2,
                    )
                  ]
                : [],
            ),
            child: Icon(
              FluentIcons.checkmark_12_filled,
              size: 12,
              color: isCompleted ? context.colors.white : Colors.transparent,
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
              fontWeight: isCompleted || isCurrent ? FontWeight.bold : FontWeight.w600,
              color: isCurrent 
                  ? context.colors.gold 
                  : isCompleted ? context.colors.textPrimary : context.colors.textSecondary,
            ),
          ),
          if (cost > 0) ...[
            const SizedBox(height: 2),
            Text(
              '+${formatter.format(cost)}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: context.colors.success,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
