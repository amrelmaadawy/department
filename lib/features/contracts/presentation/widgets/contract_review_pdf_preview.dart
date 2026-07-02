import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/core/theme/theme_extension.dart';

class ContractReviewPdfPreview extends StatelessWidget {
  final bool pdfReady;
  final Uint8List? pdfBytes;
  final String contractNumber;

  const ContractReviewPdfPreview({
    super.key,
    required this.pdfReady,
    required this.pdfBytes,
    required this.contractNumber,
  });

  @override
  Widget build(BuildContext context) {
    if (!pdfReady || pdfBytes == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: context.colors.primary, strokeWidth: 3),
            const SizedBox(height: AppSpacing.md),
            Text(
              'جاري تحضير العقد...',
              style: TextStyle(fontSize: AppFonts.bodyMedium, color: context.colors.textSecondary),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.sm, right: AppSpacing.sm, top: AppSpacing.sm),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
        child: PdfPreview(
          build: (_) => pdfBytes!,
          initialPageFormat: PdfPageFormat.a4,
          maxPageWidth: 760,
          dpi: 150,
          allowPrinting: false,
          allowSharing: false,
          canChangeOrientation: false,
          canChangePageFormat: false,
          canDebug: false,
          pdfFileName: 'contract_$contractNumber.pdf',
          scrollViewDecoration: BoxDecoration(color: context.colors.background),
          onError: (context, error) => Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline_rounded, size: 48, color: context.colors.error),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'تعذر عرض ملف العقد',
                    style: TextStyle(fontSize: AppFonts.headlineSmall, fontWeight: FontWeight.bold, color: context.colors.textPrimary),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    error.toString().replaceAll('Exception: ', ''),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: AppFonts.bodyMedium, color: context.colors.textSecondary),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
