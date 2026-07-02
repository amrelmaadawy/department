import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extension.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/services/analytics/analytics_service.dart';
import '../../domain/entities/active_journey_entity.dart';
import 'reservation_expired_bottom_sheet.dart';

class ActiveJourneyCardItem extends StatelessWidget {
  final ActiveJourneyEntity journey;

  const ActiveJourneyCardItem({super.key, required this.journey});

  void _onResumeTap(BuildContext context) {
    if (journey.reservationExpiresAt != null && journey.reservationExpiresAt!.isBefore(DateTime.now())) {
      ReservationExpiredBottomSheet.show(context, unitNumber: journey.unitNumber);
      return;
    }
    sl<AnalyticsService>().logEvent('journey_resumed_from_card', parameters: {'unit_number': journey.unitNumber});
    if (journey.resumeRoute.isEmpty) return;
    try {
      final route = journey.resumeRoute.startsWith('/') ? journey.resumeRoute : '/${journey.resumeRoute}';
      context.push(route, extra: journey.resumeArgs);
    } catch (_) {
      try {
        context.pushNamed(journey.resumeRoute, extra: journey.resumeArgs);
      } catch (e) {
        debugPrint('Navigation error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final exp = journey.reservationExpiresAt;
    final now = DateTime.now();
    final isExpired = exp != null && exp.isBefore(now);
    final diffHours = exp != null && !isExpired ? exp.difference(now).inHours : 0;
    final isUrgent = exp != null && !isExpired && diffHours <= 48;

    return GestureDetector(
      onTap: () => _onResumeTap(context),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isExpired
                ? [colors.error.withValues(alpha: 0.1), colors.error.withValues(alpha: 0.03)]
                : [colors.primary.withValues(alpha: 0.12), colors.primary.withValues(alpha: 0.04)],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(color: isExpired ? colors.error : (isUrgent ? AppColors.warning : colors.primary.withValues(alpha: 0.3)), width: 1.5),
          boxShadow: [
            BoxShadow(color: colors.primary.withValues(alpha: 0.08), blurRadius: 16, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: isExpired ? colors.error : colors.primary,
                      child: const Icon(Icons.maps_home_work_outlined, color: AppColors.white, size: 18),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(journey.projectName, style: TextStyle(fontSize: AppFonts.bodyLarge, fontWeight: FontWeight.bold, color: colors.textPrimary)),
                        Text('وحدة رقم ${journey.unitNumber}', style: TextStyle(fontSize: AppFonts.bodySmall, color: colors.textSecondary, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
                  decoration: BoxDecoration(color: isExpired ? colors.error : colors.primary, borderRadius: BorderRadius.circular(AppRadius.round)),
                  child: Row(
                    children: [
                      Text(isExpired ? 'انتهت الصلاحية' : 'استئناف الرحلة', style: const TextStyle(fontSize: AppFonts.bodySmall, color: AppColors.white, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 4),
                      Icon(isExpired ? Icons.info_outline : Icons.arrow_forward_ios, color: AppColors.white, size: 12),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(color: colors.white.withValues(alpha: 0.7), borderRadius: BorderRadius.circular(AppRadius.lg)),
              child: Row(
                children: [
                  Icon(Icons.flag_outlined, color: colors.primary, size: 20),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text('الخطوة الحالية: ${journey.currentStep}', style: TextStyle(fontSize: AppFonts.bodyMedium, fontWeight: FontWeight.bold, color: colors.textPrimary)),
                  ),
                ],
              ),
            ),
            if (exp != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Icon(isExpired ? Icons.error_outline : Icons.timer_outlined, color: isExpired ? colors.error : (isUrgent ? AppColors.warning : colors.textSecondary), size: 16),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      isExpired
                          ? 'انتهت صلاحية الحجز، اضغط للتفاصيل'
                          : (isUrgent ? '⚠️ ينتهي الحجز خلال $diffHours ساعة - أكمل رحلتك الآن' : 'ينتهي الحجز في: ${exp.year}-${exp.month.toString().padLeft(2, '0')}-${exp.day.toString().padLeft(2, '0')}'),
                      style: TextStyle(fontSize: AppFonts.bodySmall, color: isExpired ? colors.error : (isUrgent ? AppColors.warning : colors.textSecondary), fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
