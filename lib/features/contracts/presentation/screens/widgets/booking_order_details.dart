import 'package:apartment/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/l10n/app_localizations.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import 'package:apartment/core/widgets/app_toast.dart';

class BookingOrderDetails extends StatelessWidget {
  final String orderId;

  const BookingOrderDetails({super.key, required this.orderId});

  void _copyOrderId(BuildContext context) {
    Clipboard.setData(ClipboardData(text: orderId));
    AppToast.showSuccess(context, AppLocalizations.of(context)!.orderNumberCopiedSuccessfully);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Format expected date (Mock: 48 hours from now)
    final expectedDate = DateTime.now().add(const Duration(hours: 48));
    final expectedDateStr =
        '${expectedDate.day} / ${expectedDate.month} / ${expectedDate.year}';

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        color: context.colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(
          color: context.colors.gold.withValues(alpha: 0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: context.colors.gold.withValues(alpha: 0.05),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.orderNumber,
                style: TextStyle(
                  fontSize: AppFonts.bodyMedium,
                  color: context.colors.textPrimary.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          orderId,
                          style: TextStyle(
                            fontSize: AppFonts.headlineSmall,
                            fontWeight: FontWeight.bold,
                            color: context.colors.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    InkWell(
                      onTap: () => _copyOrderId(context),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(
                          FluentIcons.copy_20_regular,
                          color: context.colors.gold,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
            child: Row(
              children: List.generate(
                150 ~/ 4,
                (index) => Expanded(
                  child: Container(
                    color: index % 2 == 0
                        ? context.colors.border.withValues(alpha: 0.5)
                        : AppColors.transparent,
                    height: 1.5,
                  ),
                ),
              ),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  l10n.expectedVisitDate,
                  style: TextStyle(
                    fontSize: AppFonts.bodyMedium,
                    color: context.colors.textPrimary.withValues(alpha: 0.7),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                expectedDateStr,
                style: TextStyle(
                  fontSize: AppFonts.headlineSmall,
                  fontWeight: FontWeight.w600,
                  color: context.colors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
