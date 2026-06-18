import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/core/widgets/custom_button.dart';
import 'package:apartment/features/projects/domain/services/contract_pdf_generator.dart';
import 'package:apartment/l10n/app_localizations.dart';
import 'package:apartment/core/theme/theme_extension.dart';


class ContractPreviewScreen extends StatelessWidget {
  final Uint8List signatureImage;
  final dynamic contractType;
  final double price;
  final dynamic unit;

  const ContractPreviewScreen({
    super.key,
    required this.signatureImage,
    required this.contractType,
    required this.price,
    this.unit,
  });

  @override
  Widget build(BuildContext context) {
    // Ideally use localization for texts
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: context.colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: AppBar(
            title: Text(
              l10n.finalApproval,
              style: TextStyle(
                color: context.colors.primary,
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
                icon: Icon(Icons.share_outlined, color: context.colors.primary, size: 22),
                onPressed: () async {
                  final bytes = await ContractPdfGenerator.generateContractBytes(
                    PdfPageFormat.a4,
                    signatureImage,
                    contractType,
                    price,
                    unit,
                  );
                  await Printing.sharePdf(
                    bytes: bytes,
                    filename: 'Unit_Booking_Contract.pdf',
                  );
                },
              ),
              SizedBox(width: 10),
            ],
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: context.colors.primary, size: 20),
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
                primaryColor: context.colors.primary,
                scaffoldBackgroundColor: context.colors.background,
              ),
              child: PdfPreview(
                build: (format) => ContractPdfGenerator.generateContractBytes(
                  format,
                  signatureImage,
                  contractType,
                  price,
                  unit,
                ),
                useActions: false, // Hides the big internal toolbar completely
                canDebug: false,
                pdfFileName: 'Unit_Booking_Contract.pdf',
                scrollViewDecoration: BoxDecoration(
                  color: context.colors.background,
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.lg),
            decoration: BoxDecoration(
              color: context.colors.white,
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
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: context.colors.gold.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.verified_user_rounded, color: context.colors.gold, size: 24),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: Text(
                          l10n.contractGeneratedSuccess,
                          style: TextStyle(
                            fontSize: 12,
                            color: context.colors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  CustomButton(
                    text: l10n.confirmReturnContracts,
                    backgroundColor: context.colors.primary,
                    textColor: context.colors.white,
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
