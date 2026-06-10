import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import '../../../../../core/theme/app_fonts.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../domain/entities/material_entity.dart';
import '../../../domain/entities/material_category.dart';
import 'package:apartment/core/theme/theme_extension.dart';


class ReviewSelectionCard extends StatelessWidget {
  final MaterialEntity material;

  const ReviewSelectionCard({super.key, required this.material});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.lg),
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: context.colors.border.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Elegant Icon Container
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  context.colors.gold.withValues(alpha: 0.15),
                  context.colors.gold.withValues(alpha: 0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Icon(
              _getCategoryIcon(material.category),
              color: context.colors.gold,
              size: 20,
            ),
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getCategoryName(material.category, l10n).toUpperCase(),
                  style: TextStyle(
                    fontSize: AppFonts.labelSmall,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                    color: context.colors.gold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  material.name,
                  style: TextStyle(
                    fontSize: AppFonts.headlineSmall,
                    fontWeight: FontWeight.bold,
                    color: context.colors.primary,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '${material.pricePerSqm.toStringAsFixed(0)} ${l10n.pricePerSqm.split(' ')[0]}',
                  style: TextStyle(
                    fontSize: AppFonts.bodyMedium,
                    color: context.colors.textPrimary.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          // Premium Thumbnail Image
          Container(
            width: 75,
            height: 75,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.md),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
              image: DecorationImage(
                image: AssetImage(material.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(MaterialCategory category) {
    switch (category) {
      case MaterialCategory.floors:
        return FluentIcons.layer_20_regular;
      case MaterialCategory.walls:
        return FluentIcons.paint_brush_20_regular;
      case MaterialCategory.ceilings:
        return FluentIcons.lightbulb_20_regular;
      case MaterialCategory.doors:
        return FluentIcons.door_arrow_left_20_regular;
      default:
        return FluentIcons.layer_20_regular;
    }
  }

  String _getCategoryName(MaterialCategory category, AppLocalizations l10n) {
    switch (category) {
      case MaterialCategory.floors:
        return l10n.categoryFloors;
      case MaterialCategory.walls:
        return l10n.categoryWalls;
      case MaterialCategory.ceilings:
        return l10n.categoryCeilings;
      case MaterialCategory.doors:
        return l10n.categoryDoors;
      default:
        return '';
    }
  }
}
