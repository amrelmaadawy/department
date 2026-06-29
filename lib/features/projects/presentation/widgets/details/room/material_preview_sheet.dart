import 'package:apartment/core/widgets/app_cached_network_image.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../../core/theme/app_fonts.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/theme_extension.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../home/domain/entities/finishing_material_entity.dart';
import '../../../../../../core/widgets/custom_button.dart';

class MaterialPreviewSheet extends StatelessWidget {
  final FinishingMaterialEntity material;
  final bool isSelected;
  final double? roomArea;
  final VoidCallback onToggleSelection;

  const MaterialPreviewSheet({
    super.key,
    required this.material,
    required this.isSelected,
    this.roomArea,
    required this.onToggleSelection,
  });

  static Future<bool?> show(
    BuildContext context, {
    required FinishingMaterialEntity material,
    required bool isSelected,
    double? roomArea,
    required VoidCallback onToggleSelection,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MaterialPreviewSheet(
        material: material,
        isSelected: isSelected,
        roomArea: roomArea,
        onToggleSelection: onToggleSelection,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final fullFormatter = NumberFormat.currency(symbol: '', decimalDigits: 0);
    
    double? totalCost;
    if (roomArea != null && roomArea! > 0) {
      totalCost = material.finalPrice * roomArea!;
    }

    return Container(
      decoration: BoxDecoration(
        color: context.colors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: AppSpacing.md, bottom: AppSpacing.sm),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: context.colors.border,
                borderRadius: BorderRadius.circular(AppRadius.round),
              ),
            ),
          ),
          
          if (material.imageUrl != null && material.imageUrl!.isNotEmpty)
            Container(
              height: 220,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.lg),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.lg),
                child: AppCachedNetworkImage(
                  imageUrl: material.imageUrl!,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => _buildPlaceholder(context),
                  errorWidget: (context, url, error) => _buildPlaceholder(context),
                ),
              ),
            ),
            
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        material.name,
                        style: TextStyle(
                          fontSize: AppFonts.headlineSmall,
                          fontWeight: FontWeight.bold,
                          color: context.colors.textPrimary,
                        ),
                      ),
                    ),
                    if (isSelected)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: context.colors.gold.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                          border: Border.all(color: context.colors.gold.withValues(alpha: 0.3)),
                        ),
                        child: Icon(FluentIcons.checkmark_12_filled, color: context.colors.gold, size: 16),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                if (material.description.isNotEmpty) ...[
                  Text(
                    material.description,
                    style: TextStyle(
                      fontSize: AppFonts.bodyMedium,
                      color: context.colors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
                
                if (totalCost != null)
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: context.colors.background,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(color: context.colors.border),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.totalRoomCostLabel(fullFormatter.format(totalCost).trim()),
                          style: TextStyle(
                            fontSize: AppFonts.bodyLarge,
                            fontWeight: FontWeight.bold,
                            color: context.colors.gold,
                          ),
                        ),
                        Icon(FluentIcons.money_20_filled, color: context.colors.gold, size: 20),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          
          Padding(
            padding: EdgeInsets.only(
              left: AppSpacing.lg,
              right: AppSpacing.lg,
              bottom: MediaQuery.of(context).padding.bottom + AppSpacing.xl,
            ),
            child: CustomButton(
              text: isSelected ? l10n.unselectMaterial : l10n.selectThisMaterial,
              onPressed: () {
                onToggleSelection();
                Navigator.pop(context, !isSelected);
              },
              backgroundColor: isSelected ? context.colors.error : context.colors.primary,
              textColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Container(
      color: context.colors.border.withValues(alpha: 0.2),
      child: Center(
        child: Icon(
          FluentIcons.image_off_24_regular,
          size: 48,
          color: context.colors.textSecondary,
        ),
      ),
    );
  }
}
