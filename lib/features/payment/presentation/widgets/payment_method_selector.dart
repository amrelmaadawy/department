import 'package:apartment/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import '../../../../../core/theme/app_fonts.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/theme_extension.dart';
import '../../../../../l10n/app_localizations.dart';

enum PaymentMethodType { applePay, creditCard, bankTransfer }

class PaymentMethodSelector extends StatelessWidget {
  final PaymentMethodType selectedMethod;
  final ValueChanged<PaymentMethodType> onMethodChanged;

  const PaymentMethodSelector({
    super.key,
    required this.selectedMethod,
    required this.onMethodChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      children: [
        _buildMethodItem(
          context: context,
          type: PaymentMethodType.applePay,
          title: l10n.applePay,
          icon: FluentIcons.payment_24_regular,
          iconColor: AppColors.black, // Apple pay is usually black/white
        ),
        const SizedBox(height: AppSpacing.sm),
        _buildMethodItem(
          context: context,
          type: PaymentMethodType.creditCard,
          title: l10n.creditCard,
          icon: Icons.credit_card_outlined,
          iconColor: context.colors.primary,
        ),
        const SizedBox(height: AppSpacing.sm),
        _buildMethodItem(
          context: context,
          type: PaymentMethodType.bankTransfer,
          title: l10n.bankTransfer,
          icon: FluentIcons.building_bank_24_regular,
          iconColor: context.colors.textSecondary,
        ),
      ],
    );
  }

  Widget _buildMethodItem({
    required BuildContext context,
    required PaymentMethodType type,
    required String title,
    required IconData icon,
    required Color iconColor,
  }) {
    final isSelected = selectedMethod == type;

    return GestureDetector(
      onTap: () => onMethodChanged(type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isSelected ? context.colors.gold.withValues(alpha: 0.05) : context.colors.white,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isSelected ? context.colors.gold : context.colors.border,
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: isSelected ? context.colors.gold.withValues(alpha: 0.1) : context.colors.background,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Icon(icon, color: isSelected ? context.colors.gold : iconColor, size: 24),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: AppFonts.bodyLarge,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: context.colors.textPrimary,
                ),
              ),
            ),
            Icon(
              isSelected ? FluentIcons.radio_button_24_filled : FluentIcons.circle_24_regular,
              color: isSelected ? context.colors.gold : context.colors.border,
            ),
          ],
        ),
      ),
    );
  }
}
