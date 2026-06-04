import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ContractPdfGenerator {
  static Future<Uint8List> generateContractBytes(
    PdfPageFormat format,
    Uint8List signatureImage,
  ) async {
    final pdf = pw.Document();

    final fontData = await rootBundle.load('assets/font/Cairo-Regular.ttf');
    final fontBoldData = await rootBundle.load('assets/font/Cairo-Bold.ttf');
    
    final ttf = pw.Font.ttf(fontData);
    final ttfBold = pw.Font.ttf(fontBoldData);

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
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.SizedBox(), // مساحة فارغة لاسم أو شعار الشركة لاحقاً
                  pw.Text('عقد حجز وحدة سكنية', style: pw.TextStyle(font: ttfBold, fontSize: 24, color: PdfColors.blueGrey900)),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Container(
                height: 3,
                width: double.infinity,
                decoration: const pw.BoxDecoration(
                  color: PdfColors.amber700,
                ),
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
          return [
            // 1. Summary Section
            pw.Text('1. ملخص الوحدة', style: pw.TextStyle(fontSize: 16, font: ttfBold, color: PdfColors.blueGrey900)),
            pw.SizedBox(height: 8),
            pw.Container(
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey100,
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
                border: pw.Border.all(color: PdfColors.grey300),
              ),
              child: pw.Table(
                columnWidths: {
                  0: const pw.FlexColumnWidth(2),
                  1: const pw.FlexColumnWidth(1),
                  2: const pw.FlexColumnWidth(2),
                  3: const pw.FlexColumnWidth(1),
                },
                children: [
                  pw.TableRow(
                    children: [
                      pw.Align(alignment: pw.Alignment.centerRight, child: pw.Text('الدور الثالث', style: pw.TextStyle(font: ttf, fontSize: 12))),
                      pw.Align(alignment: pw.Alignment.centerRight, child: pw.Text('الدور:', style: pw.TextStyle(font: ttfBold, fontSize: 12))),
                      pw.Align(alignment: pw.Alignment.centerRight, child: pw.Text('لؤلؤة الرياض', style: pw.TextStyle(font: ttf, fontSize: 12))),
                      pw.Align(alignment: pw.Alignment.centerRight, child: pw.Text('المشروع:', style: pw.TextStyle(font: ttfBold, fontSize: 12))),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.SizedBox(height: 8),
                      pw.SizedBox(height: 8),
                      pw.SizedBox(height: 8),
                      pw.SizedBox(height: 8),
                    ]
                  ),
                  pw.TableRow(
                    children: [
                      pw.Align(alignment: pw.Alignment.centerRight, child: pw.Text('1,250,000 ر.س', style: pw.TextStyle(font: ttfBold, fontSize: 12, color: PdfColors.amber700))),
                      pw.Align(alignment: pw.Alignment.centerRight, child: pw.Text('السعر الإجمالي:', style: pw.TextStyle(font: ttfBold, fontSize: 12))),
                      pw.Align(alignment: pw.Alignment.centerRight, child: pw.Text('شقة - 150 متر مربع', style: pw.TextStyle(font: ttf, fontSize: 12))),
                      pw.Align(alignment: pw.Alignment.centerRight, child: pw.Text('نوع الوحدة:', style: pw.TextStyle(font: ttfBold, fontSize: 12))),
                    ],
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 15),

            // 2. Terms Section
            pw.Text('2. الشروط والأحكام', style: pw.TextStyle(fontSize: 16, font: ttfBold, color: PdfColors.blueGrey900)),
            pw.SizedBox(height: 10),
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(horizontal: 10),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  _buildTermItem('1. الحجز المبدئي يخضع للموافقة النهائية من قبل المطور.', ttf),
                  _buildTermItem('2. الأسعار المذكورة هي تقديرات أولية وقد تتغير بناءً على القياسات النهائية.', ttf),
                  _buildTermItem('3. عربون الحجز غير مسترد بعد مرور 14 يومًا من هذا الاتفاق.', ttf),
                  _buildTermItem('4. يلتزم المشتري باستكمال الدفعة المقدمة خلال الجدول الزمني المحدد.', ttf),
                  _buildTermItem('5. تعتبر جميع المخططات والمواصفات المرفقة جزءًا لا يتجزأ من هذا العقد.', ttf),
                ]
              )
            ),
            pw.SizedBox(height: 15),

            // 3. Signature Section
            pw.Text('3. إقرار وتوقيع العميل', style: pw.TextStyle(fontSize: 16, font: ttfBold, color: PdfColors.blueGrey900)),
            pw.SizedBox(height: 8),
            pw.Text('أقر أنا الموقع أدناه باطلاعي على كافة الشروط والأحكام المذكورة أعلاه وموافقتي التامة عليها، وبأن هذا التوقيع يعتبر موافقة نهائية لإتمام إجراءات حجز الوحدة السكنية.', 
              style: pw.TextStyle(font: ttf, fontSize: 11, color: PdfColors.grey700, lineSpacing: 2)
            ),
            pw.SizedBox(height: 15),
            pw.Container(
              height: 70,
              width: 250,
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey400, style: pw.BorderStyle.dashed, width: 2),
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
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
            pw.SizedBox(height: 8),
            pw.Text('تاريخ التوقيع: ${DateTime.now().toString().split('.')[0]}', style: pw.TextStyle(fontSize: 11, color: PdfColors.grey700, font: ttfBold)),
          ];
        },
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildTermItem(String text, pw.Font ttf) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 5), // Reduced from 8
      child: pw.Text(
        text,
        style: pw.TextStyle(font: ttf, fontSize: 11, lineSpacing: 2),
      ),
    );
  }
}
