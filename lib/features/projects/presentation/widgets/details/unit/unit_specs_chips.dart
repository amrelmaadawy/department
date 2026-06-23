import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import 'package:apartment/core/theme/theme_extension.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/features/home/domain/entities/project_unit_entity.dart';
import 'package:apartment/l10n/app_localizations.dart';


class UnitSpecsChips extends StatelessWidget {
  final ProjectUnitEntity unit;

  const UnitSpecsChips({super.key, required this.unit});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        alignment: WrapAlignment.center,
        children: [
          _buildChip(
            context,
            '${unit.area} ${l10n.unitSqMeter}',
            FluentIcons.slide_size_24_regular,
          ),
          _buildChip(
            context,
            '${l10n.floorLabel} ${unit.floor}',
            FluentIcons.layer_24_regular,
          ),
          _buildChip(
            context,
            '${unit.rooms.isNotEmpty ? unit.rooms.length : unit.roomsCount} ${l10n.roomsLabel}',
            FluentIcons.conference_room_24_regular,
          ),
          if (unit.locationTypeLabel.isNotEmpty)
            _buildChip(
              context,
              unit.locationTypeLabel,
              FluentIcons.location_16_regular,
            ),
          ...unit.extras.map(
            (extra) => _buildChip(context, extra, FluentIcons.star_24_regular),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(BuildContext context, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md + 4,
        vertical: AppSpacing.sm + 2,
      ),
      decoration: BoxDecoration(
        color: context.colors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: context.colors.primary.withValues(alpha: 0.1), 
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: AppFonts.labelMedium,
              fontWeight: FontWeight.w600,
              color: context.colors.textPrimary,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Icon(icon, size: 18, color: context.colors.gold),
        ],
      ),
    );
  }
}
