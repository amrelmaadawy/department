import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/features/home/domain/entities/project_unit_entity.dart';
import 'package:apartment/l10n/app_localizations.dart';
import 'package:apartment/core/routes/app_router.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'comparison_unit_card.dart';
import 'package:apartment/core/utils/responsive_builder.dart';

class UnitComparisonSheet extends StatelessWidget {
  final List<ProjectUnitEntity> units;

  const UnitComparisonSheet({super.key, required this.units});

  static Future<void> show(BuildContext context, List<ProjectUnitEntity> units) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      constraints: BoxConstraints(
        maxWidth: context.maxContainerWidth,
      ),
      builder: (context) => UnitComparisonSheet(units: units),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // Calculate best values for highlighting
    final minPrice = units.map((u) => u.price).reduce((a, b) => a < b ? a : b);
    final maxArea = units.map((u) => u.area).reduce((a, b) => a > b ? a : b);
    final maxRooms = units.map((u) => u.roomsCount).reduce((a, b) => a > b ? a : b);
    final maxBaths = units.map((u) => u.bathrooms).reduce((a, b) => a > b ? a : b);

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: context.colors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.unitComparison,
                  style: TextStyle(
                    fontSize: AppFonts.headlineSmall,
                    fontWeight: FontWeight.bold,
                    color: context.colors.textPrimary,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(FluentIcons.dismiss_24_regular, color: context.colors.textSecondary),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: context.colors.border),
          
          // Table Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.lg),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Labels Column
                  SizedBox(
                    width: 80, // Fixed width for labels
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 120), // Matches image height approx
                        _buildLabelCell(l10n.comparisonPrice),
                        _buildLabelCell(l10n.comparisonArea),
                        _buildLabelCell(l10n.comparisonRooms),
                        _buildLabelCell(l10n.comparisonBaths),
                        _buildLabelCell(l10n.comparisonFloor),
                        _buildLabelCell(l10n.comparisonStatus),
                        _buildLabelCell(l10n.comparisonType),
                      ],
                    ),
                  ),
                  
                  // Unit Columns
                  ...units.map((unit) {
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                        child: Column(
                          children: [
                            ComparisonUnitCard(unit: unit),
                            const SizedBox(height: AppSpacing.md),
                            _buildValueCell(context, _formatPrice(unit.price), isBest: unit.price == minPrice, icon: FluentIcons.money_24_regular),
                            _buildValueCell(context, '${unit.area} ${l10n.unitSqMeter}', isBest: unit.area == maxArea, icon: FluentIcons.slide_size_24_regular),
                            _buildValueCell(context, unit.roomsCount.toString(), isBest: unit.roomsCount == maxRooms, icon: FluentIcons.conference_room_24_regular),
                            _buildValueCell(context, unit.bathrooms.toString(), isBest: unit.bathrooms == maxBaths, icon: FluentIcons.drop_24_regular),
                            _buildValueCell(context, unit.floor.toString(), isBest: false, icon: FluentIcons.layer_24_regular),
                            _buildValueCell(context, unit.status == UnitStatus.available ? l10n.unitAvailable : l10n.unitSoldOut, isBest: unit.status == UnitStatus.available, icon: FluentIcons.info_24_regular),
                            _buildValueCell(context, _getTypeLabel(unit.type), isBest: false, icon: FluentIcons.building_24_regular),
                            
                            const SizedBox(height: AppSpacing.lg),
                            ElevatedButton(
                              onPressed: unit.status == UnitStatus.sold ? null : () {
                                Navigator.of(context).pop();
                                Future.delayed(const Duration(milliseconds: 150), () {
                                  if (context.mounted) {
                                    context.push(
                                      AppRouter.unitDetails,
                                      extra: {
                                        'unit': unit,
                                        'heroTag': 'unit_comp_${unit.id}',
                                      },
                                    );
                                  }
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: context.colors.primary,
                                foregroundColor: context.colors.white,
                                disabledBackgroundColor: context.colors.border,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(AppRadius.md),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                minimumSize: const Size(double.infinity, 44),
                              ),
                              child: Text(
                                l10n.bookUnit,
                                style: TextStyle(
                                  fontSize: AppFonts.labelMedium,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatPrice(double price) {
    return price.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }

  String _getTypeLabel(UnitType type) {
    switch (type) {
      case UnitType.apartment:
        return 'شقة';
      case UnitType.villa:
        return 'فيلا';
      case UnitType.duplex:
        return 'دوبلكس';
    }
  }

  Widget _buildLabelCell(String text) {
    return Container(
      height: 60,
      alignment: Alignment.centerRight, // RTL alignment
      padding: const EdgeInsets.only(left: AppSpacing.sm),
      child: Text(
        text,
        style: TextStyle(
          fontSize: AppFonts.labelMedium,
          color: Colors.grey.shade600, // Fixed color to ensure readability
          fontWeight: FontWeight.w600,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildValueCell(BuildContext context, String value, {required bool isBest, required IconData icon}) {
    return Container(
      height: 60,
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: isBest ? context.colors.gold.withValues(alpha: 0.1) : context.colors.white,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(
          color: isBest ? context.colors.gold.withValues(alpha: 0.5) : context.colors.border.withValues(alpha: 0.5),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: isBest ? context.colors.gold : context.colors.textSecondary,
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(
                fontSize: AppFonts.labelMedium,
                fontWeight: isBest ? FontWeight.bold : FontWeight.normal,
                color: isBest ? context.colors.gold : context.colors.textPrimary,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
