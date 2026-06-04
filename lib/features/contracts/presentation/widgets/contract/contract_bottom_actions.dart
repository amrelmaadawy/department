import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:signature/signature.dart';

import 'package:apartment/core/theme/app_colors.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/core/widgets/custom_button.dart';
import 'package:apartment/core/routes/app_router.dart';
import 'package:apartment/l10n/app_localizations.dart';

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
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
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
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('يرجى الموافقة على الشروط والأحكام أولاً.')),
                        );
                      } else if (signatureController.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('يرجى رسم توقيعك في المربع المخصص.')),
                        );
                      }
                    }, 
              backgroundColor: isFormValid ? AppColors.primary : AppColors.border,
              textColor: AppColors.white,
            ),
          ],
        ),
      ),
    );
  }
}
