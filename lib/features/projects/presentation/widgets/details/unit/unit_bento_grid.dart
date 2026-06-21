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
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: _buildBentoCard(
                  context: context,
                  icon: FluentIcons.slide_size_24_regular,
                  title: l10n.unitArea,
                  value: '${unit.area} ${l10n.unitSqMeter}',
                  isGold: true,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                flex: 1,
                child: _buildBentoCard(
                  context: context,
                  icon: FluentIcons.layer_24_regular,
                  title: l10n.floorLabel,
                  value: unit.floor.toString(),
                  isGold: false,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: _buildBentoCard(
                  context: context,
                  icon: FluentIcons.conference_room_24_regular,
                  title: l10n.roomsLabel,
                  value: roomsCount,
                  isGold: false,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                flex: 2,
                child: _buildBentoCard(
                  context: context,
                  icon: FluentIcons.location_24_regular,
                  title: 'إطلالة',
                  value: locationLabel,
                  isGold: false,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBentoCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String value,
    required bool isGold,
  }) {
    final bgColor = isGold 
        ? context.colors.gold.withValues(alpha: 0.1) 
        : context.colors.white;
        
    final borderColor = isGold 
        ? context.colors.gold.withValues(alpha: 0.3) 
        : context.colors.border;

    final iconColor = isGold ? context.colors.gold : context.colors.primary;
    final valueColor = isGold ? context.colors.gold : context.colors.textPrimary;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: [
          if (!isGold)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: iconColor),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: AppFonts.labelMedium,
                    color: context.colors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            value,
            style: TextStyle(
              fontSize: isGold ? AppFonts.headlineMedium : AppFonts.headlineSmall,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
