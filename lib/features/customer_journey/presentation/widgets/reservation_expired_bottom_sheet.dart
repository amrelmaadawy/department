import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_radius.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/services/analytics/analytics_service.dart';

class ReservationExpiredBottomSheet extends StatelessWidget {
  final String? unitNumber;
  final VoidCallback? onContactSales;

  const ReservationExpiredBottomSheet({
    super.key,
    this.unitNumber,
    this.onContactSales,
  });

  static void show(BuildContext context, {String? unitNumber, VoidCallback? onContactSales}) {
    if (sl.isRegistered<AnalyticsService>()) {
      sl<AnalyticsService>().logEvent('reservation_expired', parameters: {'unit_number': unitNumber});
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ReservationExpiredBottomSheet(
        unitNumber: unitNumber,
        onContactSales: onContactSales,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final unitTitle = unitNumber != null ? 'لوحدة $unitNumber' : '';

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 48,
              height: 5,
              decoration: BoxDecoration(
                color: context.colors.border,
                borderRadius: BorderRadius.circular(AppRadius.round),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.colors.error.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              FluentIcons.clock_alarm_24_filled,
              color: context.colors.error,
              size: 40,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'انتهت صلاحية الحجز',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppFonts.headlineMedium,
              fontWeight: FontWeight.bold,
              color: context.colors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'انتهت صلاحية حجزك $unitTitle نظراً لتجاوز المدة المحددة دون إتمام التعاقد. تم إعادة الوحدة للحالة المتاحة.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppFonts.bodyLarge,
              color: context.colors.textPrimary.withValues(alpha: 0.7),
              height: 1.5,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          CustomButton(
            text: 'تواصل مع فريق المبيعات لإعادة الحجز',
            onPressed: () {
              context.pop();
              if (onContactSales != null) {
                onContactSales!();
              }
            },
          ),
          const SizedBox(height: AppSpacing.sm),
          TextButton(
            onPressed: () {
              context.pop();
              context.go(AppRouter.layout);
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              foregroundColor: context.colors.primary,
            ),
            child: const Text(
              'تصفح الوحدات المتاحة في المشروع',
              style: TextStyle(
                fontSize: AppFonts.bodyLarge,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}
