import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

import 'package:apartment/core/routes/app_router.dart';
import 'package:apartment/core/theme/app_colors.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/core/widgets/custom_button.dart';
import 'package:apartment/features/projects/domain/services/contract_pdf_generator.dart';
import 'package:apartment/l10n/app_localizations.dart';

class ContractPreviewScreen extends StatelessWidget {
  final Uint8List signatureImage;

  const ContractPreviewScreen({
    super.key,
    required this.signatureImage,
  });

  @override
  Widget build(BuildContext context) {
    // Ideally use localization for texts
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: AppBar(
            title: const Text(
              'الاعتماد النهائي',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.share_outlined, color: AppColors.primary, size: 22),
                onPressed: () async {
                  final bytes = await ContractPdfGenerator.generateContractBytes(
                    PdfPageFormat.a4,
                    signatureImage,
                  );
                  await Printing.sharePdf(
                    bytes: bytes,
                    filename: 'Unit_Booking_Contract.pdf',
                  );
                },
              ),
              const SizedBox(width: 10),
            ],
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: AppColors.primary, size: 20),
              onPressed: () => context.pop(),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Theme(
              data: Theme.of(context).copyWith(
                primaryColor: AppColors.primary,
                scaffoldBackgroundColor: AppColors.background,
              ),
              child: PdfPreview(
                build: (format) => ContractPdfGenerator.generateContractBytes(
                  format,
                  signatureImage,
                ),
                useActions: false, // Hides the big internal toolbar completely
                canDebug: false,
                pdfFileName: 'Unit_Booking_Contract.pdf',
                scrollViewDecoration: const BoxDecoration(
                  color: AppColors.background,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.gold.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.verified_user_rounded, color: AppColors.gold, size: 24),
                      ),
                      const SizedBox(width: 15),
                      const Expanded(
                        child: Text(
                          'تم إنشاء العقد بنجاح وموثق بتوقيعك الإلكتروني. يمكنك حفظ نسخة أو المتابعة.',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    text: 'تأكيد والرجوع لمراجعة العقود',
                    backgroundColor: AppColors.primary,
                    textColor: AppColors.white,
                    onPressed: () {
                      context.pop(true);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
