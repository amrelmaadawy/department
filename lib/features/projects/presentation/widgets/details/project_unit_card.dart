import 'package:apartment/core/theme/theme_extension.dart';
import 'package:apartment/core/widgets/app_cached_network_image.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/features/home/domain/entities/project_unit_entity.dart';
import 'package:flutter/material.dart';
import 'package:apartment/l10n/app_localizations.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

class ProjectUnitCard extends StatelessWidget {
  final ProjectUnitEntity unit;
  final int index;
  final bool isSelected;
  final bool isComparisonMode;
  final VoidCallback onTap;

  const ProjectUnitCard({
    super.key,
    required this.unit,
    required this.index,
    this.isSelected = false,
    this.isComparisonMode = false,
    required this.onTap,
  });

  String _formatPrice(double price) {
    return price
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isSold = unit.status == UnitStatus.sold;

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 400 + (index * 150)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(
            opacity: value * (isSold ? 0.6 : 1.0), // Faded if sold
            child: child,
          ),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        decoration: BoxDecoration(
          color: isSelected
              ? context.colors.gold.withValues(alpha: 0.05)
              : context.colors.white,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isSelected ? context.colors.gold : context.colors.border,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.md),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: isSold ? null : onTap,
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Image
                  Expanded(
                    flex: 3,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        unit.imagePath.isNotEmpty
                            ? (unit.imagePath.startsWith('http')
                                ? AppCachedNetworkImage(
                                    imageUrl: Uri.encodeFull(unit.imagePath),
                                    fit: BoxFit.cover,
                                    errorWidget: (context, url, error) =>
                                        _buildImagePlaceholder(context),
                                  )
                                : Image.asset(unit.imagePath, fit: BoxFit.cover))
                            : _buildImagePlaceholder(context),
                        
                        // Comparison Checkbox Overlay
                        if (isComparisonMode)
                          Positioned(
                            top: AppSpacing.sm,
                            right: AppSpacing.sm,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: isSelected ? context.colors.gold : context.colors.white.withValues(alpha: 0.9),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected ? context.colors.gold : context.colors.border,
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 4,
                                  )
                                ],
                              ),
                              child: Center(
                                child: Icon(
                                  FluentIcons.checkmark_16_filled,
                                  size: 14,
                                  color: isSelected ? context.colors.white : Colors.transparent,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Details
                  Expanded(
                    flex: 7,
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  unit.unitNumber.isNotEmpty 
                                      ? '${unit.title} - وحدة ${unit.unitNumber}'
                                      : unit.title,
                                  style: TextStyle(
                                    fontSize: AppFonts.bodyLarge,
                                    fontWeight: FontWeight.bold,
                                    color: context.colors.textPrimary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              // Status Badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.xs,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: isSold
                                      ? context.colors.textSecondary.withValues(
                                          alpha: 0.1,
                                        )
                                      : Colors.green.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(
                                    AppRadius.sm,
                                  ),
                                ),
                                child: Text(
                                  unit.statusLabel.isNotEmpty 
                                      ? unit.statusLabel 
                                      : (isSold ? l10n.unitSoldOut : l10n.unitAvailable),
                                  style: TextStyle(
                                    fontSize: AppFonts.labelSmall,
                                    color: isSold
                                        ? context.colors.textSecondary
                                        : Colors.green.shade700,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.xs),

                          // Specs
                          Wrap(
                            spacing: AppSpacing.sm,
                            runSpacing: AppSpacing.xs,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              _buildSpecItem(
                                context,
                                FluentIcons.slide_size_24_regular,
                                '${unit.area} ${l10n.unitSqMeter}',
                              ),
                              _buildSpecItem(
                                context,
                                FluentIcons.conference_room_24_regular,
                                '${unit.roomsCount} ${l10n.unitBeds}',
                              ),
                              if (unit.locationTypeLabel.isNotEmpty)
                                _buildSpecItem(
                                  context,
                                  FluentIcons.location_16_regular,
                                  unit.locationTypeLabel,
                                ),
                              _buildSpecItem(
                                context,
                                FluentIcons.building_24_regular,
                                l10n.buildingNumber(unit.buildingNumber.toString()),
                              ),
                              _buildSpecItem(
                                context,
                                FluentIcons.layer_24_regular,
                                l10n.floorDesc(unit.floor.toString()),
                              ),
                            ],
                          ),
                          const Spacer(),

                          // Price
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                '${l10n.unitStartsFrom} ',
                                style: TextStyle(
                                  fontSize: AppFonts.labelMedium,
                                  color: context.colors.textSecondary,
                                ),
                              ),
                              Text(
                                '${_formatPrice(unit.price)} ${l10n.sar}',
                                style: TextStyle(
                                  fontSize: AppFonts.bodyLarge,
                                  fontWeight: FontWeight.bold,
                                  color: context.colors.gold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSpecItem(BuildContext context, IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: context.colors.textSecondary),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: AppFonts.labelMedium,
            color: context.colors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildImagePlaceholder(BuildContext context) {
    return Center(
      child: Icon(
        FluentIcons.image_off_24_regular,
        size: 32,
        color: context.colors.textSecondary,
      ),
    );
  }
}
