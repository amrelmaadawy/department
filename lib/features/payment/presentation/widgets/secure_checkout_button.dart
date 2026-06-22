import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:intl/intl.dart';

import '../../../../../core/theme/app_fonts.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/theme_extension.dart';
import '../../../../../l10n/app_localizations.dart';

class SecureCheckoutButton extends StatelessWidget {
  final double amount;
  final VoidCallback onPressed;
  final bool isLoading;

  const SecureCheckoutButton({
    super.key,
    required this.amount,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final formatter = NumberFormat.currency(symbol: '', decimalDigits: 0);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  FluentIcons.lock_closed_16_regular,
                  color: context.colors.textSecondary,
                  size: 16,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  l10n.securePayment,
                  style: TextStyle(
                    fontSize: AppFonts.labelSmall,
                    color: context.colors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: isLoading ? null : onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  elevation: 0,
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        l10n.payAmount(formatter.format(amount)),
                        style: const TextStyle(
                          fontSize: AppFonts.headlineSmall,
                          fontWeight: FontWeight.bold,
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
