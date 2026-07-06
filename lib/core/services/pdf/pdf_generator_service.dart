import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_html_to_pdf_plus/flutter_html_to_pdf_plus.dart';

abstract class IPdfGeneratorService {
  Future<String> generatePdfFromHtml(String htmlContent, {String fileNamePrefix = 'contract'});
}

class PdfGeneratorServiceImpl implements IPdfGeneratorService {
  @override
  Future<String> generatePdfFromHtml(String htmlContent, {String fileNamePrefix = 'contract'}) async {
    // 1. Strip scripts to prevent any issues during rendering (e.g. window.print())
    String cleanedHtml = _stripScripts(htmlContent);

    // 1.5 Inject Google Fonts for Cairo and Amiri
    cleanedHtml = _injectFonts(cleanedHtml);

    // 1.6 Inject CSS for printing to fix page breaks
    cleanedHtml = _injectPrintStyles(cleanedHtml);

    // 1.8 Strip hardcoded tailwind break-inside-avoid classes to prevent massive white spaces
    cleanedHtml = cleanedHtml.replaceAll('break-inside-avoid', 'break-inside-auto');

    debugPrint('HTML length after strip: ${cleanedHtml.length}');

    final dir = await getApplicationDocumentsDirectory();
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
      const Duration(seconds: 30),
      onTimeout: () => throw Exception('انتهت مهلة توليد الملف. يرجى المحاولة مرة أخرى.'),
    );

    return generatedPdfFile.path;
  }

  String _stripScripts(String html) {
    String cleaned = html.replaceAll(
      RegExp(r'<script[^>]*>[\s\S]*?<\/script>', caseSensitive: false),
      '',
    );
    // Remove inline onload attributes just in case
    cleaned = cleaned.replaceAll(
      RegExp(r"""onload\s*=\s*['"][^'"]*window\.print[^'"]*['"]""", caseSensitive: false),
      '',
    );
    return cleaned;
  }

  String _injectFonts(String html) {
    const fontsLink = '<link href="https://fonts.googleapis.com/css2?family=Cairo:wght@400;700;900&family=Amiri:wght@400;700&display=swap" rel="stylesheet">';
    final lower = html.toLowerCase();
    final idx = lower.indexOf('</head>');
    if (idx != -1) return html.substring(0, idx) + fontsLink + html.substring(idx);
    
    final bodyIdx = lower.indexOf('<body');
    if (bodyIdx != -1) return html.substring(0, bodyIdx) + fontsLink + html.substring(bodyIdx);
    
    return fontsLink + html;
  }

  String _injectPrintStyles(String html) {
    const printStyles = '''
<style>
  @media print {
    /* منع كسر الصفحات داخل الصفوف والصور فقط، للسماح للجداول الكبيرة بالانقسام بشكل طبيعي */
    tr, img, svg {
      page-break-inside: avoid !important;
      break-inside: avoid !important;
    }
    
    /* السماح للجداول والحاويات بالانقسام بين الصفحات لتعبئة الصفحة الأولى بالكامل */
    table, tbody, thead, tfoot, body, html, main, .container, .wrapper, .main-content, .row, .grid, .flex {
      page-break-inside: auto !important;
      break-inside: auto !important;
    }
    
    /* العناوين لا يجب أن تنفصل عن محتواها */
    h1, h2, h3, h4, h5, h6 {
      page-break-after: avoid !important;
      break-after: avoid !important;
    }

    /* استثناء الحاويات الكبيرة والسماح لها بالانقسام بشكل طبيعي */
    body, html, main, .container, .wrapper, .main-content, .row {
      page-break-inside: auto !important;
      break-inside: auto !important;
    }

    /* هوامش إضافية للصفحة لترتيب المحتوى المطبوع */
    @page {
      margin: 15mm !important;
    }
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
