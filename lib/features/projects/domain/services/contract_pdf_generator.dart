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
    final PdfColor textBlack = PdfColors.black;
    
    final String currentDate = "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')} ${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}";
    final String signatureDate = contract.signedAt ?? currentDate;

    String _normalizeText(String text) {
      const arabicNumbers = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
      const englishNumbers = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
      String normalized = text;
      for (int i = 0; i < arabicNumbers.length; i++) {
        normalized = normalized.replaceAll(arabicNumbers[i], englishNumbers[i]);
      }
      return normalized;
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: format,
        margin: const pw.EdgeInsets.all(35), 
        textDirection: pw.TextDirection.rtl, 
        theme: pw.ThemeData.withFont(
          base: ttf,
          bold: ttfBold,
        ),
        header: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              // Top Green Text
              pw.Text(
                'هذا العقد موثق إلكترونياً',
                style: pw.TextStyle(font: ttfBold, fontSize: 16, color: primaryGreen),
              ),
              pw.SizedBox(height: 2),
              pw.Text(
                signatureDate,
                style: pw.TextStyle(font: ttf, fontSize: 9, color: primaryGreen),
              ),
              pw.SizedBox(height: 8),
              // Light Green Line
              pw.Container(
                height: 1,
                width: double.infinity,
                color: lightGreen,
              ),
              pw.SizedBox(height: 15),
              // 3 Column Layout
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  // Left: Address & Email
                  pw.Expanded(
                    flex: 2,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('المملكة العربية السعودية حي البطريق', style: pw.TextStyle(font: ttfBold, fontSize: 9, color: primaryBlue)),
                        pw.Text('Email: etman@gmail.com', style: pw.TextStyle(font: ttfBold, fontSize: 9, color: primaryBlue)),
                      ],
                    ),
                  ),
                  // Center: Logo
                  pw.Expanded(
                    flex: 1,
                    child: pw.Center(
                      child: pw.Text('Logo', style: pw.TextStyle(font: ttfBold, fontSize: 18, color: PdfColors.grey600)),
                    ),
                  ),
                  // Right: Company Info
                  pw.Expanded(
                    flex: 2,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text('بروز العقارية', style: pw.TextStyle(font: ttfBold, fontSize: 12, color: primaryBlue)),
                        pw.Text('الهاتف: 01146773113', style: pw.TextStyle(font: ttf, fontSize: 9, color: primaryBlue)),
                        pw.Text('الرقم الضريبي: 56418453213246', style: pw.TextStyle(font: ttf, fontSize: 9, color: primaryBlue)),
                        pw.Text('السجل التجاري: 66666666666', style: pw.TextStyle(font: ttf, fontSize: 9, color: primaryBlue)),
                      ],
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
              // Thick Blue Line
              pw.Container(
                height: 2,
                width: double.infinity,
                color: primaryBlue,
              ),
              pw.SizedBox(height: 20),
            ],
          );
        },
        footer: (context) {
          return pw.Column(
            children: [
              pw.SizedBox(height: 10),
              pw.Divider(color: PdfColors.grey300, thickness: 1),
              pw.SizedBox(height: 5),
              pw.Center(
                child: pw.Text(
                  'بروز العقارية Powered by $currentDate',
                  style: pw.TextStyle(font: ttf, fontSize: 8, color: PdfColors.grey500),
                ),
              ),
            ],
          );
        },
        build: (pw.Context context) {
          final List<pw.Widget> contentWidgets = [];
          
          // Document Titles
          contentWidgets.add(
            pw.Center(
              child: pw.Column(
                children: [
                  pw.Text('بسم الله الرحمن الرحيم', style: pw.TextStyle(font: ttfBold, fontSize: 16, color: primaryBlue)),
                  pw.SizedBox(height: 6),
                  pw.Text(contractTitleStr, style: pw.TextStyle(font: ttfBold, fontSize: 14, color: primaryBlue)),
                  pw.SizedBox(height: 6),
                  pw.Text('الحمدلله والصلاة والسلام على رسول الله ، وبعد :', style: pw.TextStyle(font: ttfBold, fontSize: 12, color: primaryBlue)),
                  pw.SizedBox(height: 25),
                ],
              )
            )
          );

          for (final item in contract.contractBody) {
            if (item.type == 'title') {
              contentWidgets.add(
                pw.Container(
                  margin: const pw.EdgeInsets.only(top: 20, bottom: 12),
                  padding: const pw.EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                  decoration: pw.BoxDecoration(
                    border: pw.Border(right: pw.BorderSide(color: primaryBlue, width: 3)),
                  ),
                  child: pw.Text(
                    _normalizeText(item.content ?? ''),
                    style: pw.TextStyle(fontSize: 12, font: ttfBold, color: primaryBlue),
                  ),
                ),
              );
            } else if (item.type == 'paragraph') {
              contentWidgets.add(
                pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 12),
                  child: pw.Text(
                    _normalizeText(item.content ?? ''),
                    style: pw.TextStyle(font: ttf, fontSize: 10, lineSpacing: 2, color: textBlack),
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
                      padding: const pw.EdgeInsets.only(bottom: 4, top: 4),
                      child: pw.Text(
                        _normalizeText(listItem.content),
                        style: pw.TextStyle(font: ttf, fontSize: 10, color: textBlack),
                        textAlign: pw.TextAlign.right,
                      ),
                    ),
                  );
                } else if (listItem.type == 'list_item') {
                  listWidgets.add(
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(right: 15, bottom: 4),
                      child: pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Container(
                            margin: const pw.EdgeInsets.only(top: 4, left: 8),
                            width: 3,
                            height: 3,
                            decoration: const pw.BoxDecoration(
                              color: PdfColors.black,
                              shape: pw.BoxShape.circle,
                            ),
                          ),
                          pw.Expanded(
                            child: pw.Text(
                              _normalizeText(listItem.content),
                              style: pw.TextStyle(font: ttf, fontSize: 10, color: textBlack),
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
                  padding: const pw.EdgeInsets.only(bottom: 12),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: listWidgets,
                  ),
                ),
              );
            } else if (item.type == 'table' && item.data != null) {
              final tableData = item.data!;
              
              final List<pw.TableRow> tableRows = [];
              
              // Headers
              tableRows.add(
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey100),
                  children: tableData.headers.map((header) {
                    return pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                      child: pw.Text(
                        _normalizeText(header),
                        style: pw.TextStyle(font: ttfBold, fontSize: 9, color: primaryBlue),
                        textAlign: pw.TextAlign.center,
                      ),
                    );
                  }).toList(),
                ),
              );

              // Rows
              for (int i = 0; i < tableData.rows.length; i++) {
                final row = tableData.rows[i];
                final isLast = i == tableData.rows.length - 1;
                tableRows.add(
                  pw.TableRow(
                    decoration: pw.BoxDecoration(
                      border: isLast ? null : const pw.Border(bottom: pw.BorderSide(color: PdfColors.grey200, width: 0.5))
                    ),
                    children: row.map((cell) {
                      return pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                        child: pw.Text(
                          _normalizeText(cell),
                          style: pw.TextStyle(font: ttfBold, fontSize: 9, color: textBlack),
                          textAlign: pw.TextAlign.center,
                        ),
                      );
                    }).toList(),
                  ),
                );
              }

              if (tableData.footer.isEmpty) {
                contentWidgets.add(
                  pw.Padding(
                    padding: const pw.EdgeInsets.only(bottom: 20),
                    child: pw.Table(
                      border: pw.TableBorder(
                        verticalInside: const pw.BorderSide(color: PdfColors.grey300, width: 0.5),
                        top: const pw.BorderSide(color: PdfColors.grey300, width: 1),
                        bottom: const pw.BorderSide(color: PdfColors.grey300, width: 1),
                        left: const pw.BorderSide(color: PdfColors.grey300, width: 1),
                        right: const pw.BorderSide(color: PdfColors.grey300, width: 1),
                      ),
                      children: tableRows,
                    ),
                  ),
                );
              } else {
                 // With footer logic
                contentWidgets.add(
                  pw.Container(
                    margin: const pw.EdgeInsets.only(bottom: 20),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.grey300, width: 1),
                    ),
                    child: pw.Column(
                      children: [
                        pw.Table(
                          border: const pw.TableBorder(
                            verticalInside: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
                          ),
                          children: tableRows, 
                        ),
                        // Footer simulated as a row underneath
                        pw.Container(
                          padding: const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                          decoration: const pw.BoxDecoration(
                            color: PdfColors.grey100,
                            border: pw.Border(top: pw.BorderSide(color: PdfColors.grey300)),
                          ),
                          child: pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Expanded(
                                flex: tableData.footer.first.colspan,
                                child: pw.Text(
                                  tableData.footer.first.content,
                                  style: pw.TextStyle(font: ttfBold, fontSize: 9, color: primaryBlue),
                                  textAlign: pw.TextAlign.right,
                                ),
                              ),
                              if (tableData.footer.length > 1)
                                pw.Expanded(
                                  flex: tableData.footer.last.colspan,
                                  child: pw.Text(
                                    tableData.footer.last.content,
                                    style: pw.TextStyle(font: ttfBold, fontSize: 9, color: textBlack),
                                    textAlign: pw.TextAlign.center,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            }
          }

          return [
            ...contentWidgets,
            pw.SizedBox(height: 40),

            // 4. Signatures Section (2 columns)
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                // Right Column (Company)
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Text('توقيع المسؤول', style: pw.TextStyle(font: ttfBold, fontSize: 11, color: textBlack)),
                      pw.SizedBox(height: 40),
                      pw.Container(width: 150, height: 1, color: PdfColors.black),
                      pw.SizedBox(height: 10),
                      pw.Text('معتمد إلكترونياً', style: pw.TextStyle(font: ttfBold, fontSize: 10, color: primaryGreen)),
                    ]
                  )
                ),
                // Left Column (Customer)
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Text('توقيع العميل', style: pw.TextStyle(font: ttfBold, fontSize: 11, color: textBlack)),
                      pw.SizedBox(height: 10),
                      if (signatureImage.isNotEmpty) ...[
                         pw.Container(
                           height: 30,
                           child: pw.Image(pw.MemoryImage(signatureImage)),
                         ),
                      ] else ...[
                         pw.SizedBox(height: 30),
                      ],
                      pw.Container(width: 150, height: 1, color: PdfColors.black),
                      pw.SizedBox(height: 10),
                      if (signatureImage.isNotEmpty)
                         pw.Text('تم التوقيع بنجاح', style: pw.TextStyle(font: ttfBold, fontSize: 10, color: primaryGreen))
                      else
                         pw.Text('في انتظار التوقيع', style: pw.TextStyle(font: ttfBold, fontSize: 10, color: PdfColors.red700)),
                    ]
                  )
                )
              ]
            ),
            pw.SizedBox(height: 20),
          ];
        },
      ),
    );

    return pdf.save();
  }
}
