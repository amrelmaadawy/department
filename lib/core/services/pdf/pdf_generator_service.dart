import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_native_html_to_pdf/flutter_native_html_to_pdf.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:apartment/core/logging/debug_log_buffer.dart';

// ─── Public interface ─────────────────────────────────────────────────────────

abstract class IPdfGeneratorService {
  Future<String> generatePdfFromHtml(
    String htmlContent, {
    String fileNamePrefix = 'contract',
  });
}

// ─── Implementation ───────────────────────────────────────────────────────────

class PdfGeneratorServiceImpl implements IPdfGeneratorService {
  static const String _tag = 'PdfGen';

  @override
  Future<String> generatePdfFromHtml(
    String htmlContent, {
    String fileNamePrefix = 'contract',
  }) async {
    final sw = Stopwatch()..start();
    void log(String msg) =>
        DebugLogBuffer.instance.log(_tag, '[${sw.elapsedMilliseconds}ms] $msg');

    log('START generatePdfFromHtml — HTML=${htmlContent.length} chars');

    // ── Phase 1: Download external resources BEFORE isolation ──
    log('BEFORE _downloadAndInlineResources');
    String html = await _downloadAndInlineResources(htmlContent, log);
    log('AFTER _downloadAndInlineResources — processed HTML=${html.length} chars');

    // ── Phase 2: Completely isolate the HTML ──
    log('BEFORE _isolateHtml');
    html = _isolateHtml(html);
    log('AFTER _isolateHtml — final HTML=${html.length} chars');

    // ── Phase 3: Generate PDF ──
    log('BEFORE _generatePdf');
    final path = await _generatePdf(html, fileNamePrefix, log);
    log('END generatePdfFromHtml — saved to: $path (${sw.elapsedMilliseconds}ms total)');
    return path;
  }

  // ── Phase 1 helpers ────────────────────────────────────────────────────────

  Future<String> _downloadAndInlineResources(
    String html,
    void Function(String) log,
  ) async {
    log('_stripScripts START');
    html = _stripScripts(html);
    log('_stripScripts DONE');

    log('_embedCssAsInline START');
    html = await _embedCssAsInline(html, log);
    log('_embedCssAsInline DONE — HTML=${html.length} chars');

    log('_embedImagesAsBase64 START');
    html = await _embedImagesAsBase64(html, log);
    log('_embedImagesAsBase64 DONE — HTML=${html.length} chars');

    return html;
  }

  // ── Phase 2 helper ─────────────────────────────────────────────────────────

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

  // ── Phase 3 helper ─────────────────────────────────────────────────────────

  Future<String> _generatePdf(
    String html,
    String prefix,
    void Function(String) log,
  ) async {
    log('_getWriteablePath START');
    final targetPath = await _getWriteablePath();
    log('_getWriteablePath DONE — path=$targetPath');

    final name = '${prefix}_${DateTime.now().millisecondsSinceEpoch}';
    log('BEFORE HtmlToPdfConverter.convertHtmlToPdf — target=$targetPath/$name');

    try {
      final converter = HtmlToPdfConverter();
      final pdfFile = await converter
          .convertHtmlToPdf(
            html: html,
            targetDirectory: targetPath,
            targetName: name,
            pageSize: PdfPageSize.a4,
          )
          .timeout(
        const Duration(seconds: 60),
        onTimeout: () => throw _PdfTimeoutException(),
      );

      log('AFTER HtmlToPdfConverter.convertHtmlToPdf — path=${pdfFile.path}');

      if (!File(pdfFile.path).existsSync()) {
        log('ERROR: PDF file does not exist after conversion!');
        throw Exception('الملف لم يُنشأ بنجاح');
      }

      log('✔ PDF created and verified: ${pdfFile.path}');
      return pdfFile.path;
    } on _PdfTimeoutException {
      log('✗ TIMEOUT: convertHtmlToPdf exceeded 60 s');
      throw Exception(
        'استغرق توليد العقد وقتاً أطول من المتوقع. '
        'يرجى المحاولة مرة أخرى.',
      );
    } catch (e) {
      log('✗ ERROR in convertHtmlToPdf: $e');
      rethrow;
    }
  }

  // ── File-system helpers ────────────────────────────────────────────────────

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

  // ── Resource-inlining helpers ──────────────────────────────────────────────

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

  Future<String> _embedCssAsInline(
    String html,
    void Function(String) log,
  ) async {
    final re = RegExp(
      r'<link[^>]+href="([^">]+\.css[^"]*)"[^>]*>',
      caseSensitive: false,
    );
    final dio = Dio();
    final matches = re.allMatches(html).toList();
    log('CSS: found ${matches.length} external stylesheet(s)');

    for (final m in matches) {
      final tag = m.group(0)!;
      final url = m.group(1)!;
      if (!url.startsWith('http')) continue;
      final safe = url.replaceFirst('http://', 'https://');
      log('CSS: BEFORE download — $safe');
      try {
        final r = await dio.get<String>(
          safe,
          options: Options(
            receiveTimeout: const Duration(seconds: 8),
            sendTimeout: const Duration(seconds: 8),
          ),
        );
        if (r.statusCode == 200 && r.data != null) {
          log('CSS: AFTER download — OK (${r.data!.length} chars)');
          html = html.replaceFirst(tag, '<style>${r.data}</style>');
        } else {
          log('CSS: AFTER download — non-200: ${r.statusCode}');
          html = html.replaceFirst(tag, '');
        }
      } catch (e) {
        log('CSS: FAILED — $url — $e');
        html = html.replaceFirst(tag, '');
      }
    }
    return html;
  }

  Future<String> _embedImagesAsBase64(
    String html,
    void Function(String) log,
  ) async {
    final re = RegExp(
      r'<img[^>]+src="(https?://[^">]+)"[^>]*>',
      caseSensitive: false,
    );
    final dio = Dio();
    final matches = re.allMatches(html).toList();
    log('Images: found ${matches.length} external image(s)');

    for (final m in matches) {
      final tag = m.group(0)!;
      final url = m.group(1)!;
      final safe = url.replaceFirst('http://', 'https://');
      log('Image: BEFORE download — $safe');
      try {
        final r = await dio.get<List<int>>(
          safe,
          options: Options(
            responseType: ResponseType.bytes,
            receiveTimeout: const Duration(seconds: 8),
            sendTimeout: const Duration(seconds: 8),
          ),
        );
        if (r.statusCode == 200 && r.data != null) {
          final b64 = base64Encode(r.data!);
          final mime = url.toLowerCase().endsWith('.png')
              ? 'image/png'
              : 'image/jpeg';
          log('Image: AFTER download — OK (${r.data!.length} bytes)');
          html = html.replaceFirst(
            tag,
            tag.replaceFirst(url, 'data:$mime;base64,$b64'),
          );
        } else {
          log('Image: AFTER download — non-200: ${r.statusCode}');
          html = html.replaceFirst(tag, '');
        }
      } catch (e) {
        log('Image: FAILED — $url — $e');
        html = html.replaceFirst(tag, '');
      }
    }
    return html;
  }
}

// ─── Internal exception ───────────────────────────────────────────────────────

class _PdfTimeoutException implements Exception {}
