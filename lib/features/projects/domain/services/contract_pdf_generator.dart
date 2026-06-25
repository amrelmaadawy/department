import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../contracts/domain/entities/contract_entity.dart';

class ContractPdfGenerator {
  static Future<Uint8List> generateContractBytes(
    PdfPageFormat format,
    Uint8List signatureImage,
    ContractEntity contract,
  ) async {
    final pdf = pw.Document();

    final fontData = await rootBundle.load('assets/font/Cairo-Regular.ttf');
    final fontBoldData = await rootBundle.load('assets/font/Cairo-Bold.ttf');

    final ttf = pw.Font.ttf(fontData);
    final ttfBold = pw.Font.ttf(fontBoldData);

    final PdfColor primaryBlue = PdfColor.fromHex('#1B3358');
    final PdfColor lightBlueBg = PdfColor.fromHex('#EEF2F8');
    const PdfColor textBlack = PdfColors.black;
    const PdfColor textGrey = PdfColors.grey700;

    final String currentDate =
        '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}';

    String norm(String text) {
      const ar = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
      const en = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
      String t = text;
      for (int i = 0; i < ar.length; i++) {
        t = t.replaceAll(ar[i], en[i]);
      }
      t = t.replaceAllMapped(
        RegExp(r'(\d{2,4})/(\d{1,2})/(\d{1,2})'),
        (m) => '${m[1]}-${m[2]}-${m[3]}',
      );
      return t;
    }

    // Section title styled like reference image: blue right-bar, AR on right, EN on left
    pw.Widget _sectionTitle(String arTitle) {
      return pw.Container(
        margin: const pw.EdgeInsets.only(top: 10, bottom: 5),
        padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 6),
        decoration: pw.BoxDecoration(
          color: lightBlueBg,
          border: pw.Border(
            right: pw.BorderSide(color: primaryBlue, width: 3),
          ),
        ),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            // EN label on left
            pw.Text(
              'Contract Terms',
              style: pw.TextStyle(font: ttf, fontSize: 7, color: primaryBlue),
            ),
            // AR title on right
            pw.Text(
              norm(arTitle),
              style: pw.TextStyle(font: ttfBold, fontSize: 9, color: primaryBlue),
            ),
          ],
        ),
      );
    }

    // Build body content
    final List<pw.Widget> bodyWidgets = [];

    for (final item in contract.contractBody) {
      if (item.type == 'title') {
        bodyWidgets.add(_sectionTitle(item.content ?? ''));
      } else if (item.type == 'paragraph') {
        bodyWidgets.add(
          pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 4),
            child: pw.Text(
              norm(item.content ?? ''),
              style: pw.TextStyle(
                font: ttf,
                fontSize: 8,
                lineSpacing: 1.4,
                color: textBlack,
              ),
              textAlign: pw.TextAlign.right,
              textDirection: pw.TextDirection.rtl,
            ),
          ),
        );
      } else if (item.type == 'list' && item.items != null) {
        final listItems = <pw.Widget>[];
        for (final li in item.items!) {
          if (li.type == 'text') {
            listItems.add(
              pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 2),
                child: pw.Text(
                  norm(li.content),
                  style: pw.TextStyle(font: ttf, fontSize: 7.5, color: textBlack),
                  textAlign: pw.TextAlign.right,
                  textDirection: pw.TextDirection.rtl,
                ),
              ),
            );
          } else if (li.type == 'list_item') {
            listItems.add(
              pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 2, right: 4),
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    // AR text expands on the right
                    pw.Expanded(
                      child: pw.Text(
                        norm(li.content),
                        style: pw.TextStyle(
                          font: ttf,
                          fontSize: 7.5,
                          lineSpacing: 1.3,
                          color: textBlack,
                        ),
                        textAlign: pw.TextAlign.right,
                        textDirection: pw.TextDirection.rtl,
                      ),
                    ),
                    pw.SizedBox(width: 5),
                    // Bullet dot on the far right
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(top: 3),
                      child: pw.Container(
                        width: 3,
                        height: 3,
                        decoration: pw.BoxDecoration(
                          color: primaryBlue,
                          shape: pw.BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        }
        bodyWidgets.add(
          pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 6),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.stretch,
              children: listItems,
            ),
          ),
        );
      } else if (item.type == 'table' && item.data != null) {
        final td = item.data!;
        final rows = <pw.TableRow>[];

        if (td.headers.isNotEmpty) {
          rows.add(pw.TableRow(
            decoration: pw.BoxDecoration(color: lightBlueBg),
            children: td.headers.map((h) {
              return pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 5, horizontal: 6),
                child: pw.Text(
                  norm(h),
                  style: pw.TextStyle(font: ttfBold, fontSize: 7.5, color: primaryBlue),
                  textAlign: pw.TextAlign.center,
                  textDirection: pw.TextDirection.rtl,
                ),
              );
            }).toList(),
          ));
        }

        for (int i = 0; i < td.rows.length; i++) {
          final row = td.rows[i];
          rows.add(pw.TableRow(
            decoration: i.isOdd ? null : pw.BoxDecoration(color: PdfColors.grey100),
            children: row.map((cell) {
              return pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 5, horizontal: 6),
                child: pw.Text(
                  norm(cell),
                  style: pw.TextStyle(font: ttf, fontSize: 7.5, color: textBlack),
                  textAlign: pw.TextAlign.center,
                  textDirection: pw.TextDirection.rtl,
                ),
              );
            }).toList(),
          ));
        }

        bodyWidgets.add(
          pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 8),
            child: pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
              children: rows,
            ),
          ),
        );
      }
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: format,
        maxPages: 4,
        margin: const pw.EdgeInsets.fromLTRB(24, 20, 24, 20),
        // No global RTL — we handle each widget manually to avoid row reordering
        theme: pw.ThemeData.withFont(base: ttf, bold: ttfBold),

        // ─── PAGE HEADER ─────────────────────────────────────────────
        header: (_) => pw.Column(
          children: [
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Left column: EN company info
                pw.Expanded(
                  flex: 3,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Broz Real Estate Co.',
                          style: pw.TextStyle(font: ttfBold, fontSize: 8)),
                      pw.SizedBox(height: 2),
                      pw.Text('Tell: 920012345',
                          style: pw.TextStyle(font: ttf, fontSize: 6.5, color: textGrey)),
                      pw.Text('VAT No: 311111111111113',
                          style: pw.TextStyle(font: ttf, fontSize: 6.5, color: textGrey)),
                      pw.Text('CR No: 1010987654',
                          style: pw.TextStyle(font: ttf, fontSize: 6.5, color: textGrey)),
                    ],
                  ),
                ),
                // Center: logo + contract type badge
                pw.Expanded(
                  flex: 4,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Text('Broz | بروز',
                          style: pw.TextStyle(font: ttfBold, fontSize: 13, color: primaryBlue)),
                      pw.SizedBox(height: 4),
                      pw.Container(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                        decoration: pw.BoxDecoration(
                          color: primaryBlue,
                          borderRadius: pw.BorderRadius.circular(3),
                        ),
                        child: pw.Text(
                          contract.typeLabel,
                          style: pw.TextStyle(
                            font: ttfBold,
                            fontSize: 8,
                            color: PdfColors.white,
                          ),
                          textDirection: pw.TextDirection.rtl,
                        ),
                      ),
                    ],
                  ),
                ),
                // Right column: AR company info
                pw.Expanded(
                  flex: 3,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('شركة بروز العقارية',
                          style: pw.TextStyle(font: ttfBold, fontSize: 8),
                          textDirection: pw.TextDirection.rtl),
                      pw.SizedBox(height: 2),
                      pw.Text('الهاتف: 920012345',
                          style: pw.TextStyle(font: ttf, fontSize: 6.5, color: textGrey),
                          textAlign: pw.TextAlign.right,
                          textDirection: pw.TextDirection.rtl),
                      pw.Text('الرقم الضريبي: 311111111111113',
                          style: pw.TextStyle(font: ttf, fontSize: 6.5, color: textGrey),
                          textAlign: pw.TextAlign.right,
                          textDirection: pw.TextDirection.rtl),
                      pw.Text('السجل التجاري: 1010987654',
                          style: pw.TextStyle(font: ttf, fontSize: 6.5, color: textGrey),
                          textAlign: pw.TextAlign.right,
                          textDirection: pw.TextDirection.rtl),
                    ],
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 6),
            pw.Divider(color: primaryBlue, thickness: 1),
            pw.SizedBox(height: 4),
          ],
        ),

        // ─── PAGE FOOTER ─────────────────────────────────────────────
        footer: (_) => pw.Column(
          children: [
            pw.Divider(color: PdfColors.grey300, thickness: 0.5),
            pw.SizedBox(height: 3),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('System Admin',
                    style: pw.TextStyle(font: ttf, fontSize: 6.5, color: textGrey)),
                pw.Text('تاريخ الطباعة: $currentDate',
                    style: pw.TextStyle(font: ttf, fontSize: 6.5, color: textGrey),
                    textDirection: pw.TextDirection.rtl),
                pw.Text('رقم العقد: ${contract.id}',
                    style: pw.TextStyle(font: ttf, fontSize: 6.5, color: textGrey),
                    textDirection: pw.TextDirection.rtl),
              ],
            ),
          ],
        ),

        // ─── PAGE BODY ───────────────────────────────────────────────
        build: (_) => [
          // Top meta row
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            decoration: pw.BoxDecoration(
              color: lightBlueBg,
              border: pw.Border.all(color: PdfColors.grey300, width: 0.5),
              borderRadius: pw.BorderRadius.circular(2),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Contract No: ${contract.id}',
                    style: pw.TextStyle(font: ttf, fontSize: 7, color: textBlack)),
                pw.Text('التاريخ: $currentDate',
                    style: pw.TextStyle(font: ttf, fontSize: 7, color: textBlack),
                    textDirection: pw.TextDirection.rtl),
              ],
            ),
          ),
          pw.SizedBox(height: 10),

          // Contract body sections
          ...bodyWidgets,

          // ─── SIGNATURES ──────────────────────────────────────────
          pw.SizedBox(height: 20),
          pw.Divider(color: PdfColors.grey300),
          pw.SizedBox(height: 12),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Left: First party (company)
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Text('توقيع الطرف الأول',
                      style: pw.TextStyle(font: ttfBold, fontSize: 8.5, color: textBlack),
                      textDirection: pw.TextDirection.rtl),
                  pw.Text('First Party Signature',
                      style: pw.TextStyle(font: ttf, fontSize: 7, color: textGrey)),
                  pw.SizedBox(height: 32),
                  pw.Container(width: 140, height: 0.7, color: textBlack),
                  pw.SizedBox(height: 3),
                  pw.Text('الشركة',
                      style: pw.TextStyle(font: ttf, fontSize: 6.5, color: textGrey),
                      textDirection: pw.TextDirection.rtl),
                ],
              ),
              // Right: Second party (client)
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Text('توقيع الطرف الثاني',
                      style: pw.TextStyle(font: ttfBold, fontSize: 8.5, color: textBlack),
                      textDirection: pw.TextDirection.rtl),
                  pw.Text('Second Party Signature',
                      style: pw.TextStyle(font: ttf, fontSize: 7, color: textGrey)),
                  pw.SizedBox(height: 8),
                  if (signatureImage.isNotEmpty) ...[
                    pw.Container(
                      height: 24,
                      width: 140,
                      child: pw.Image(pw.MemoryImage(signatureImage),
                          fit: pw.BoxFit.contain),
                    ),
                  ] else ...[
                    pw.SizedBox(height: 24),
                  ],
                  pw.Container(width: 140, height: 0.7, color: textBlack),
                  pw.SizedBox(height: 3),
                  pw.Text('العميل',
                      style: pw.TextStyle(font: ttf, fontSize: 6.5, color: textGrey),
                      textDirection: pw.TextDirection.rtl),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 10),
        ],
      ),
    );

    return pdf.save();
  }
}
