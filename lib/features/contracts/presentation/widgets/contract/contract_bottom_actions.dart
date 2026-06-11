import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:signature/signature.dart';

import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/core/widgets/custom_button.dart';
import 'package:apartment/core/routes/app_router.dart';
import 'package:apartment/l10n/app_localizations.dart';
import 'package:apartment/core/widgets/app_toast.dart';
import 'package:apartment/core/theme/theme_extension.dart';


class ContractBottomActions extends StatelessWidget {
  final bool isAgreed;
  final SignatureController signatureController;

  const ContractBottomActions({
    super.key,
    required this.isAgreed,
    required this.signatureController,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final isFormValid = isAgreed && signatureController.isNotEmpty;

    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomButton(
              text: l10n.confirmBookingAndProceed,
              onPressed: isFormValid
                  ? () async {
                      // 1. Export signature to image
                      final signatureImage = await signatureController.toPngBytes();
                      
                      if (signatureImage != null) {
                        // 2. Navigate to PDF Preview Screen and await result
                        if (context.mounted) {
                          final result = await context.push(AppRouter.contractPreview, extra: signatureImage);
                          if (result == true && context.mounted) {
                            // If user confirmed in preview screen, pop back to review screen
                            context.pop(true);
                          }
                        }
                      }
                    }
                  : () {
                      if (!isAgreed) {
                        AppToast.showError(context, l10n.errAgreeTerms);
                      } else if (signatureController.isEmpty) {
                        AppToast.showError(context, l10n.errSignBox);
                      }
                    }, 
              backgroundColor: isFormValid ? context.colors.primary : context.colors.border,
              textColor: context.colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
