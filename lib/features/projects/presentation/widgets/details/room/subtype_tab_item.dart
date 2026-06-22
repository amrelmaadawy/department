import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/core/theme/app_spacing.dart';

import '../../../../../home/domain/entities/finishing_subtype_entity.dart';

class SubtypeTabItem extends StatelessWidget {
  final FinishingSubtypeEntity subtype;
  final bool isSelected;
  final bool isCompleted;
  final VoidCallback onTap;

  const SubtypeTabItem({
    super.key,
    required this.subtype,
    required this.isSelected,
    required this.isCompleted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? context.colors.gold.withValues(alpha: 0.1) : context.colors.background,
          borderRadius: BorderRadius.circular(AppRadius.round),
          border: Border.all(
            color: isSelected ? context.colors.gold : context.colors.border,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isCompleted) ...[
              Icon(
                FluentIcons.checkmark_circle_16_filled,
                size: 18,
                color: isSelected ? context.colors.gold : context.colors.primary,
              ),
              const SizedBox(width: AppSpacing.sm),
            ],
            Text(
              subtype.subtypeName,
              style: TextStyle(
                fontSize: AppFonts.bodyMedium,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected ? context.colors.gold : context.colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
