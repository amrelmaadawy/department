import 'package:arabic_reshaper/arabic_reshaper.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ContractPdfFonts {
  static final ArabicReshaper _reshaper = ArabicReshaper(
    configuration: const ArabicReshaperConfig(
      supportLigatures: true,
      deleteHarakat: true,
    ),
  );

  static pw.Font? _cachedTtf;
  static pw.Font? _cachedTtfBold;

  static Future<void> loadFonts() async {
    if (_cachedTtf == null || _cachedTtfBold == null) {
      final fontData = await rootBundle.load('assets/font/Cairo-Regular.ttf');
      final boldData = await rootBundle.load('assets/font/Cairo-Bold.ttf');
      _cachedTtf = pw.Font.ttf(fontData);
      _cachedTtfBold = pw.Font.ttf(boldData);
    }
  }

  static pw.Font get regular => _cachedTtf!;
  static pw.Font get bold => _cachedTtfBold!;

  static String ar(String t) =>
      t.trim().isEmpty ? t : _reshaper.reshape(sanitize(t));

  static String sanitize(String text) {
    return text
        // Normalize Arabic Yaa variants to standard Yaa (fixes broken Yaa rendering)
        .replaceAll('\u0649', '\u064A') // Alef Maqsoura → Yaa
        .replaceAll('\uFEEF', '\u064A') // Alef Maqsoura presentation → Yaa
        // Normalize Hamza on Alef (fixes broken Hamza rendering)
        .replaceAll('\u0625', '\u0627') // إ → ا (Alef with Hamza below → Alef)
        .replaceAll('\u0623', '\u0627') // أ → ا (Alef with Hamza above → Alef)
        .replaceAll('\u0622', '\u0627') // آ → ا (Alef with Madda → Alef)
        // Tanween and special diacritics
        .replaceAll('\u064B', '') // Fathatan
        .replaceAll('\u064C', '') // Dammatan
        .replaceAll('\u064D', '') // Kasratan
        .replaceAll('\u064E', '') // Fatha
        .replaceAll('\u064F', '') // Damma
        .replaceAll('\u0650', '') // Kasra
        .replaceAll('\u0651', '') // Shadda
        .replaceAll('\u0652', '') // Sukun
        // Special symbols
        .replaceAll('\u2714', 'v')  // ✔ → v
        .replaceAll('\u2713', 'v')  // ✓ → v
        .replaceAll('\u2717', 'x')  // ✗ → x
        .replaceAll('\u2718', 'x')  // ✘ → x
        // Typography replacements
        .replaceAll('\u2014', '-')
        .replaceAll('\u2013', '-')
        .replaceAll('\u201C', '"')
        .replaceAll('\u201D', '"')
        .replaceAll('\u2018', "'")
        .replaceAll('\u2019', "'")
        .replaceAll('\u2022', '-')
        .replaceAll('\u25CF', '-')
        .replaceAll('\u00A0', ' ')
        .replaceAll('\u200B', '')
        .replaceAll('\u200F', '')
        .replaceAll('\uFEFF', '');
  }

  static pw.TextStyle s({
    required double sz,
    pw.Font? font,
    PdfColor? color,
    double? lineSpacing,
  }) =>
      pw.TextStyle(
        font: font ?? regular,
        fontSize: sz,
        color: color ?? PdfColors.black,
        lineSpacing: lineSpacing,
      );

  static pw.TextStyle b({required double sz, PdfColor? color}) =>
      pw.TextStyle(font: bold, fontSize: sz, color: color ?? PdfColors.black);

  static String formatNum(double v) {
    return v
        .toStringAsFixed(0)
        .replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
  }

  static String formatDate(String isoDateStr) {
    if (isoDateStr.trim().isEmpty) return '---';
    DateTime? dt;
    try {
      dt = DateTime.parse(isoDateStr);
    } catch (_) {
      return isoDateStr;
    }

    final gregStr =
        '${dt.year}/${dt.month.toString().padLeft(2, '0')}/${dt.day.toString().padLeft(2, '0')}';

    int day = dt.day;
    int month = dt.month;
    int year = dt.year;
    if (month < 3) {
      year -= 1;
      month += 12;
    }
    int a = year ~/ 100;
    int b = 2 - a + (a ~/ 4);
    int jd = (365.25 * (year + 4716)).toInt() +
        (30.6001 * (month + 1)).toInt() +
        day +
        b -
        1524;
    int z = jd - 1948440 + 10632;
    int n = ((z - 1) ~/ 10631);
    z = z - 10631 * n + 354;
    int j = ((10985 - z) ~/ 5316) * ((50 * z) ~/ 17719) +
        ((z ~/ 5670) * ((43 * z) ~/ 15238));
    z = z -
        ((30 - j) ~/ 15) * ((17719 * j) ~/ 50) -
        ((j ~/ 16) * ((15238 * j) ~/ 43)) +
        29;
    int m = (24 * z) ~/ 709;
    int d = z - (709 * m) ~/ 24;
    int y = 30 * n + j - 30;

    final hijriStr =
        '$y/${m.toString().padLeft(2, '0')}/${d.toString().padLeft(2, '0')} هـ';
    return '$hijriStr الموافق $gregStr';
  }
}
