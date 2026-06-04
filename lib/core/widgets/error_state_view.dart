import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../theme/app_spacing.dart';
import 'custom_button.dart';

class ErrorStateView extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onRetry;
  final String retryText;
  final IconData icon;

  const ErrorStateView({
    super.key,
    this.title = 'عذراً، حدث خطأ ما',
    required this.message,
    this.onRetry,
    this.retryText = 'إعادة المحاولة',
    this.icon = FluentIcons.error_circle_24_regular,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 64,
                color: AppColors.error.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: AppFonts.headlineMedium,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: AppFonts.bodyMedium,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.xxl),
              SizedBox(
                width: 200,
                child: CustomButton(
                  text: retryText,
                  onPressed: onRetry,
                  backgroundColor: AppColors.error,
                  textColor: AppColors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
