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
        pw.SizedBox(height: 8),
        pw.Container(height: 0.8, color: borderColor),
        pw.SizedBox(height: 8),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Company Seal (Left/Second party in display order or Right)
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                  ContractPdfFonts.ar('الطرف الأول: الشركة (الختم المعتمد)'),
                  style: ContractPdfFonts.b(sz: 6.5),
                ),
                pw.SizedBox(height: 6),
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(
                      horizontal: 10, vertical: 6),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: greenColor, width: 1.2),
                    borderRadius:
                        const pw.BorderRadius.all(pw.Radius.circular(4)),
                  ),
                  child: pw.Column(
                    children: [
                      pw.Text(
                        ContractPdfFonts.ar('v معتمد إلكترونياً'),
                        style: ContractPdfFonts.b(sz: 7, color: greenColor),
                      ),
                      pw.SizedBox(height: 2),
                      pw.Text(
                        ContractPdfFonts.ar('شركة بروز العصرية للعقارات'),
                        style: ContractPdfFonts.s(sz: 5.5, color: greenColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Client Signature
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                  ContractPdfFonts.ar('الطرف الثاني: العميل (التوقيع)'),
                  style: ContractPdfFonts.b(sz: 6.5),
                ),
                pw.SizedBox(height: 6),
                pw.Container(
                  height: 42,
                  width: 130,
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: borderColor, width: 0.8),
                    color: PdfColors.white,
                  ),
                  alignment: pw.Alignment.center,
                  child: signatureProvider != null
                      ? pw.Image(signatureProvider, fit: pw.BoxFit.contain)
                      : (hasCustomerSignature
                          ? pw.Text(
                              ContractPdfFonts.ar('تم التوقيع إلكترونياً'),
                              style:
                                  ContractPdfFonts.b(sz: 6, color: greenColor),
                            )
                          : pw.Text(
                              ContractPdfFonts.ar('في انتظار التوقيع'),
                              style: ContractPdfFonts.b(sz: 6.5, color: redColor),
                            )),
                ),
              ],
            ),
          ],
        ),
        pw.SizedBox(height: 10),
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
