import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

import '../../../../../../core/theme/app_fonts.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/theme_extension.dart';
import '../../../../../home/domain/entities/finishing_material_entity.dart';

class FinishingMaterialGridCard extends StatelessWidget {
  final FinishingMaterialEntity material;
  final bool isSelected;
  final double? roomArea;
  final VoidCallback? onTap;

  const FinishingMaterialGridCard({
    super.key,
    required this.material,
    this.isSelected = false,
    this.roomArea,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: context.colors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: isSelected ? context.colors.primary : context.colors.border,
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: context.colors.primary.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image Section
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppRadius.lg - 1),
                ),
                child: material.imageUrl != null && material.imageUrl!.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: material.imageUrl!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => _buildPlaceholder(context),
                        errorWidget: (context, url, error) =>
                            _buildPlaceholder(context),
                      )
                    : _buildPlaceholder(context),
              ),
            ),
            
            // Details Section
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          material.name,
                          style: TextStyle(
                            fontSize: AppFonts.bodyMedium,
                            fontWeight: FontWeight.bold,
                            color: context.colors.textPrimary,
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        if (roomArea != null && roomArea! > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            margin: const EdgeInsets.only(bottom: AppSpacing.xs),
                            decoration: BoxDecoration(
                              color: context.colors.gold.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(AppRadius.sm),
                            ),
                            child: Text(
                              '${NumberFormat.currency(symbol: '', decimalDigits: 0).format(material.finalPrice * roomArea!).trim()} ر.س للغرفة',
                              style: TextStyle(
                                fontSize: AppFonts.labelSmall,
                                fontWeight: FontWeight.bold,
                                color: context.colors.gold,
                              ),
                            ),
                          ),
                        Text(
                          '${material.finalPrice} ر.س / ${material.unit}',
                          style: TextStyle(
                            fontSize: AppFonts.bodySmall,
                            fontWeight: FontWeight.bold,
                            color: context.colors.textSecondary,
                            height: 1.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(scale: animation, child: child);
                    },
                    child: Icon(
                      isSelected
                          ? FluentIcons.checkmark_circle_24_filled
                          : FluentIcons.circle_24_regular,
                      key: ValueKey<bool>(isSelected),
                      color: isSelected
                          ? context.colors.primary
                          : context.colors.textSecondary.withValues(alpha: 0.3),
                      size: 24,
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

  Widget _buildPlaceholder(BuildContext context) {
    return Container(
      color: context.colors.background,
      child: Center(
        child: Icon(
          FluentIcons.image_24_regular,
          color: context.colors.textSecondary.withValues(alpha: 0.2),
          size: 32,
        ),
      ),
    );
  }
}
