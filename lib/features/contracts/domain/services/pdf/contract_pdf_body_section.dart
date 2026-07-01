import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../entities/contract_entity.dart';
import 'contract_pdf_fonts.dart';

class ContractPdfBodySection {
  static const primaryColor = PdfColor.fromInt(0xFF0F2942);
  static const lightBg = PdfColor.fromInt(0xFFF8FAFC);
  static const borderColor = PdfColor.fromInt(0xFFCBD5E1);

  static List<pw.Widget> build(List<ContractBodyItemEntity> body) {
    final List<pw.Widget> widgets = [];

    for (final block in body) {
      final content = block.content?.trim() ?? '';

      // Skip duplicate title artifact
      if (content == 'تفاصيل العقد وشروطه نص العقد' ||
          content == 'تفاصيل العقد وشروطه') {
        continue;
      }

      if (block.type == 'paragraph' && content.isNotEmpty) {
        if (content.startsWith('فإنه في يوم')) {
          widgets.add(pw.SizedBox(height: 3));
          widgets.add(_buildHighlightedBox(content));
          widgets.add(pw.SizedBox(height: 3));
        } else {
          final isSubItem = content.startsWith('-');
          widgets.add(
            pw.Padding(
              padding: pw.EdgeInsets.only(
                  right: isSubItem ? 12.0 : 0.0, bottom: 2.0),
              child: pw.Text(
                ContractPdfFonts.ar(content),
                style: ContractPdfFonts.s(sz: 6.2, lineSpacing: 1.3),
                textDirection: pw.TextDirection.rtl,
                textAlign: pw.TextAlign.right,
              ),
            ),
          );
        }
      } else if (block.type == 'table') {
        final tableData = block.data;
        if (tableData != null && tableData.rows.isNotEmpty) {
          widgets.add(pw.SizedBox(height: 2));
          widgets.add(_buildTable(tableData));
          widgets.add(pw.SizedBox(height: 4));
        }
      }
    }

    return widgets;
  }

  static pw.Widget _buildHighlightedBox(String content) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        color: lightBg,
        border: pw.Border.all(color: borderColor, width: 0.8),
      ),
      padding: const pw.EdgeInsets.all(6),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        children: [
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            color: primaryColor,
            child: pw.Text(
              ContractPdfFonts.ar('نص العقد'),
              style: ContractPdfFonts.b(sz: 6, color: PdfColors.white),
            ),
          ),
          pw.SizedBox(height: 3),
          pw.Text(
            ContractPdfFonts.ar(content),
            style: ContractPdfFonts.s(sz: 6.2, lineSpacing: 1.3),
            textDirection: pw.TextDirection.rtl,
            textAlign: pw.TextAlign.right,
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildTable(ContractTableDataEntity tableData) {
    final rows = <pw.TableRow>[];

    if (tableData.headers.isNotEmpty) {
      rows.add(
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: primaryColor),
          children: tableData.headers
              .map((h) => _cell(h, isHeader: true))
              .toList(),
        ),
      );
    }

    for (int r = 0; r < tableData.rows.length; r++) {
      rows.add(
        pw.TableRow(
          decoration: pw.BoxDecoration(
            color: r.isOdd ? lightBg : PdfColors.white,
          ),
          children: tableData.rows[r].map((c) => _cell(c)).toList(),
        ),
      );
    }

    if (tableData.footer.isNotEmpty) {
      rows.add(
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: lightBg),
          children: tableData.footer
              .map((f) => _cell(f.content, isHeader: true, color: primaryColor))
              .toList(),
        ),
      );
    }

    return pw.Table(
      border: pw.TableBorder.all(color: borderColor, width: 0.5),
      children: rows,
    );
  }

  static pw.Widget _cell(String text,
      {bool isHeader = false, PdfColor? color}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2.5, horizontal: 3),
      child: pw.Text(
        ContractPdfFonts.ar(text),
        style: isHeader
            ? ContractPdfFonts.b(sz: 6, color: color ?? PdfColors.white)
            : ContractPdfFonts.s(sz: 6),
        textAlign: pw.TextAlign.center,
        textDirection: pw.TextDirection.rtl,
      ),
    );
  }
}
