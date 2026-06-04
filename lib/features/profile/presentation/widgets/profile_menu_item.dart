import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_spacing.dart';

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final String? trailingText;
  final bool isDestructive;
  final bool showDivider;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.trailingText,
    this.isDestructive = false,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive
        ? const Color(0xFFE53935)
        : AppColors.textPrimary;
    final iconBgColor = isDestructive
        ? const Color(0xFFE53935).withValues(alpha: 0.1)
        : AppColors.primary.withValues(alpha: 0.05);

    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            splashColor: isDestructive
                ? const Color(0xFFE53935).withValues(alpha: 0.1)
                : AppColors.gold.withValues(alpha: 0.1),
            highlightColor: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md, // slightly tighter vertical padding
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: iconBgColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      color: isDestructive
                          ? const Color(0xFFE53935)
                          : AppColors.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: AppFonts.headlineSmall,
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                  ),
                  if (trailingText != null) ...[
                    Text(
                      trailingText!,
                      style: TextStyle(
                        fontSize: AppFonts.bodyMedium,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary.withValues(alpha: 0.8),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                  ],
                  if (!isDestructive)
                    Icon(
                      FluentIcons.chevron_left_20_regular, // RTL assumed
                      color: AppColors.textSecondary.withValues(alpha: 0.4),
                      size: 20,
                    ),
                ],
              ),
            ),
          ),
        ),
        if (showDivider)
          Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.xxxl * 1.5,
              right: AppSpacing.lg,
            ), // offset divider
            child: Divider(
              height: 1,
              color: AppColors.border.withValues(alpha: 0.3),
            ),
          ),
      ],
    );
  }
}
