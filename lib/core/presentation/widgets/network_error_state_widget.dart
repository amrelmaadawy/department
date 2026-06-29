import 'package:apartment/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/core/theme/theme_extension.dart';

class NetworkErrorStateWidget extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final VoidCallback onRetry;
  final Color? iconColor;

  const NetworkErrorStateWidget({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
    required this.onRetry,
    this.iconColor,
  });

  factory NetworkErrorStateWidget.noInternet({
    required VoidCallback onRetry,
  }) {
    return NetworkErrorStateWidget(
      title: 'لا يوجد اتصال بالإنترنت',
      message: 'يرجى التحقق من اتصالك بالشبكة والمحاولة مرة أخرى.',
      icon: Icons.wifi_off_rounded,
      onRetry: onRetry,
    );
  }

  factory NetworkErrorStateWidget.timeout({
    required VoidCallback onRetry,
  }) {
    return NetworkErrorStateWidget(
      title: 'انتهت مهلة الاتصال',
      message: 'الاتصال بالإنترنت بطيء جداً، يرجى المحاولة لاحقاً.',
      icon: Icons.hourglass_disabled_rounded,
      onRetry: onRetry,
    );
  }

  factory NetworkErrorStateWidget.serverError({
    required VoidCallback onRetry,
    int? statusCode,
  }) {
    return NetworkErrorStateWidget(
      title: 'خطأ في الخادم',
      message: 'حدث خطأ في الخادم${statusCode != null ? " ($statusCode)" : ""}. يرجى المحاولة لاحقاً.',
      icon: Icons.cloud_off_rounded,
      onRetry: onRetry,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (iconColor ?? context.colors.error).withValues(alpha: 0.1),
              ),
              child: Icon(
                icon,
                size: 64,
                color: iconColor ?? context.colors.error,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppFonts.headlineSmall,
                fontWeight: FontWeight.bold,
                color: context.colors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppFonts.bodyMedium,
                color: context.colors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colors.primary,
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                ),
                onPressed: onRetry,
                child: const Text(
                  'إعادة المحاولة',
                  style: TextStyle(
                    fontSize: AppFonts.bodyLarge,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
