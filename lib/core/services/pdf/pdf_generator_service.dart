import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_native_html_to_pdf/flutter_native_html_to_pdf.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

abstract class IPdfGeneratorService {
  Future<String> generatePdfFromHtml(
    String htmlContent, {
    String fileNamePrefix = 'contract',
  });
}

class PdfGeneratorServiceImpl implements IPdfGeneratorService {
  @override
  Future<String> generatePdfFromHtml(
    String htmlContent, {
    String fileNamePrefix = 'contract',
  }) async {
    debugPrint('[PdfGen] Starting PDF generation...');
    debugPrint('[PdfGen] Raw HTML length: ${htmlContent.length}');

    // ── Phase 1: Download external resources BEFORE isolation ──
    String html = await _downloadAndInlineResources(htmlContent);

    // ── Phase 2: Completely isolate the HTML ──
    html = _isolateHtml(html);

    debugPrint('[PdfGen] Final HTML length: ${html.length}');

    // ── Phase 3: Generate PDF ──
    return _generatePdf(html, fileNamePrefix);
  }

  /// Downloads CSS/images and embeds them inline,
  /// then strips ALL remaining external references.
  Future<String> _downloadAndInlineResources(String html) async {
    // 1. Strip scripts first
    html = _stripScripts(html);

    // 2. Embed CSS inline
    html = await _embedCssAsInline(html);

    // 3. Embed images as base64
    html = await _embedImagesAsBase64(html);

    return html;
  }

  /// Makes the HTML completely self-contained so the internal
  /// WebView won't attempt ANY network requests.
  String _isolateHtml(String html) {
    // 1. Remove ALL remaining <link> tags (favicon, preload, etc.)
    html = html.replaceAll(
      RegExp(r'<link[^>]*>', caseSensitive: false),
      '',
    );

    // 2. Remove @import rules inside <style> blocks
    html = html.replaceAll(
      RegExp(r'@import\s+[^;]+;', caseSensitive: false),
      '',
    );

    // 3. Remove @font-face with external src
    html = html.replaceAll(
      RegExp(
        r'@font-face\s*\{[^}]*src\s*:[^}]*url\s*\([^)]*https?://[^}]*\}',
        caseSensitive: false,
      ),
      '',
    );

    // 4. Remove <iframe> tags
    html = html.replaceAll(
      RegExp(r'<iframe[^>]*>[\s\S]*?</iframe>', caseSensitive: false),
      '',
    );

    // 5. Remove any remaining <img> with http(s) src (failed downloads)
    html = html.replaceAll(
      RegExp(
        r'<img[^>]+src="https?://[^"]*"[^>]*>',
        caseSensitive: false,
      ),
      '',
    );

    // 6. Strip tailwind break-inside-avoid
    html = html.replaceAll('break-inside-avoid', 'break-inside-auto');

    // 7. Inject CSP + print styles into <head>
    const injection = '''
<meta http-equiv="Content-Security-Policy" content="default-src 'none'; style-src 'unsafe-inline'; img-src data:;">
<base href="about:blank">
<style>
  @media print {
    tr, img, svg { page-break-inside: avoid !important; }
    table, tbody, thead, tfoot, body, html {
      page-break-inside: auto !important;
    }
    h1, h2, h3, h4, h5, h6 {
      page-break-after: avoid !important;
    }
    @page { margin: 15mm !important; }
  }
</style>
''';

    final lower = html.toLowerCase();
    final headEnd = lower.indexOf('</head>');
    if (headEnd != -1) {
      return '${html.substring(0, headEnd)}$injection${html.substring(headEnd)}';
    }
    final bodyStart = lower.indexOf('<body');
    if (bodyStart != -1) {
      return '${html.substring(0, bodyStart)}$injection${html.substring(bodyStart)}';
    }
    return injection + html;
  }

  Future<String> _generatePdf(String html, String prefix) async {
    final targetPath = await _getWriteablePath();
    final name = '${prefix}_${DateTime.now().millisecondsSinceEpoch}';

    debugPrint('[PdfGen] Saving to: $targetPath/$name');

    try {
      final converter = HtmlToPdfConverter();
      final pdfFile = await converter.convertHtmlToPdf(
        html: html,
        targetDirectory: targetPath,
        targetName: name,
        pageSize: PdfPageSize.a4,
      ).timeout(
        const Duration(seconds: 60),
        onTimeout: () => throw _PdfTimeoutException(),
      );

      if (!File(pdfFile.path).existsSync()) {
        throw Exception('الملف لم يُنشأ بنجاح');
      }

      debugPrint('[PdfGen] ✔ PDF created: ${pdfFile.path}');
      return pdfFile.path;
    } on _PdfTimeoutException {
      throw Exception(
        'استغرق توليد العقد وقتاً أطول من المتوقع. '
        'يرجى المحاولة مرة أخرى.',
      );
    } catch (e) {
      debugPrint('[PdfGen] ✗ Error: $e');
      rethrow;
    }
  }

  Future<String> _getWriteablePath() async {
    // Priority 1: Application Documents Directory (safest for Android Print Spooler)
    try {
      final dir = await getApplicationDocumentsDirectory();
      if (!dir.existsSync()) dir.createSync(recursive: true);
      return dir.path;
    } catch (e) {
      debugPrint('[PdfGen] App docs dir failed: $e');
    }
    
    // Priority 2: Temporary Directory (Cache)
    try {
      final dir = await getTemporaryDirectory();
      if (dir.existsSync()) return dir.path;
    } catch (e) {
      debugPrint('[PdfGen] Temp dir failed: $e');
    }
    
    throw Exception('تعذر الوصول لمسار الملفات.');
  }

  String _stripScripts(String html) {
    html = html.replaceAll(
      RegExp(r'<script[^>]*>[\s\S]*?<\/script>', caseSensitive: false),
      '',
    );
    html = html.replaceAll(
      RegExp(
        r"""onload\s*=\s*['"][^'"]*window\.print[^'"]*['"]""",
        caseSensitive: false,
      ),
      '',
    );
    return html;
  }

  Future<String> _embedCssAsInline(String html) async {
    final re = RegExp(
      r'<link[^>]+href="([^">]+\.css[^"]*)"[^>]*>',
      caseSensitive: false,
    );
    final dio = Dio();

    for (final m in re.allMatches(html).toList()) {
      final tag = m.group(0)!;
      final url = m.group(1)!;
      if (!url.startsWith('http')) continue;
      try {
        final safe = url.replaceFirst('http://', 'https://');
        final r = await dio.get<String>(
          safe,
          options: Options(
            receiveTimeout: const Duration(seconds: 8),
          ),
        );
        if (r.statusCode == 200 && r.data != null) {
          html = html.replaceFirst(tag, '<style>${r.data}</style>');
        } else {
          html = html.replaceFirst(tag, '');
        }
      } catch (_) {
        debugPrint('[PdfGen] CSS download failed: $url');
        html = html.replaceFirst(tag, '');
      }
    }
    return html;
  }

  Future<String> _embedImagesAsBase64(String html) async {
    final re = RegExp(
      r'<img[^>]+src="(https?://[^">]+)"[^>]*>',
      caseSensitive: false,
    );
    final dio = Dio();

    for (final m in re.allMatches(html).toList()) {
      final tag = m.group(0)!;
      final url = m.group(1)!;
      try {
        final safe = url.replaceFirst('http://', 'https://');
        final r = await dio.get<List<int>>(
          safe,
          options: Options(
            responseType: ResponseType.bytes,
            receiveTimeout: const Duration(seconds: 8),
          ),
        );
        if (r.statusCode == 200 && r.data != null) {
          final b64 = base64Encode(r.data!);
          final mime = url.toLowerCase().endsWith('.png')
              ? 'image/png'
              : 'image/jpeg';
          html = html.replaceFirst(
            tag,
            tag.replaceFirst(url, 'data:$mime;base64,$b64'),
          );
        } else {
          html = html.replaceFirst(tag, '');
        }
      } catch (_) {
        debugPrint('[PdfGen] Image download failed: $url');
        html = html.replaceFirst(tag, '');
      }
    }
    return html;
  }
}

class _PdfTimeoutException implements Exception {}
