import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/theme/app_fonts.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/theme_extension.dart';
import '../../../../../home/domain/entities/finishing_material_entity.dart';

class FinishingMaterialCard extends StatelessWidget {
  final FinishingMaterialEntity material;
  final bool isSelected;
  final VoidCallback? onTap;

  const FinishingMaterialCard({
    super.key, 
    required this.material,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: EdgeInsets.only(bottom: AppSpacing.md),
        padding: EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isSelected ? context.colors.primary.withValues(alpha: 0.05) : context.colors.white,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isSelected ? context.colors.primary : context.colors.border.withValues(alpha: 0.5),
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image or Placeholder
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: context.colors.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: material.imageUrl != null && material.imageUrl!.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      child: Image.network(
                        material.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _buildPlaceholder(context),
                      ),
                    )
                  : _buildPlaceholder(context),
            ),
            SizedBox(width: AppSpacing.md),
            
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          material.name,
                          style: TextStyle(
                            fontSize: AppFonts.bodyMedium,
                            fontWeight: FontWeight.bold,
                            color: context.colors.textPrimary,
                          ),
                        ),
                      ),
                      if (isSelected)
                        Icon(
                          FluentIcons.checkmark_circle_24_filled,
                          color: context.colors.primary,
                          size: 20,
                        ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    material.description,
                    style: TextStyle(
                      fontSize: AppFonts.bodySmall,
                      color: context.colors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: AppSpacing.sm),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${material.finalPrice} ر.س / ${material.unit}',
                        style: TextStyle(
                          fontSize: AppFonts.bodyMedium,
                          fontWeight: FontWeight.bold,
                          color: context.colors.primary,
                        ),
                      ),
                    ],
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
    return Center(
      child: Icon(
        FluentIcons.image_24_regular,
        color: context.colors.textSecondary.withValues(alpha: 0.5),
        size: 32,
      ),
    );
  }
}
