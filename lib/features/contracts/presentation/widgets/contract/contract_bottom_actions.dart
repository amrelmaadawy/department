import 'dart:typed_data';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/core/widgets/custom_button.dart';
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
  // Now carries BOTH the base64 string (for the API) and raw bytes (for PDF)
  final Future<void> Function(String base64Signature, Uint8List rawBytes)? onSign;

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
      padding: const EdgeInsets.all(AppSpacing.md),
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
                      // Export signature ONCE with explicit dimensions for a crisp PDF render.
                      // The same bytes are reused for both: API (base64) and PDF (raw PNG).
                      final rawBytes = await signatureController.toPngBytes(
                        width: 800,
                        height: 300,
                      );

                      if (rawBytes != null && rawBytes.isNotEmpty && onSign != null) {
                        final base64String = base64Encode(rawBytes);
                        await onSign!(base64String, rawBytes);
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
