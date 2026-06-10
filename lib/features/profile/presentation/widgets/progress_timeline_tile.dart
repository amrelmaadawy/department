import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import 'package:apartment/core/theme/theme_extension.dart';


class ProgressTimelineTile extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final bool isCompleted;
  final bool isActive;
  final Map<String, dynamic> phase;

  const ProgressTimelineTile({
    super.key,
    required this.isFirst,
    required this.isLast,
    required this.isCompleted,
    required this.isActive,
    required this.phase,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final List<String> images = List<String>.from(phase['images'] ?? []);
    final Color indicatorColor = isCompleted
        ? context.colors.success
        : (isActive ? context.colors.gold : context.colors.border);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline Line and Dot
          SizedBox(
            width: 40,
            child: Column(
              children: [
                // Top line
                Container(
                  width: 2,
                  height: 24,
                  color: isFirst ? Colors.transparent : (isCompleted || isActive ? context.colors.success : context.colors.border),
                ),
                // Indicator Dot
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isActive ? context.colors.white : indicatorColor,
                    shape: BoxShape.circle,
                    border: isActive ? Border.all(color: context.colors.gold, width: 4) : null,
                  ),
                  child: isCompleted
                      ? Icon(FluentIcons.checkmark_12_filled, color: context.colors.white, size: 14)
                      : null,
                ),
                // Bottom line
                Expanded(
                  child: Container(
                    width: 2,
                    color: isLast ? Colors.transparent : (isCompleted ? context.colors.success : context.colors.border),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: AppSpacing.sm),
          
          // Content Card
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.xl),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  color: context.colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                  boxShadow: [
                    BoxShadow(
                      color: isActive 
                          ? context.colors.gold.withValues(alpha: 0.15) 
                          : Colors.black.withValues(alpha: 0.03),
                      blurRadius: isActive ? 20 : 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                  border: Border.all(
                    color: isActive ? context.colors.gold.withValues(alpha: 0.3) : context.colors.border.withValues(alpha: 0.2),
                    width: isActive ? 1.5 : 1,
                  ),
                ),
                padding: EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date & Status Badge
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          phase['date'],
                          style: TextStyle(
                            fontSize: AppFonts.bodySmall,
                            color: isActive ? context.colors.gold : context.colors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (isActive)
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: context.colors.gold.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(AppRadius.md),
                            ),
                            child: Text(
                              l10n.inProgressNow,
                              style: TextStyle(
                                fontSize: 10,
                                color: context.colors.gold,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.sm),
                    
                    // Title
                    Text(
                      phase['title'],
                      style: TextStyle(
                        fontSize: AppFonts.bodyLarge,
                        fontWeight: FontWeight.bold,
                        color: isActive || isCompleted ? context.colors.textPrimary : context.colors.textSecondary,
                      ),
                    ),
                    SizedBox(height: AppSpacing.xs),
                    
                    // Subtitle
                    Text(
                      phase['subtitle'],
                      style: TextStyle(
                        fontSize: AppFonts.bodyMedium,
                        color: context.colors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    
                    // Images Gallery
                    if (images.isNotEmpty && (isActive || isCompleted)) ...[
                      SizedBox(height: AppSpacing.md),
                      SizedBox(
                        height: 90,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: images.length,
                          separatorBuilder: (context, index) => SizedBox(width: AppSpacing.sm),
                          itemBuilder: (context, index) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(AppRadius.md),
                              child: Image.asset(
                                images[index],
                                width: 120,
                                height: 90,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  width: 120,
                                  height: 90,
                                  color: context.colors.border,
                                  child: Icon(FluentIcons.image_24_regular, color: context.colors.textSecondary),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ]
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
