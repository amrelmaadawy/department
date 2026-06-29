import 'package:apartment/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/features/home/domain/entities/project_unit_entity.dart';
import 'package:apartment/l10n/app_localizations.dart';

class UnitBentoGrid extends StatelessWidget {
  final ProjectUnitEntity unit;

  const UnitBentoGrid({super.key, required this.unit});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    // Fallbacks if data is empty
    final roomsCount = unit.rooms.isNotEmpty ? unit.rooms.length.toString() : unit.roomsCount.toString();
    final locationLabel = unit.locationTypeLabel.isNotEmpty ? unit.locationTypeLabel : 'غير محدد';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: context.colors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: context.colors.border.withValues(alpha: 0.5), width: 1),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                      context: context,
                      icon: FluentIcons.slide_size_24_regular,
                      title: l10n.unitArea,
                      value: '${unit.area} ${l10n.unitSqMeter}',
                      isGold: true,
                    ),
                  ),
                  VerticalDivider(
                    color: context.colors.border.withValues(alpha: 0.5),
                    width: 1,
                    thickness: 1,
                    indent: AppSpacing.sm,
                    endIndent: AppSpacing.sm,
                  ),
                  Expanded(
                    child: _buildStatItem(
                      context: context,
                      icon: FluentIcons.conference_room_24_regular,
                      title: l10n.roomsLabel,
                      value: roomsCount,
                      isGold: false,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: context.colors.border.withValues(alpha: 0.5),
              height: 1,
              thickness: 1,
              indent: AppSpacing.sm,
              endIndent: AppSpacing.sm,
            ),
            IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                      context: context,
                      icon: FluentIcons.layer_24_regular,
                      title: l10n.floorLabel,
                      value: unit.floor.toString(),
                      isGold: false,
                    ),
                  ),
                  VerticalDivider(
                    color: context.colors.border.withValues(alpha: 0.5),
                    width: 1,
                    thickness: 1,
                    indent: AppSpacing.sm,
                    endIndent: AppSpacing.sm,
                  ),
                  Expanded(
                    child: _buildStatItem(
                      context: context,
                      icon: FluentIcons.location_24_regular,
                      title: 'إطلالة',
                      value: locationLabel,
                      isGold: false,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String value,
    required bool isGold,
  }) {
    final iconColor = isGold ? context.colors.gold : context.colors.primary;
    final valueColor = isGold ? context.colors.gold : context.colors.textPrimary;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md, horizontal: AppSpacing.xs),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 24, color: iconColor),
          const SizedBox(height: AppSpacing.sm),
          Text(
            title,
            style: TextStyle(
              fontSize: AppFonts.bodySmall,
              color: context.colors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: AppFonts.bodyLarge,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
