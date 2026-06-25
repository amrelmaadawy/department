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

    final contractTitleStr = contract.typeLabel;
    
    // Theme Colors
    final PdfColor primaryBlue = PdfColor.fromHex('#1B3358');
    final PdfColor primaryGreen = PdfColor.fromHex('#218A6A');
    final PdfColor lightGreen = PdfColor.fromHex('#AEE0CD');
    const PdfColor textBlack = PdfColors.black;
    
    final String currentDate = "${DateTime.now().year}/${DateTime.now().month.toString().padLeft(2, '0')}/${DateTime.now().day.toString().padLeft(2, '0')}";
    final String signatureDate = contract.signedAt ?? currentDate;

    String normalizeText(String text) {
      const arabicNumbers = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
      const englishNumbers = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
      String normalized = text;
      
      // توحيد الأرقام للغة الإنجليزية لتجنب مشاكل الخطوط
      for (int i = 0; i < arabicNumbers.length; i++) {
        normalized = normalized.replaceAll(arabicNumbers[i], englishNumbers[i]);
      }
      
      // حل مشكلة انعكاس التاريخ الهجري (أو الميلادي) في الـ PDF
      // المكتبة تعكس التواريخ التي تحتوي على "/" بسبب اتجاه اليمين لليسار
      // لذلك نحولها إلى "-" لتظهر بالترتيب الصحيح (سنة-شهر-يوم)
      normalized = normalized.replaceAllMapped(RegExp(r'(\d{2,4})/(\d{1,2})/(\d{1,2})'), (match) {
        return '${match[1]}-${match[2]}-${match[3]}';
      });

      return normalized;
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: format,
        maxPages: 2,
        margin: const pw.EdgeInsets.symmetric(vertical: 15, horizontal: 20), 
        textDirection: pw.TextDirection.rtl, 
        theme: pw.ThemeData.withFont(
          base: ttf,
          bold: ttfBold,
        ),
        header: (context) {
          return pw.Center(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                  'عـقـد إيـجـار',
                  style: pw.TextStyle(font: ttfBold, fontSize: 18, color: primaryBlue),
                ),
                pw.SizedBox(height: 2),
                pw.Text(
                  'TENANCY CONTRACT',
                  style: pw.TextStyle(font: ttfBold, fontSize: 10, color: PdfColor.fromHex('#4A4A4A')),
                ),
                pw.SizedBox(height: 8),
                pw.Text(
                  'يعتبر هذا العقد موثقاً وسنداً تنفيذياً بموجب الأنظمة واللوائح المعتمدة',
                  style: pw.TextStyle(font: ttfBold, fontSize: 9, color: textBlack),
                ),
                pw.SizedBox(height: 15),
              ],
            )
          );
        },
        footer: (context) {
          return pw.Column(
            children: [
              pw.SizedBox(height: 5),
              pw.Divider(color: primaryBlue, thickness: 1.5),
              pw.SizedBox(height: 4),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('طبع بواسطة: بروز العقارية', style: pw.TextStyle(font: ttf, fontSize: 7, color: PdfColors.grey700)),
                  pw.Text('تاريخ الطباعة: $currentDate', style: pw.TextStyle(font: ttf, fontSize: 7, color: PdfColors.grey700)),
                  pw.Text('رقم العقد: ${contract.id}', style: pw.TextStyle(font: ttf, fontSize: 7, color: PdfColors.grey700)),
                ],
              ),
            ],
          );
        },
        build: (pw.Context context) {
          final List<pw.Widget> contentWidgets = [];

          for (final item in contract.contractBody) {
            if (item.type == 'title') {
              contentWidgets.add(
                pw.Padding(
                  padding: const pw.EdgeInsets.only(top: 8, bottom: 4),
                  child: pw.Text(
                    normalizeText(item.content ?? ''),
                    style: pw.TextStyle(fontSize: 10, font: ttfBold, color: primaryBlue),
                  ),
                ),
              );
            } else if (item.type == 'paragraph') {
              contentWidgets.add(
                pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 4),
                  child: pw.Text(
                    normalizeText(item.content ?? ''),
                    style: pw.TextStyle(font: ttf, fontSize: 8, lineSpacing: 1.2, color: textBlack),
                    textAlign: pw.TextAlign.right,
                  ),
                ),
              );
            } else if (item.type == 'list' && item.items != null) {
              final listWidgets = <pw.Widget>[];
              for (final listItem in item.items!) {
                if (listItem.type == 'text') {
                  listWidgets.add(
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(bottom: 2),
                      child: pw.Text(
                        normalizeText(listItem.content),
                        style: pw.TextStyle(font: ttf, fontSize: 8, color: textBlack),
                        textAlign: pw.TextAlign.right,
                      ),
                    ),
                  );
                } else if (listItem.type == 'list_item') {
                  listWidgets.add(
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(right: 12, bottom: 2),
                      child: pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Container(
                            margin: const pw.EdgeInsets.only(top: 4, left: 6),
                            width: 2.5,
                            height: 2.5,
                            decoration: pw.BoxDecoration(
                              color: primaryBlue,
                              shape: pw.BoxShape.circle,
                            ),
                          ),
                          pw.Expanded(
                            child: pw.Text(
                              normalizeText(listItem.content),
                              style: pw.TextStyle(font: ttf, fontSize: 8, lineSpacing: 1.2, color: textBlack),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              }
              contentWidgets.add(
                pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 6),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: listWidgets,
                  ),
                ),
              );
            } else if (item.type == 'table' && item.data != null) {
              final tableData = item.data!;
              
              final List<pw.TableRow> tableRows = [];
              
              // Header Row
              if (tableData.headers.isNotEmpty) {
                tableRows.add(
                  pw.TableRow(
                    decoration: pw.BoxDecoration(color: primaryBlue),
                    children: tableData.headers.map((header) {
                      return pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                        child: pw.Text(
                          normalizeText(header),
                          style: pw.TextStyle(font: ttfBold, fontSize: 8, color: PdfColors.white),
                          textAlign: pw.TextAlign.center,
                        ),
                      );
                    }).toList(),
                  ),
                );
              }

              // Data Rows
              for (int i = 0; i < tableData.rows.length; i++) {
                final row = tableData.rows[i];
                final List<pw.Widget> cells = [];
                for (int j = 0; j < row.length; j++) {
                  final bool isLabel = (row.length % 2 == 0) && (j % 2 == 0);
                  cells.add(
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                      child: pw.Text(
                        normalizeText(row[j]),
                        style: pw.TextStyle(
                          font: isLabel ? ttfBold : ttf, 
                          fontSize: 7, 
                          color: isLabel ? primaryBlue : textBlack
                        ),
                        textAlign: isLabel ? pw.TextAlign.right : pw.TextAlign.center,
                      ),
                    )
                  );
                }
                tableRows.add(
                  pw.TableRow(
                    children: cells,
                  ),
                );
              }

              contentWidgets.add(
                pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 10),
                  child: pw.Table(
                    border: pw.TableBorder.all(color: primaryBlue, width: 0.5),
                    children: tableRows,
                  ),
                ),
              );
            }
          }

          return [
            ...contentWidgets,
            pw.SizedBox(height: 25),

            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Text('توقيع المؤجر', style: pw.TextStyle(font: ttfBold, fontSize: 10, color: primaryBlue)),
                      pw.SizedBox(height: 30),
                      pw.Container(width: 120, height: 0.5, color: PdfColors.grey600),
                      pw.SizedBox(height: 6),
                      pw.Text('LESSOR SIGNATURE', style: pw.TextStyle(font: ttfBold, fontSize: 7, color: PdfColors.grey600)),
                    ]
                  )
                ),
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Text('توقيع المستأجر', style: pw.TextStyle(font: ttfBold, fontSize: 10, color: primaryBlue)),
                      pw.SizedBox(height: 10),
                      if (signatureImage.isNotEmpty) ...[
                         pw.Container(
                           height: 20,
                           child: pw.Image(pw.MemoryImage(signatureImage)),
                         ),
                      ] else ...[
                         pw.SizedBox(height: 20),
                      ],
                      pw.Container(width: 120, height: 0.5, color: PdfColors.grey600),
                      pw.SizedBox(height: 6),
                      pw.Text('TENANT SIGNATURE', style: pw.TextStyle(font: ttfBold, fontSize: 7, color: PdfColors.grey600)),
                    ]
                  )
                )
              ]
            ),
            pw.SizedBox(height: 10),
          ];
        },
      ),
    );

    return pdf.save();
  }
}
