import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'contract_pdf_fonts.dart';

class ContractPdfHeader {
  static const primaryColor = PdfColor.fromInt(0xFF0F2942);
  static const goldColor = PdfColor.fromInt(0xFF8A6D3B);
  static const white = PdfColors.white;

  static pw.Widget buildTopBar({
    required String companyNameAr,
    required String companyPhone,
    required String companyCr,
    String companyVat = '310123456700003',
    pw.ImageProvider? logoProvider,
  }) {
    return pw.Container(
      color: primaryColor,
      padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          // Left: English
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Boroz Al-Asriya Real Estate',
                  style: ContractPdfFonts.b(sz: 7, color: goldColor)),
              pw.SizedBox(height: 1),
              pw.Text('Phone: $companyPhone',
                  style: ContractPdfFonts.s(sz: 5.5, color: white)),
              pw.Text('VAT No: $companyVat',
                  style: ContractPdfFonts.s(sz: 5.5, color: white)),
              pw.Text('CR No: $companyCr',
                  style: ContractPdfFonts.s(sz: 5.5, color: white)),
            ],
          ),
          // Center: Circular Emblem / Logo
          pw.Container(
            width: 32,
            height: 32,
            decoration: pw.BoxDecoration(
              shape: pw.BoxShape.circle,
              border: pw.Border.all(color: goldColor, width: 1.2),
              color: white,
            ),
            alignment: pw.Alignment.center,
            child: logoProvider != null
                ? pw.ClipOval(
                    child: pw.Image(logoProvider, width: 28, height: 28, fit: pw.BoxFit.contain),
                  )
                : pw.Text(
                    ContractPdfFonts.ar('بروز'),
                    style: ContractPdfFonts.b(sz: 6, color: primaryColor),
                  ),
          ),
          // Right: Arabic
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(ContractPdfFonts.ar(companyNameAr),
                  style: ContractPdfFonts.b(sz: 7, color: goldColor),
                  textDirection: pw.TextDirection.rtl),
              pw.SizedBox(height: 1),
              pw.Text(ContractPdfFonts.ar('الهاتف: $companyPhone'),
                  style: ContractPdfFonts.s(sz: 5.5, color: white),
                  textDirection: pw.TextDirection.rtl),
              pw.Text(ContractPdfFonts.ar('الرقم الضريبي: $companyVat'),
                  style: ContractPdfFonts.s(sz: 5.5, color: white),
                  textDirection: pw.TextDirection.rtl),
              pw.Text(ContractPdfFonts.ar('السجل التجاري: $companyCr'),
                  style: ContractPdfFonts.s(sz: 5.5, color: white),
                  textDirection: pw.TextDirection.rtl),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget buildTitleBlock(String contractType, String contractTitle) {
    final title = contractType == 'bone_purchase'
        ? 'عقد شراء عظم'
        : (contractType == 'finishing_execution'
            ? 'عقد تنفيذ أعمال تشطيب'
            : contractTitle);

    return pw.Container(
      width: double.infinity,
      alignment: pw.Alignment.center,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        mainAxisAlignment: pw.MainAxisAlignment.center,
        children: [
          pw.SizedBox(height: 4),
          pw.Text(
            ContractPdfFonts.ar('بسم الله الرحمن الرحيم'),
            style: ContractPdfFonts.b(sz: 9, color: goldColor),
            textAlign: pw.TextAlign.center,
            textDirection: pw.TextDirection.rtl,
          ),
          pw.SizedBox(height: 3),
          pw.Text(
            ContractPdfFonts.ar(title),
            style: ContractPdfFonts.b(sz: 11, color: primaryColor),
            textAlign: pw.TextAlign.center,
            textDirection: pw.TextDirection.rtl,
          ),
          pw.SizedBox(height: 3),
          pw.Container(width: 80, height: 0.8, color: goldColor),
          pw.SizedBox(height: 4),
          pw.Text(
            ContractPdfFonts.ar('الحمد لله والصلاة والسلام على رسول الله، وبعد:'),
            style: ContractPdfFonts.s(sz: 6.5, color: PdfColors.grey800),
            textAlign: pw.TextAlign.center,
            textDirection: pw.TextDirection.rtl,
          ),
          pw.SizedBox(height: 4),
        ],
      ),
    );
  }
}
