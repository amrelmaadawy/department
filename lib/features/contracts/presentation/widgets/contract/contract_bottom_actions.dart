import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert';

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
  final dynamic contractType;
  final double price;
  final dynamic unit;

  final bool isLoading;
  final Future<void> Function(String base64Signature)? onSign;

  const ContractBottomActions({
    super.key,
    required this.isAgreed,
    required this.signatureController,
    required this.contractType,
    required this.price,
    this.unit,
    this.isLoading = false,
    this.onSign,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final isFormValid = isAgreed && signatureController.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
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
                        if (onSign != null) {
                          // Pass Base64 image to the callback
                          final base64String = base64Encode(signatureImage);
                          await onSign!(base64String);
                        } else {
                          // 2. Navigate to PDF Preview Screen and await result (Legacy Fallback)
                          if (context.mounted) {
                            final result = await context.push(AppRouter.contractPreview, extra: {'signatureImage': signatureImage, 'contractType': contractType, 'price': price, 'unit': unit});
                            if (result == true && context.mounted) {
                              // If user confirmed in preview screen, pop back to review screen
                              context.pop(true);
                            }
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
              isLoading: isLoading,
            ),
          ],
        ),
      ),
    );
  }
}
