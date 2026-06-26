
import 'package:arabic_reshaper/arabic_reshaper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../domain/entities/contract_entity.dart';
import '../../../../features/profile/domain/entities/user_entity.dart';

/// Generates a single-page A4 PDF contract with all API data and signature.
class ContractPdfGenerator {
  static final ArabicReshaper _reshaper = ArabicReshaper(
    configuration: const ArabicReshaperConfig(supportLigatures: true),
  );

  static String _ar(String t) =>
      t.trim().isEmpty ? t : _reshaper.reshape(_sanitize(t));

  /// Replaces Unicode characters unsupported by the Cairo font with safe
  /// ASCII/Arabic equivalents, preventing × (tofu) boxes in the PDF.
  static String _sanitize(String text) {
    return text
        // Dashes
        .replaceAll('\u2014', '-')   // em dash —
        .replaceAll('\u2013', '-')   // en dash –
        .replaceAll('\u2012', '-')   // figure dash
        .replaceAll('\u2010', '-')   // hyphen
        // Quotation marks
        .replaceAll('\u201C', '"')   // "
        .replaceAll('\u201D', '"')   // "
        .replaceAll('\u2018', "'")   // '
        .replaceAll('\u2019', "'")   // '
        // Bullets & list markers
        .replaceAll('\u2022', '-')   // bullet •
        .replaceAll('\u25CF', '-')   // ●
        .replaceAll('\u25CB', '-')   // ○
        .replaceAll('\u25A0', '-')   // ■
        .replaceAll('\u25A1', '-')   // □
        .replaceAll('\u2023', '-')   // ‣
        .replaceAll('\u2043', '-')   // ⁃
        // Checkmarks & crosses
        .replaceAll('\u2713', 'v')   // ✓
        .replaceAll('\u2714', 'v')   // ✔
        .replaceAll('\u2717', 'x')   // ✗
        .replaceAll('\u2718', 'x')   // ✘
        .replaceAll('\u2715', 'x')   // ✕
        // Symbols
        .replaceAll('\u00A9', '(c)') // ©
        .replaceAll('\u00AE', '(r)') // ®
        .replaceAll('\u2122', 'TM')  // ™
        .replaceAll('\u00BD', '1/2') // ½
        .replaceAll('\u00BC', '1/4') // ¼
        .replaceAll('\u00BE', '3/4') // ¾
        // Non-breaking spaces & special whitespace
        .replaceAll('\u00A0', ' ')   // NBSP
        .replaceAll('\u200B', '')    // zero-width space
        .replaceAll('\u200C', '')    // zero-width non-joiner
        .replaceAll('\u200F', '')    // right-to-left mark
        .replaceAll('\uFEFF', '')    // BOM
        // Ellipsis
        .replaceAll('\u2026', '...')  // …
        // Arrows
        .replaceAll('\u2192', '->')  // →
        .replaceAll('\u2190', '<-')  // ←
        .replaceAll('\u21D2', '=>')  // ⇒
        // Mathematical
        .replaceAll('\u00D7', 'x')   // × multiplication sign
        .replaceAll('\u00F7', '/')   // ÷
        .replaceAll('\u00B1', '+/-') // ±
        .replaceAll('\u2248', '~')   // ≈
        .replaceAll('\u2260', '!=')  // ≠
        .replaceAll('\u2264', '<=')  // ≤
        .replaceAll('\u2265', '>='); // ≥
  }

  static Future<Uint8List> generate({
    required ContractEntity contract,
    required Uint8List signatureImage,
    UserEntity? user,
  }) async {
    final fontData = await rootBundle.load('assets/font/Cairo-Regular.ttf');
    final boldData = await rootBundle.load('assets/font/Cairo-Bold.ttf');
    final ttf = pw.Font.ttf(fontData);
    final ttfBold = pw.Font.ttf(boldData);

    // ─── Decode signature ──────────────────────────────────────────────────
    pw.ImageProvider? signatureProvider;
    if (signatureImage.isNotEmpty) {
      try {
        signatureProvider = pw.MemoryImage(signatureImage);
      } catch (e) {
        debugPrint('Failed to load signature image: $e');
      }
    }

    final pdf = pw.Document();

    // ─── Palette ──────────────────────────────────────────────────────────
    const primaryColor = PdfColor.fromInt(0xFF1B3358);
    const goldColor = PdfColor.fromInt(0xFFC9A84C);
    const lightBg = PdfColor.fromInt(0xFFF0F4FA);
    const dividerColor = PdfColor.fromInt(0xFFCDD5E0);
    const textDark = PdfColors.black;
    const textMid = PdfColors.grey700;
    const white = PdfColors.white;

    // ─── Type helpers ──────────────────────────────────────────────────────
    pw.TextStyle s({
      required double sz,
      pw.Font? font,
      PdfColor? color,
      double? lineSpacing,
    }) =>
        pw.TextStyle(
          font: font ?? ttf,
          fontSize: sz,
          color: color ?? textDark,
          lineSpacing: lineSpacing,
        );

    pw.TextStyle b({required double sz, PdfColor? color}) =>
        pw.TextStyle(font: ttfBold, fontSize: sz, color: color ?? textDark);

    final date = contract.createdAt.length >= 10
        ? contract.createdAt.substring(0, 10)
        : contract.createdAt;

    final totalFmt = _formatNum(contract.totalAmount);

    // ─── Contract body widgets ─────────────────────────────────────────────
    final List<pw.Widget> bodyWidgets = [];
    int listIdx = 1;

    for (final item in contract.contractBody) {
      switch (item.type) {
        case 'title':
          if (item.content?.isNotEmpty == true) {
            bodyWidgets.add(pw.SizedBox(height: 3));
            bodyWidgets.add(
              pw.Text(
                _ar(item.content!),
                style: b(sz: 7, color: primaryColor),
                textDirection: pw.TextDirection.rtl,
                textAlign: pw.TextAlign.right,
              ),
            );
            bodyWidgets.add(pw.SizedBox(height: 1));
          }

        case 'paragraph':
          if (item.content?.isNotEmpty == true) {
            bodyWidgets.add(
              pw.Text(
                _ar(item.content!),
                style: s(sz: 6.2, lineSpacing: 1.2),
                textDirection: pw.TextDirection.rtl,
                textAlign: pw.TextAlign.right,
              ),
            );
            bodyWidgets.add(pw.SizedBox(height: 1.5));
          }

        case 'list':
          final items = item.items ?? [];
          for (final li in items) {
            if (li.type == 'list_item' && li.content.isNotEmpty) {
              bodyWidgets.add(
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Expanded(
                      child: pw.Text(
                        '${listIdx++}. ${_ar(li.content)}',
                        style: s(sz: 6.2, lineSpacing: 1.2),
                        textDirection: pw.TextDirection.rtl,
                        textAlign: pw.TextAlign.right,
                      ),
                    ),
                  ],
                ),
              );
              bodyWidgets.add(pw.SizedBox(height: 1));
            }
          }

        case 'table':
          final tableData = item.data;
          if (tableData != null) {
            // Header row
            final tableRows = <pw.TableRow>[];
            if (tableData.headers.isNotEmpty) {
              tableRows.add(pw.TableRow(
                decoration: const pw.BoxDecoration(color: primaryColor),
                children: tableData.headers.map((h) {
                  return pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(
                        vertical: 2, horizontal: 3),
                    child: pw.Text(
                      _ar(h),
                      style: b(sz: 6, color: white),
                      textAlign: pw.TextAlign.center,
                      textDirection: pw.TextDirection.rtl,
                    ),
                  );
                }).toList(),
              ));
            }
            // Data rows
            for (int r = 0; r < tableData.rows.length; r++) {
              tableRows.add(pw.TableRow(
                decoration: pw.BoxDecoration(
                  color: r.isOdd ? lightBg : white,
                ),
                children: tableData.rows[r].map((cell) {
                  return pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(
                        vertical: 2, horizontal: 3),
                    child: pw.Text(
                      _ar(cell),
                      style: s(sz: 6),
                      textAlign: pw.TextAlign.center,
                      textDirection: pw.TextDirection.rtl,
                    ),
                  );
                }).toList(),
              ));
            }
            // Footer
            if (tableData.footer.isNotEmpty) {
              tableRows.add(pw.TableRow(
                decoration: const pw.BoxDecoration(color: lightBg),
                children: tableData.footer.map((f) {
                  return pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(
                        vertical: 2, horizontal: 3),
                    child: pw.Text(
                      _ar(f.content),
                      style: b(sz: 6, color: primaryColor),
                      textAlign: pw.TextAlign.center,
                      textDirection: pw.TextDirection.rtl,
                    ),
                  );
                }).toList(),
              ));
            }
            bodyWidgets.add(pw.SizedBox(height: 2));
            bodyWidgets.add(pw.Table(
              border: pw.TableBorder.all(color: dividerColor, width: 0.5),
              children: tableRows,
            ));
            bodyWidgets.add(pw.SizedBox(height: 2));
          }
      }
    }

    // ─── Page ─────────────────────────────────────────────────────────────
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.fromLTRB(18, 14, 18, 14),
        theme: pw.ThemeData.withFont(base: ttf, bold: ttfBold),
        build: (ctx) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              // ══ HEADER BAR ═══════════════════════════════════════════════
              pw.Container(
                color: primaryColor,
                padding: const pw.EdgeInsets.symmetric(
                    horizontal: 10, vertical: 5),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Broz Real Estate', style: b(sz: 8, color: white)),
                        pw.Text('بروز العقارية', style: b(sz: 8, color: goldColor)),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        pw.Text(
                          _ar(contract.typeLabel),
                          style: b(sz: 9, color: goldColor),
                          textDirection: pw.TextDirection.rtl,
                        ),
                        pw.SizedBox(height: 2),
                        pw.Text(
                          _ar('رقم العقد: ${contract.contractNumber}'),
                          style: s(sz: 6.5, color: white),
                          textDirection: pw.TextDirection.rtl,
                        ),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text(_ar('التاريخ: $date'),
                            style: s(sz: 6.5, color: white),
                            textDirection: pw.TextDirection.rtl),
                        pw.Text(_ar('الإجمالي: $totalFmt ر.س'),
                            style: b(sz: 7, color: goldColor),
                            textDirection: pw.TextDirection.rtl),
                      ],
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 5),

              // ══ PARTIES (2 COLUMNS) ════════════════════════════════════
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // First party
                  pw.Expanded(
                    child: pw.Container(
                      padding: const pw.EdgeInsets.all(5),
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: dividerColor, width: 0.5),
                        color: lightBg,
                      ),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Text(_ar('الطرف الأول — الشركة'),
                              style: b(sz: 6.5, color: primaryColor),
                              textDirection: pw.TextDirection.rtl),
                          pw.SizedBox(height: 2),
                          _kvRow('الاسم', 'شركة بروز العقارية', ttf, ttfBold),
                          _kvRow('الهاتف', '920012345', ttf, ttfBold),
                          _kvRow('السجل التجاري', '1010987654', ttf, ttfBold),
                        ],
                      ),
                    ),
                  ),
                  pw.SizedBox(width: 5),
                  // Second party
                  pw.Expanded(
                    child: pw.Container(
                      padding: const pw.EdgeInsets.all(5),
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: dividerColor, width: 0.5),
                        color: lightBg,
                      ),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Text(_ar('الطرف الثاني — العميل'),
                              style: b(sz: 6.5, color: primaryColor),
                              textDirection: pw.TextDirection.rtl),
                          pw.SizedBox(height: 2),
                          _kvRow('الاسم', user?.name ?? '---', ttf, ttfBold),
                          _kvRow('الهاتف',
                              user?.phone ?? '---', ttf, ttfBold),
                          _kvRow('البريد',
                              user?.email ?? '---', ttf, ttfBold),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 5),

              // ══ CONTRACT DETAILS ROW ═══════════════════════════════════
              pw.Container(
                color: primaryColor,
                padding: const pw.EdgeInsets.symmetric(
                    horizontal: 8, vertical: 3),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    _detailChip(
                        _ar('المبلغ الإجمالي'), '$totalFmt ر.س', ttf, ttfBold,
                        labelColor: white, valueColor: goldColor),
                    _vSep(white),
                    _detailChip(
                        _ar('مدة التنفيذ'),
                        _ar('${contract.executionDuration} يوم'),
                        ttf, ttfBold,
                        labelColor: white, valueColor: white),
                    _vSep(white),
                    _detailChip(
                        _ar('الحالة'),
                        _ar(contract.statusLabel),
                        ttf, ttfBold,
                        labelColor: white, valueColor: goldColor),
                    _vSep(white),
                    _detailChip(
                        _ar('الشقة'),
                        '#${contract.apartmentId}',
                        ttf, ttfBold,
                        labelColor: white, valueColor: white),
                  ],
                ),
              ),
              pw.SizedBox(height: 5),

              // ══ CONTRACT BODY ═════════════════════════════════════════
              // pw.Expanded constrains the body to the remaining page height,
              // preventing overflow that would clip the signature section.
              pw.Expanded(
                child: pw.Container(
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: dividerColor, width: 0.5),
                  ),
                  padding: const pw.EdgeInsets.all(6),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                    children: bodyWidgets,
                  ),
                ),
              ),

              // ══ SIGNATURES ═══════════════════════════════════════════
              pw.Container(
                height: 0.5,
                color: dividerColor,
              ),
              pw.SizedBox(height: 6),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  // Company signature
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Text(_ar('توقيع وختم الشركة'),
                          style: s(sz: 6.5, color: textMid),
                          textDirection: pw.TextDirection.rtl),
                      pw.SizedBox(height: 30),
                      pw.Container(width: 130, height: 0.8, color: textDark),
                      pw.SizedBox(height: 2),
                      pw.Text(_ar('الطرف الأول'),
                          style: s(sz: 6, color: textMid),
                          textDirection: pw.TextDirection.rtl),
                    ],
                  ),
                  // Divider
                  pw.Container(height: 55, width: 0.5, color: dividerColor),
                  // Client signature
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Text(_ar('توقيع العميل'),
                          style: s(sz: 6.5, color: textMid),
                          textDirection: pw.TextDirection.rtl),
                      pw.SizedBox(height: 2),
                      pw.Container(
                        height: 50,
                        width: 150,
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(color: dividerColor, width: 0.5),
                        ),
                        child: signatureProvider != null
                            ? pw.Image(
                                signatureProvider,
                                fit: pw.BoxFit.contain,
                              )
                            : pw.Center(
                                child: pw.Text(
                                  'لا يوجد توقيع',
                                  style: s(sz: 6, color: textMid),
                                )),
                      ),
                      pw.SizedBox(height: 2),
                      pw.Text(_ar('الطرف الثاني'),
                          style: s(sz: 6, color: textMid),
                          textDirection: pw.TextDirection.rtl),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 4),
              pw.Container(height: 0.5, color: primaryColor),
              pw.SizedBox(height: 2),
              pw.Center(
                child: pw.Text(
                  _ar(
                      'شركة بروز العقارية • جميع الحقوق محفوظة © ${DateTime.now().year}'),
                  style: s(sz: 5.5, color: textMid),
                  textDirection: pw.TextDirection.rtl,
                ),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  static String _formatNum(double v) {
    return v
        .toStringAsFixed(0)
        .replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
  }

  static pw.Widget _kvRow(
      String label, String value, pw.Font ttf, pw.Font ttfBold) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 1.5),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.end,
        children: [
          pw.Text(
            value,
            style: pw.TextStyle(font: ttfBold, fontSize: 6),
            textDirection: pw.TextDirection.rtl,
          ),
          pw.SizedBox(width: 3),
          pw.Text(
            ArabicReshaper(
                    configuration:
                        const ArabicReshaperConfig(supportLigatures: true))
                .reshape(':$label'),
            style: pw.TextStyle(font: ttf, fontSize: 6, color: PdfColors.grey600),
            textDirection: pw.TextDirection.rtl,
          ),
        ],
      ),
    );
  }

  static pw.Widget _detailChip(
    String label,
    String value,
    pw.Font ttf,
    pw.Font ttfBold, {
    required PdfColor labelColor,
    required PdfColor valueColor,
  }) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Text(label,
            style: pw.TextStyle(font: ttf, fontSize: 5.5, color: labelColor),
            textDirection: pw.TextDirection.rtl),
        pw.SizedBox(height: 1),
        pw.Text(value,
            style:
                pw.TextStyle(font: ttfBold, fontSize: 7, color: valueColor),
            textDirection: pw.TextDirection.rtl),
      ],
    );
  }

  static pw.Widget _vSep(PdfColor color) {
    return pw.Container(height: 24, width: 0.5, color: color);
  }
}
