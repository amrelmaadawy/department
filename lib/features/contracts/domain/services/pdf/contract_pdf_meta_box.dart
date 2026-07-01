import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'contract_pdf_fonts.dart';

class ContractPdfMetaBox {
  static const lightBg = PdfColor.fromInt(0xFFF8FAFC);
  static const borderColor = PdfColor.fromInt(0xFFE2E8F0);
  static const primaryColor = PdfColor.fromInt(0xFF0F2942);

  static pw.Widget build({
    required String customerName,
    required String customerPhone,
    required String customerEmail,
    required String contractNumber,
    required String formattedDate,
    required String statusLabel,
    required String typeLabel,
  }) {
    final typeShort = typeLabel.contains('عظم') ? 'شراء عظم' : 'تشطيب';

    PdfColor badgeColor = const PdfColor.fromInt(0xFFD97706); // Amber
    if (statusLabel.contains('تم') || statusLabel.contains('موقع')) {
      badgeColor = const PdfColor.fromInt(0xFF059669); // Green
    } else if (statusLabel.contains('مسودة')) {
      badgeColor = const PdfColor.fromInt(0xFF6B7280); // Gray
    }

    return pw.Container(
      decoration: pw.BoxDecoration(
        color: lightBg,
        border: pw.Border.all(color: borderColor, width: 0.8),
      ),
      padding: const pw.EdgeInsets.all(6),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // Left column (North / Left in RTL document layout)
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                _row('رقم العقد', contractNumber),
                pw.SizedBox(height: 3),
                _row('تاريخ العقد', formattedDate),
                pw.SizedBox(height: 3),
                _row('نوع العقد', typeShort),
              ],
            ),
          ),
          pw.SizedBox(width: 8),
          // Right column (South / Right in RTL document layout)
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                _row('العميل', customerName),
                pw.SizedBox(height: 3),
                _row('التواصل', '$customerPhone / $customerEmail'),
                pw.SizedBox(height: 3),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Container(
                      padding: const pw.EdgeInsets.symmetric(
                          horizontal: 4, vertical: 1),
                      decoration: pw.BoxDecoration(color: badgeColor),
                      child: pw.Text(
                        ContractPdfFonts.ar(statusLabel),
                        style: ContractPdfFonts.b(
                            sz: 5.5, color: PdfColors.white),
                      ),
                    ),
                    pw.SizedBox(width: 4),
                    pw.Text(
                      ContractPdfFonts.ar(':حالة العقد'),
                      style: ContractPdfFonts.b(sz: 6, color: primaryColor),
                      textDirection: pw.TextDirection.rtl,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget buildSectionTitle(String title) {
    return pw.Container(
      width: double.infinity,
      color: const PdfColor.fromInt(0xFFE2E8F0),
      padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      child: pw.Text(
        ContractPdfFonts.ar(title),
        style: ContractPdfFonts.b(sz: 7.5, color: primaryColor),
        textDirection: pw.TextDirection.rtl,
        textAlign: pw.TextAlign.right,
      ),
    );
  }

  static pw.Widget _row(String label, String value) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.end,
      children: [
        pw.Expanded(
          child: pw.Text(
            ContractPdfFonts.ar(value),
            style: ContractPdfFonts.s(sz: 6),
            textDirection: pw.TextDirection.rtl,
            textAlign: pw.TextAlign.right,
          ),
        ),
        pw.SizedBox(width: 4),
        pw.Text(
          ContractPdfFonts.ar(':$label'),
          style: ContractPdfFonts.b(sz: 6, color: primaryColor),
          textDirection: pw.TextDirection.rtl,
        ),
      ],
    );
  }
}
