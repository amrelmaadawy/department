import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'contract_pdf_fonts.dart';

class ContractPdfSignatures {
  static const borderColor = PdfColor.fromInt(0xFFCBD5E1);
  static const greenColor = PdfColor.fromInt(0xFF059669);
  static const amberColor = PdfColor.fromInt(0xFFD97706);
  static const redColor = PdfColor.fromInt(0xFFDC2626);

  static pw.Widget buildSignatures({
    required pw.ImageProvider? signatureProvider,
    required bool hasCustomerSignature,
  }) {
    return pw.Column(
      children: [
        pw.Container(height: 0.8, color: borderColor),
        pw.SizedBox(height: 6),
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // First in RTL → appears on RIGHT: Client Signature
            pw.Expanded(
              child: pw.Container(
                padding: const pw.EdgeInsets.all(6),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: borderColor, width: 0.8),
                  borderRadius: const pw.BorderRadius.all(pw.Radius.circular(3)),
                  color: PdfColors.white,
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Text(
                      ContractPdfFonts.ar('الطرف الأول: العميل'),
                      style: ContractPdfFonts.b(sz: 6, color: const PdfColor.fromInt(0xFF0F2942)),
                      textDirection: pw.TextDirection.rtl,
                    ),
                    pw.SizedBox(height: 4),
                    pw.Container(
                      height: 36,
                      width: double.infinity,
                      alignment: pw.Alignment.center,
                      child: signatureProvider != null
                          ? pw.Image(signatureProvider, fit: pw.BoxFit.contain)
                          : (hasCustomerSignature
                              ? pw.Text(
                                  ContractPdfFonts.ar('تم التوقيع الكترونيا'),
                                  style: ContractPdfFonts.b(sz: 6, color: greenColor),
                                  textDirection: pw.TextDirection.rtl,
                                )
                              : pw.Text(
                                  ContractPdfFonts.ar('في انتظار التوقيع'),
                                  style: ContractPdfFonts.b(sz: 6, color: redColor),
                                  textDirection: pw.TextDirection.rtl,
                                )),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Container(height: 0.5, color: borderColor),
                    pw.SizedBox(height: 3),
                    pw.Text(
                      ContractPdfFonts.ar('التوقيع'),
                      style: ContractPdfFonts.s(sz: 5.5, color: PdfColors.grey600),
                      textDirection: pw.TextDirection.rtl,
                    ),
                  ],
                ),
              ),
            ),
            pw.SizedBox(width: 8),
            // Last in RTL → appears on LEFT: Company Seal
            pw.Expanded(
              child: pw.Container(
                padding: const pw.EdgeInsets.all(6),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: greenColor, width: 0.8),
                  borderRadius: const pw.BorderRadius.all(pw.Radius.circular(3)),
                  color: const PdfColor.fromInt(0xFFF0FDF4),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Text(
                      ContractPdfFonts.ar('الطرف الثاني: الشركة'),
                      style: ContractPdfFonts.b(sz: 6, color: greenColor),
                      textDirection: pw.TextDirection.rtl,
                    ),
                    pw.SizedBox(height: 4),
                    pw.Container(
                      height: 36,
                      alignment: pw.Alignment.center,
                      child: pw.Text(
                        ContractPdfFonts.ar('v معتمد الكترونيا'),
                        style: ContractPdfFonts.b(sz: 7.5, color: greenColor),
                        textDirection: pw.TextDirection.rtl,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Container(height: 0.5, color: greenColor),
                    pw.SizedBox(height: 3),
                    pw.Text(
                      ContractPdfFonts.ar('التوقيع / الختم'),
                      style: ContractPdfFonts.s(sz: 5.5, color: PdfColors.grey600),
                      textDirection: pw.TextDirection.rtl,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 6),
      ],
    );
  }

  static pw.Widget buildFooter(String generatedAt) {
    return pw.Column(
      children: [
        pw.Container(height: 0.5, color: borderColor),
        pw.SizedBox(height: 4),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              'Powered by Shatabk Bukefek | $generatedAt',
              style: ContractPdfFonts.s(sz: 5.5, color: PdfColors.grey600),
            ),
            pw.Text(
              ContractPdfFonts.ar(
                  'أُنشئ بواسطة نظام شطبها بكيفك لإدارة العقارات والمشاريع'),
              style: ContractPdfFonts.s(sz: 5.5, color: PdfColors.grey600),
              textDirection: pw.TextDirection.rtl,
            ),
          ],
        ),
      ],
    );
  }
}
