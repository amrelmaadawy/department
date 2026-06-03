import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final String time;
  final bool isUser;
  final String? avatarUrl;

  const ChatBubble({
    super.key,
    required this.text,
    required this.time,
    required this.isUser,
    this.avatarUrl,
    this.animationDelay = 0,
  });

  final int animationDelay;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        // Slide up and fade in effect
        final offset = (1.0 - value) * 20.0;
        return Transform.translate(
          offset: Offset(0, offset),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          mainAxisAlignment: isUser
              ? MainAxisAlignment.start
              : MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (isUser)
              const SizedBox(width: AppSpacing.xxxl * 2), // Margin for user

            if (!isUser && avatarUrl != null) ...[
              CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(avatarUrl!),
              ),
              const SizedBox(width: AppSpacing.sm),
            ],

            Expanded(
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: isUser
                      ? AppColors.primary
                      : AppColors.white, // Professional Navy Blue for user
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(AppRadius.xl),
                    topRight: const Radius.circular(AppRadius.xl),
                    bottomRight: Radius.circular(
                      isUser ? 0 : AppRadius.xl,
                    ), // Tail for user on right
                    bottomLeft: Radius.circular(
                      isUser ? AppRadius.xl : 0,
                    ), // Tail for agent on left
                  ),
                  border: isUser
                      ? null
                      : Border.all(
                          color: AppColors.border.withValues(alpha: 0.5),
                        ),
                  boxShadow: [
                    BoxShadow(
                      color: isUser
                          ? AppColors.primary.withValues(alpha: 0.2)
                          : Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      text,
                      style: TextStyle(
                        fontSize: AppFonts.bodyLarge,
                        height: 1.5,
                        color: isUser ? AppColors.white : AppColors.textPrimary,
                        fontWeight: isUser
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          time,
                          style: TextStyle(
                            fontSize: AppFonts.labelSmall,
                            fontWeight: FontWeight.w600,
                            color: isUser
                                ? AppColors.white.withValues(alpha: 0.7)
                                : AppColors.textSecondary.withValues(
                                    alpha: 0.6,
                                  ),
                          ),
                        ),
                        if (isUser) ...[
                          const SizedBox(width: 4),
                          Icon(
                            FluentIcons
                                .checkmark_12_filled, // Simulate read receipt
                            color: AppColors.white.withValues(alpha: 0.7),
                            size: 14,
                          ),
                          Icon(
                            FluentIcons
                                .checkmark_12_filled, // Simulate read receipt
                            color: AppColors.white.withValues(alpha: 0.7),
                            size: 14,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),

            if (!isUser)
              const SizedBox(width: AppSpacing.xxxl * 2), // Margin for agent
          ],
        ),
      ),
    );
  }
}
