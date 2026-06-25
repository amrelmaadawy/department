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

    pdf.addPage(
      pw.MultiPage(
        pageFormat: format,
        margin: const pw.EdgeInsets.all(20), // Reduced margin to 20
        textDirection: pw.TextDirection.rtl, // Fixes Arabic layout
        theme: pw.ThemeData.withFont(
          base: ttf,
          bold: ttfBold,
        ),
        header: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.SizedBox(height: 10),
              pw.Container(
                alignment: pw.Alignment.center,
                child: pw.Text(
                  contractTitleStr,
                  style: pw.TextStyle(font: ttfBold, fontSize: 26, color: PdfColors.blueGrey900),
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Container(
                height: 2,
                width: double.infinity,
                color: PdfColors.amber700,
              ),
              pw.SizedBox(height: 30),
            ],
          );
        },
        footer: (context) {
          return pw.Column(
            children: [
              pw.Divider(color: PdfColors.grey400),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('وثيقة رسمية', style: pw.TextStyle(font: ttfBold, fontSize: 10, color: PdfColors.grey600)),
                  pw.Text('صفحة ${context.pageNumber} من ${context.pagesCount}', style: pw.TextStyle(font: ttf, fontSize: 10, color: PdfColors.grey600)),
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
                pw.Container(
                  margin: const pw.EdgeInsets.only(top: 20, bottom: 12),
                  padding: const pw.EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                  decoration: const pw.BoxDecoration(
                    color: PdfColors.grey100,
                    border: pw.Border(right: pw.BorderSide(color: PdfColors.amber700, width: 4)),
                  ),
                  child: pw.Text(
                    item.content ?? '',
                    style: pw.TextStyle(fontSize: 16, font: ttfBold, color: PdfColors.blueGrey900),
                  ),
                ),
              );
            } else if (item.type == 'paragraph') {
              contentWidgets.add(
                pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 12),
                  child: pw.Text(
                    item.content ?? '',
                    style: pw.TextStyle(font: ttf, fontSize: 12, lineSpacing: 3, color: PdfColors.grey800),
                    textAlign: pw.TextAlign.justify,
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
                        listItem.content,
                        style: pw.TextStyle(font: ttf, fontSize: 12, color: PdfColors.grey800),
                        textAlign: pw.TextAlign.justify,
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
                            margin: const pw.EdgeInsets.only(top: 5, left: 8),
                            width: 4,
                            height: 4,
                            decoration: const pw.BoxDecoration(
                              color: PdfColors.grey600,
                              shape: pw.BoxShape.circle,
                            ),
                          ),
                          pw.Expanded(
                            child: pw.Text(
                              listItem.content,
                              style: pw.TextStyle(font: ttf, fontSize: 12, color: PdfColors.grey800),
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
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(
                        header,
                        style: pw.TextStyle(font: ttfBold, fontSize: 10, color: PdfColors.blueGrey900),
                        textAlign: pw.TextAlign.center,
                      ),
                    );
                  }).toList(),
                ),
              );

              // Rows
              for (final row in tableData.rows) {
                tableRows.add(
                  pw.TableRow(
                    children: row.map((cell) {
                      return pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          cell,
                          style: pw.TextStyle(font: ttf, fontSize: 10, color: PdfColors.grey800),
                          textAlign: pw.TextAlign.center,
                        ),
                      );
                    }).toList(),
                  ),
                );
              }

              // Footer
              if (tableData.footer.isNotEmpty) {
                // Since pw.Table doesn't strictly support colspan natively without complex table structures,
                // we'll simulate the footer row by manually constructing a pw.Row or using a simple TableRow with adjusted cells.
                // Alternatively, we can use TableHelper, but let's build a custom row for the footer.
                contentWidgets.add(
                  pw.Container(
                    margin: const pw.EdgeInsets.only(bottom: 16),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.grey300),
                    ),
                    child: pw.Column(
                      children: [
                        pw.Table(
                          border: pw.TableBorder.all(color: PdfColors.grey300),
                          children: tableRows,
                        ),
                        // Footer simulated as a row underneath
                        pw.Container(
                          color: PdfColors.grey100,
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Expanded(
                                flex: tableData.footer.first.colspan,
                                child: pw.Text(
                                  tableData.footer.first.content,
                                  style: pw.TextStyle(font: ttfBold, fontSize: 11, color: PdfColors.blueGrey900),
                                  textAlign: pw.TextAlign.right,
                                ),
                              ),
                              if (tableData.footer.length > 1)
                                pw.Expanded(
                                  flex: tableData.footer.last.colspan,
                                  child: pw.Text(
                                    tableData.footer.last.content,
                                    style: pw.TextStyle(font: ttfBold, fontSize: 11, color: PdfColors.green700),
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
              } else {
                contentWidgets.add(
                  pw.Padding(
                    padding: const pw.EdgeInsets.only(bottom: 16),
                    child: pw.Table(
                      border: pw.TableBorder.all(color: PdfColors.grey300),
                      children: tableRows,
                    ),
                  ),
                );
              }
            }
          }

          return [
            ...contentWidgets,
            pw.SizedBox(height: 20),

            // 3. Signature Section
            pw.Container(
              margin: const pw.EdgeInsets.only(top: 30),
              padding: const pw.EdgeInsets.all(20),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey50,
                border: pw.Border.all(color: PdfColors.grey300),
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('الاعتماد والتوقيع', style: pw.TextStyle(fontSize: 16, font: ttfBold, color: PdfColors.blueGrey900)),
                  pw.SizedBox(height: 10),
                  pw.Text('أقر أنا الموقع أدناه باطلاعي على كافة الشروط والأحكام المذكورة أعلاه وموافقتي التامة عليها، وبأن هذا التوقيع يعتبر موافقة نهائية لإتمام الإجراءات.', 
                    style: pw.TextStyle(font: ttf, fontSize: 11, color: PdfColors.grey700, lineSpacing: 2)
                  ),
                  pw.SizedBox(height: 20),
                  pw.Center(
                    child: pw.Container(
                      height: 80,
                      width: 250,
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: PdfColors.grey400, style: pw.BorderStyle.dashed, width: 2),
                        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
                        color: PdfColors.white,
                      ),
                      child: pw.Center(
                        child: signatureImage.isNotEmpty
                            ? pw.Image(pw.MemoryImage(signatureImage))
                            : pw.Text(
                                'مُعتمد إلكترونياً',
                                style: pw.TextStyle(
                                  font: ttfBold,
                                  fontSize: 16,
                                  color: PdfColors.green700,
                                ),
                              ),
                      ),
                    ),
                  ),
                  pw.SizedBox(height: 15),
                  pw.Center(
                    child: pw.Text('تاريخ التوقيع: ${contract.signedAt ?? DateTime.now().toString().split('.')[0]}', style: pw.TextStyle(fontSize: 11, color: PdfColors.grey700, font: ttfBold)),
                  ),
                ]
              ),
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }

}
