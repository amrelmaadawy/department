import 'package:apartment/core/theme/app_colors.dart';
import 'dart:ui';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:apartment/core/widgets/app_cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:apartment/l10n/app_localizations.dart';
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
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: isSelected ? context.colors.gold : AppColors.transparent,
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: context.colors.gold.withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  )
                ]
              : [
                  BoxShadow(
                    color: AppColors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.lg - 1),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 1. Background Image
              material.imageUrl != null && material.imageUrl!.isNotEmpty
                  ? AppCachedNetworkImage(
                      imageUrl: material.imageUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => _buildPlaceholder(context),
                      errorWidget: (context, url, error) =>
                          _buildPlaceholder(context),
                    )
                  : _buildPlaceholder(context),

              // 2. Gradient Overlay
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.transparent,
                        AppColors.black.withValues(alpha: 0.4),
                        AppColors.black.withValues(alpha: 0.8),
                      ],
                      stops: const [0.4, 0.7, 1.0],
                    ),
                  ),
                ),
              ),

              // 3. Selection Indicator (Top Left/Right based on locale)
              if (isSelected)
                Positioned(
                  top: AppSpacing.sm,
                  right: AppSpacing.sm,
                  child: AnimatedScale(
                    scale: isSelected ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.elasticOut,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.round),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: context.colors.gold.withValues(alpha: 0.8),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.white.withValues(alpha: 0.5),
                              width: 1,
                            ),
                          ),
                          child: const Icon(
                            FluentIcons.checkmark_16_filled,
                            color: AppColors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

              // 4. Details Section
              Positioned(
                left: AppSpacing.md,
                right: AppSpacing.md,
                bottom: AppSpacing.md,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      material.name,
                      style: TextStyle(
                        fontSize: AppFonts.bodyMedium,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                        height: 1.2,
                        shadows: [
                          Shadow(
                            color: AppColors.black.withValues(alpha: 0.54),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    if (roomArea != null && roomArea! > 0)
                      Text(
                        '${NumberFormat.currency(symbol: '', decimalDigits: 0).format(material.finalPrice * roomArea!).trim()} ${AppLocalizations.of(context)!.sar} للغرفة',
                        style: TextStyle(
                          fontSize: AppFonts.bodySmall,
                          fontWeight: FontWeight.w600,
                          color: context.colors.gold,
                          height: 1.2,
                          shadows: [
                            Shadow(
                              color: AppColors.black.withValues(alpha: 0.54),
                              blurRadius: 2,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
            ],
          ),
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

