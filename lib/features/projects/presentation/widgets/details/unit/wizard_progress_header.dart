import 'package:apartment/core/theme/app_colors.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import 'package:apartment/features/home/domain/entities/project_unit_entity.dart';
import 'package:apartment/l10n/app_localizations.dart';

import 'unit_rooms_progress_bar.dart';

class WizardProgressHeader extends StatelessWidget {
  final ProjectUnitEntity currentUnit;
  final Set<int> completedRoomIds;
  final int currentRoomIndex;
  final Map<int, double> roomCosts;
  final void Function(int) onRoomSelected;
  final VoidCallback onBack;

  const WizardProgressHeader({
    super.key,
    required this.currentUnit,
    required this.completedRoomIds,
    required this.currentRoomIndex,
    required this.roomCosts,
    required this.onRoomSelected,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final roomName = currentUnit.rooms.isNotEmpty 
        ? currentUnit.rooms[currentRoomIndex].name 
        : l10n.room;
    final totalRooms = currentUnit.rooms.length;
    final completedCount = completedRoomIds.length;
    final percentage = totalRooms == 0 ? 0 : (completedCount / totalRooms * 100).toInt();

    return Container(
      decoration: BoxDecoration(
        color: context.colors.background,
        border: Border(
          bottom: BorderSide(color: context.colors.border.withValues(alpha: 0.5), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: AppSpacing.sm,
                left: AppSpacing.sm,
                right: AppSpacing.sm,
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(FluentIcons.arrow_left_24_regular, color: context.colors.textPrimary),
                    onPressed: onBack,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          roomName,
                          style: TextStyle(
                            fontSize: AppFonts.bodyLarge,
                            fontWeight: FontWeight.bold,
                            color: context.colors.textPrimary,
                          ),
                        ),
                        Text(
                          l10n.roomXOfY((currentRoomIndex + 1).toString(), totalRooms.toString()),
                          style: TextStyle(
                            fontSize: AppFonts.labelSmall,
                            color: context.colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(FluentIcons.checkmark_circle_16_filled, color: context.colors.gold.withValues(alpha: 0.8), size: 14),
                          const SizedBox(width: 4),
                          Text(
                            '$percentage%',
                            style: TextStyle(
                              fontSize: AppFonts.labelSmall,
                              fontWeight: FontWeight.bold,
                              color: context.colors.gold.withValues(alpha: 0.8),
                            ),
                            textDirection: TextDirection.ltr,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Re-using the logic from UnitRoomsProgressBar but without the top title
            // Actually, we can just use UnitRoomsProgressBar but modify it to hide its title row.
            // But since we want clean architecture, let's just pass a flag to UnitRoomsProgressBar to hide header.
            UnitRoomsProgressBar(
              rooms: currentUnit.rooms,
              completedRoomIds: completedRoomIds,
              currentRoomIndex: currentRoomIndex,
              roomCosts: roomCosts,
              onRoomSelected: onRoomSelected,
              showHeader: false,
            ),
          ],
        ),
      ),
    );
  }
}
