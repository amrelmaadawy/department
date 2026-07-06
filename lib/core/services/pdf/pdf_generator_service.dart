import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_html_to_pdf_plus/flutter_html_to_pdf_plus.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

abstract class IPdfGeneratorService {
  Future<String> generatePdfFromHtml(String htmlContent, {String fileNamePrefix = 'contract'});
}

class PdfGeneratorServiceImpl implements IPdfGeneratorService {
  @override
  Future<String> generatePdfFromHtml(String htmlContent, {String fileNamePrefix = 'contract'}) async {
    // 1. Strip scripts to prevent any issues during rendering (e.g. window.print())
    String cleanedHtml = _stripScripts(htmlContent);

    // 2. Embed CSS directly to prevent network hangs
    cleanedHtml = await _embedCssAsInline(cleanedHtml);

    // 3. Embed Images as Base64 to prevent network hangs
    cleanedHtml = await _embedImagesAsBase64(cleanedHtml);

    // 4. Inject CSS for printing to fix page breaks
    cleanedHtml = _injectPrintStyles(cleanedHtml);

    // 5. Strip hardcoded tailwind break-inside-avoid classes to prevent massive white spaces
    cleanedHtml = cleanedHtml.replaceAll('break-inside-avoid', 'break-inside-auto');

    debugPrint('HTML length after embedding: ${cleanedHtml.length}');

    final dir = await getTemporaryDirectory();
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
    final targetPath = dir.path;
    final targetFileName = '${fileNamePrefix}_${DateTime.now().millisecondsSinceEpoch}';

    final generatedPdfFile = await FlutterHtmlToPdf.convertFromHtmlContent(
      content: cleanedHtml,
      configuration: PrintPdfConfiguration(
        targetDirectory: targetPath,
        targetName: targetFileName,
        margins: const PdfPageMargin(top: 90, bottom: 90, left: 50, right: 50),
        printSize: PrintSize.A4,
      ),
    ).timeout(
      const Duration(seconds: 45),
      onTimeout: () => throw Exception('تعذر توليد العقد. يرجى التأكد من مساحة التخزين وصلاحيات التطبيق.'),
    );

    return generatedPdfFile.path;
  }

  String _stripScripts(String html) {
    String cleaned = html.replaceAll(
      RegExp(r'<script[^>]*>[\s\S]*?<\/script>', caseSensitive: false),
      '',
    );
    cleaned = cleaned.replaceAll(
      RegExp(r"""onload\s*=\s*['"][^'"]*window\.print[^'"]*['"]""", caseSensitive: false),
      '',
    );
    return cleaned;
  }

  Future<String> _embedCssAsInline(String html) async {
    final RegExp linkRegExp = RegExp(r'<link[^>]+href="([^">]+\.css[^"]*)"[^>]*>', caseSensitive: false);
    final Iterable<Match> matches = linkRegExp.allMatches(html);
    
    String newHtml = html;
    final dio = Dio();
    
    for (final match in matches) {
      final tag = match.group(0)!;
      final url = match.group(1)!;
      
      if (url.startsWith('http')) {
        try {
          final safeUrl = url.replaceFirst('http://', 'https://');
          final response = await dio.get<String>(
            safeUrl,
            options: Options(receiveTimeout: const Duration(seconds: 10)),
          );
          if (response.statusCode == 200 && response.data != null) {
            newHtml = newHtml.replaceFirst(tag, '<style>${response.data}</style>');
          } else {
            newHtml = newHtml.replaceFirst(tag, '');
          }
        } catch (e) {
          debugPrint('Failed to download css: $url');
          newHtml = newHtml.replaceFirst(tag, ''); // Remove if fails so it doesn't hang WebView
        }
      }
    }
    return newHtml;
  }

  Future<String> _embedImagesAsBase64(String html) async {
    final RegExp imgRegExp = RegExp(r'<img[^>]+src="([^">]+)"[^>]*>', caseSensitive: false);
    final Iterable<Match> matches = imgRegExp.allMatches(html);
    
    String newHtml = html;
    final dio = Dio();
    
    for (final match in matches) {
      final tag = match.group(0)!;
      final url = match.group(1)!;
      
      if (url.startsWith('http')) {
        try {
          final safeUrl = url.replaceFirst('http://', 'https://');
          final response = await dio.get<List<int>>(
            safeUrl,
            options: Options(responseType: ResponseType.bytes, receiveTimeout: const Duration(seconds: 10)),
          );
          if (response.statusCode == 200 && response.data != null) {
            final base64String = base64Encode(response.data!);
            final mimeType = url.toLowerCase().endsWith('.png') ? 'image/png' : 'image/jpeg';
            final dataUrl = 'data:$mimeType;base64,$base64String';
            final newTag = tag.replaceFirst(url, dataUrl);
            newHtml = newHtml.replaceFirst(tag, newTag);
          } else {
            newHtml = newHtml.replaceFirst(tag, ''); 
          }
        } catch (e) {
          debugPrint('Failed to download image: $url');
          newHtml = newHtml.replaceFirst(tag, ''); // Remove if fails so it doesn't hang WebView
        }
      }
    }
    return newHtml;
  }

  String _injectPrintStyles(String html) {
    const printStyles = '''
<style>
  @media print {
    tr, img, svg {
      page-break-inside: avoid !important;
      break-inside: avoid !important;
    }
    table, tbody, thead, tfoot, body, html, main, .container, .wrapper, .main-content, .row, .grid, .flex {
      page-break-inside: auto !important;
      break-inside: auto !important;
    }
    h1, h2, h3, h4, h5, h6 {
      page-break-after: avoid !important;
      break-after: avoid !important;
    }
    @page { margin: 15mm !important; }
  }
</style>
''';
    final lower = html.toLowerCase();
    final idx = lower.indexOf('</head>');
    if (idx != -1) return html.substring(0, idx) + printStyles + html.substring(idx);
    
    final bodyIdx = lower.indexOf('<body');
    if (bodyIdx != -1) return html.substring(0, bodyIdx) + printStyles + html.substring(bodyIdx);
    
    return printStyles + html;
  }
}
