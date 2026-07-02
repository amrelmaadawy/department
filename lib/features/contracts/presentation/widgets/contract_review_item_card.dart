import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_radius.dart';
import 'package:apartment/core/theme/theme_extension.dart';

class ContractReviewItemCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final int sequenceOrder;
  final bool isSigned;
  final bool isLocked;
  final bool isLoading;
  final String? failureMessage;
  final VoidCallback onSign;

  const ContractReviewItemCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.sequenceOrder,
    required this.isSigned,
    required this.onSign,
    this.isLocked = false,
    this.isLoading = false,
    this.failureMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: context.colors.white,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(
              color: isSigned ? context.colors.success : (failureMessage != null ? context.colors.error : context.colors.border),
              width: isSigned || failureMessage != null ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSigned
                      ? context.colors.success.withValues(alpha: 0.1)
                      : context.colors.primary.withValues(alpha: 0.05),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isSigned ? FluentIcons.signature_24_filled : FluentIcons.document_24_regular,
                  color: isSigned ? context.colors.success : context.colors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: AppFonts.headlineSmall,
                        fontWeight: FontWeight.bold,
                        color: context.colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: AppFonts.bodyMedium,
                        color: context.colors.textPrimary.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              _buildActionArea(context),
            ],
          ),
        ),
        if (failureMessage != null && !isSigned)
          Container(
            margin: const EdgeInsets.only(top: 4),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: context.colors.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Row(
              children: [
                Icon(FluentIcons.warning_24_filled, color: context.colors.error, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    failureMessage!,
                    style: TextStyle(color: context.colors.error, fontSize: AppFonts.bodySmall, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildActionArea(BuildContext context) {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }
    if (isSigned) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: context.colors.success.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(FluentIcons.checkmark_circle_24_filled, color: context.colors.success, size: 18),
            const SizedBox(width: 4),
            Text('موقّع ✓', style: TextStyle(color: context.colors.success, fontWeight: FontWeight.bold, fontSize: AppFonts.bodyMedium)),
          ],
        ),
      );
    }
    if (isLocked) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(color: context.colors.border.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(AppRadius.sm)),
        child: Text('يجب توقيع العقد السابق أولاً', style: TextStyle(color: context.colors.textPrimary.withValues(alpha: 0.5), fontSize: AppFonts.bodySmall)),
      );
    }
    return TextButton(
      onPressed: onSign,
      style: TextButton.styleFrom(foregroundColor: context.colors.gold),
      child: const Text('توقيع الآن', style: TextStyle(fontWeight: FontWeight.bold, fontSize: AppFonts.bodyLarge)),
    );
  }
}
