import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'contract_pdf_clauses_data.dart';
import 'contract_pdf_fonts.dart';

class ContractPdfClausesGrid {
  static const headerColor = PdfColor.fromInt(0xFF0F2942);
  static const borderColor = PdfColor.fromInt(0xFFCBD5E1);

  static List<pw.Widget> build(List<ContractClauseModel> clauses) {
    final List<pw.Widget> rows = [];

    for (int i = 0; i < clauses.length; i += 2) {
      final card1 = _buildCard(clauses[i]);
      final card2 = i + 1 < clauses.length
          ? _buildCard(clauses[i + 1])
          : pw.Container();

      rows.add(
        pw.Container(
          margin: const pw.EdgeInsets.only(bottom: 6),
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(child: card1),
              pw.SizedBox(width: 6),
              pw.Expanded(child: card2),
            ],
          ),
        ),
      );
    }

    return rows;
  }

  static pw.Widget _buildCard(ContractClauseModel clause) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        border: pw.Border.all(color: borderColor, width: 0.8),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(3)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
        children: [
          // Navy Header
          pw.Container(
            color: headerColor,
            padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            child: pw.Text(
              ContractPdfFonts.ar(clause.title),
              style: ContractPdfFonts.b(sz: 6.5, color: PdfColors.white),
              textDirection: pw.TextDirection.rtl,
              textAlign: pw.TextAlign.right,
            ),
          ),
          // Body
          pw.Padding(
            padding: const pw.EdgeInsets.all(5),
            child: pw.Text(
              ContractPdfFonts.ar(clause.content),
              style: ContractPdfFonts.s(sz: 5.8, lineSpacing: 1.2),
              textDirection: pw.TextDirection.rtl,
              textAlign: pw.TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
