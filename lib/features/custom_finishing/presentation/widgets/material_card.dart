import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/material_entity.dart';
import 'package:apartment/core/theme/theme_extension.dart';

class MaterialCard extends StatelessWidget {
  final MaterialEntity material;
  final bool isSelected;
  final VoidCallback onTap;

  const MaterialCard({
    super.key,
    required this.material,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        margin: EdgeInsets.only(bottom: AppSpacing.xl),
        decoration: BoxDecoration(
          color: context.colors.white,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(
            color: isSelected
                ? context.colors.gold
                : context.colors.border.withValues(alpha: 0.5),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? context.colors.gold.withValues(alpha: 0.15)
                  : Colors.black.withValues(alpha: 0.03),
              blurRadius: isSelected ? 20 : 10,
              offset: Offset(0, isSelected ? 8 : 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Header with Gradient Overlay
            Stack(
              children: [
                SizedBox(
                  height: 180,
                  width: double.infinity,
                  child: material.imageUrl.isNotEmpty
                      ? Image.asset(
                          material.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(color: context.colors.background),
                        )
                      : Container(color: context.colors.background), // Fallback
                ),
                // Inner bottom gradient for smooth transition
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.4),
                        ],
                        stops: [0.6, 1.0],
                      ),
                    ),
                  ),
                ),
                // Tag badge on image
                Positioned(
                  bottom: AppSpacing.md,
                  right: AppSpacing.md,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Text(
                      material.tag,
                      style: TextStyle(
                        fontSize: AppFonts.labelSmall,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
                // Selection Checkmark
                if (isSelected)
                  Positioned(
                    top: AppSpacing.md,
                    right: AppSpacing.md,
                    child: AnimatedScale(
                      scale: isSelected ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.elasticOut,
                      child: Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [context.colors.gold, Color(0xFFE5B962)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: context.colors.gold.withValues(alpha: 0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Icon(
                          FluentIcons.checkmark_16_filled,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            // Content
            Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    material.name,
                    style: TextStyle(
                      fontSize: AppFonts.headlineSmall,
                      fontWeight: FontWeight.bold,
                      color: context.colors.textPrimary,
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: AppSpacing.sm),
                  Text(
                    material.description,
                    style: TextStyle(
                      fontSize: AppFonts.bodyMedium,
                      color: context.colors.textPrimary.withValues(alpha: 0.6),
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: AppSpacing.lg),
                  Container(
                    padding: EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: context.colors.background,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      border: Border.all(
                        color: context.colors.border.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.pricePerSqm,
                          style: TextStyle(
                            fontSize: AppFonts.bodyLarge,
                            color: context.colors.textPrimary.withValues(alpha: 0.5),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              material.pricePerSqm.toStringAsFixed(0),
                              style: TextStyle(
                                fontSize: AppFonts.displaySmall, // Display size
                                fontWeight: FontWeight.w900,
                                color: context.colors.textPrimary,
                                letterSpacing: -1,
                              ),
                            ),
                            SizedBox(width: 4),
                            Text(
                              l10n.pricePerSqm.split(' ')[0],
                              style: TextStyle(
                                fontSize: AppFonts.bodyMedium,
                                fontWeight: FontWeight.w600,
                                color: context.colors.gold,
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
          ],
        ),
      ),
    );
  }
}
