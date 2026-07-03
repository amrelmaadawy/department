import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_extension.dart';
import '../../../../core/widgets/app_toast.dart';

/// Displays a server-generated contract print page inside an in-app WebView.
///
/// [printUrl] — signed URL that renders the HTML print view (shown on open).
/// [pdfUrl]   — signed URL for the actual PDF; displayed via Google Docs viewer
///              when the user taps the "عرض / طباعة PDF" button.
class ContractWebViewScreen extends StatefulWidget {
  final String printUrl;
  final String pdfUrl;
  final String contractTitle;

  const ContractWebViewScreen({
    super.key,
    required this.printUrl,
    required this.pdfUrl,
    required this.contractTitle,
  });

  @override
  State<ContractWebViewScreen> createState() => _ContractWebViewScreenState();
}

class _ContractWebViewScreenState extends State<ContractWebViewScreen> {
  WebViewController? _controller;
  bool _isPageLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  bool _isPdfLoading = false;

  @override
  void initState() {
    super.initState();
    // Defer WebView init to after the first frame to avoid main-thread jank.
    WidgetsBinding.instance.addPostFrameCallback((_) => _initWebView());
  }

  void _initWebView() {
    if (!mounted) return;
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(AppColors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            if (mounted) setState(() => _isPageLoading = true);
          },
          onPageFinished: (url) {
            if (mounted) setState(() => _isPageLoading = false);
            // Inject Cairo Arabic font into the server's HTML page.
            _controller?.runJavaScript(r"""
              (function() {
                var link = document.createElement('link');
                link.rel = 'stylesheet';
                link.href = 'https://fonts.googleapis.com/css2?family=Cairo:wght@400;500;600;700&display=swap';
                document.head.appendChild(link);

                var style = document.createElement('style');
                style.innerHTML = "* { font-family: 'Cairo', sans-serif !important; direction: rtl; }";
                document.head.appendChild(style);
              })();
            """);
          },
          onWebResourceError: (error) {
            if (mounted) {
              setState(() {
                _isPageLoading = false;
                _hasError = true;
                _errorMessage = error.description;
              });
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.printUrl));

    if (mounted) setState(() => _controller = controller);
  }

  Future<void> _reload() async {
    if (_controller == null) {
      _initWebView();
      return;
    }
    setState(() {
      _isPageLoading = true;
      _hasError = false;
      _errorMessage = '';
    });
    try {
      await _controller!.loadRequest(Uri.parse(widget.printUrl));
    } catch (_) {
      if (mounted) AppToast.showError(context, 'فشل إعادة تحميل الصفحة');
    }
  }

  /// Downloads the PDF bytes silently via Dio, saves to a temp file,
  /// then opens the system share sheet.
  /// The user can pick any installed PDF viewer (Adobe, WPS, Drive, etc.)
  /// or save to Downloads — nothing automatically leaves the app UI.
  Future<void> _openPdfPreview() async {
    if (_isPdfLoading) return;
    if (widget.pdfUrl.isEmpty) {
      AppToast.showError(context, 'رابط الملف غير متاح');
      return;
    }

    setState(() => _isPdfLoading = true);
    try {
      // The pdf_url is self-signed — no Bearer token needed.
      final response = await Dio(BaseOptions(
        receiveTimeout: const Duration(seconds: 60),
        sendTimeout: const Duration(seconds: 30),
      )).get<List<int>>(
        widget.pdfUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      final bytes = response.data;
      if (bytes == null || bytes.isEmpty) throw Exception('الملف فارغ');

      // Save to temp directory (avoids Scoped Storage issues on Android 10+).
      final dir = await getTemporaryDirectory();
      final safeTitle = widget.contractTitle.replaceAll(RegExp(r'[^\w\u0600-\u06FF]'), '_');
      final filePath = '${dir.path}/${safeTitle}_${DateTime.now().millisecondsSinceEpoch}.pdf';
      await File(filePath).writeAsBytes(bytes);

      if (!mounted) return;

      // Share sheet lets the user open in PDF viewer / share / save to Drive.
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(filePath, mimeType: 'application/pdf')],
          subject: widget.contractTitle,
        ),
      );
    } catch (e) {
      if (mounted) {
        AppToast.showError(context, 'فشل تحميل ملف العقد. تحقق من الاتصال بالإنترنت.');
      }
    } finally {
      if (mounted) setState(() => _isPdfLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: context.colors.white,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          widget.contractTitle,
          style: TextStyle(
            fontSize: AppFonts.headlineMedium,
            fontWeight: FontWeight.bold,
            color: context.colors.primary,
          ),
        ),
        leading: IconButton(
          icon: Icon(FluentIcons.arrow_left_24_filled, color: context.colors.primary),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            tooltip: 'إعادة تحميل',
            icon: Icon(FluentIcons.arrow_clockwise_24_regular, color: context.colors.primary),
            onPressed: _reload,
          ),
        ],
      ),
      body: Stack(
        children: [
          if (!_hasError && _controller != null)
            WebViewWidget(controller: _controller!),
          if (_isPageLoading) _buildLoadingOverlay(context),
          if (_hasError) _buildErrorView(context),
        ],
      ),
      bottomNavigationBar: _buildActionBar(context),
    );
  }

  Widget _buildActionBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: context.colors.white,
        border: Border(
          top: BorderSide(color: context.colors.border.withValues(alpha: 0.2)),
        ),
      ),
      child: ElevatedButton.icon(
        onPressed: _isPdfLoading ? null : _openPdfPreview,
        style: ElevatedButton.styleFrom(
          backgroundColor: context.colors.primary,
          foregroundColor: AppColors.white,
          disabledBackgroundColor: context.colors.primary.withValues(alpha: 0.4),
          disabledForegroundColor: AppColors.white,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
        ),
        icon: _isPdfLoading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.white),
              )
            : const Icon(FluentIcons.document_pdf_24_regular, size: 20),
        label: Text(
          _isPdfLoading ? 'جاري التحضير...' : 'عرض / طباعة PDF',
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: AppFonts.bodyMedium,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingOverlay(BuildContext context) {
    return Container(
      color: context.colors.background,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: context.colors.primary, strokeWidth: 3),
            const SizedBox(height: AppSpacing.md),
            Text(
              'جاري تحضير العقد...',
              style: TextStyle(
                fontSize: AppFonts.bodyMedium,
                color: context.colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorView(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(FluentIcons.error_circle_24_regular, size: 56, color: context.colors.error),
            const SizedBox(height: AppSpacing.md),
            Text(
              'تعذّر تحميل صفحة العقد',
              style: TextStyle(
                fontSize: AppFonts.headlineSmall,
                fontWeight: FontWeight.bold,
                color: context.colors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              _errorMessage.isNotEmpty
                  ? _errorMessage
                  : 'يرجى التحقق من الاتصال بالإنترنت',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppFonts.bodyMedium,
                color: context.colors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            ElevatedButton.icon(
              onPressed: _reload,
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.primary,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                  vertical: AppSpacing.md,
                ),
              ),
              icon: const Icon(FluentIcons.arrow_clockwise_24_regular),
              label: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Lightweight in-app PDF viewer ───────────────────────────────────────────

/// Loads [url] (the signed pdf_url) directly in a Chrome-based WebView.
/// Android Chromium renders PDFs when Content-Type is application/pdf.
class _InAppPdfViewer extends StatefulWidget {
  final String url;
  final String title;

  const _InAppPdfViewer({required this.url, required this.title});

  @override
  State<_InAppPdfViewer> createState() => _InAppPdfViewerState();
}

class _InAppPdfViewerState extends State<_InAppPdfViewer> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(AppColors.white)
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (_) {
          if (mounted) setState(() { _isLoading = true; _hasError = false; });
        },
        onPageFinished: (_) {
          if (mounted) setState(() => _isLoading = false);
        },
        onWebResourceError: (_) {
          if (mounted) setState(() { _isLoading = false; _hasError = true; });
        },
      ))
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: context.colors.white,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          widget.title,
          style: TextStyle(
            fontSize: AppFonts.headlineMedium,
            fontWeight: FontWeight.bold,
            color: context.colors.primary,
          ),
        ),
        leading: IconButton(
          icon: Icon(FluentIcons.arrow_left_24_filled, color: context.colors.primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            tooltip: 'إعادة تحميل',
            icon: Icon(FluentIcons.arrow_clockwise_24_regular, color: context.colors.primary),
            onPressed: () => _controller.loadRequest(Uri.parse(widget.url)),
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            Container(
              color: context.colors.background,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: context.colors.primary, strokeWidth: 3),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'جاري تحميل ملف العقد...',
                      style: TextStyle(
                        fontSize: AppFonts.bodyMedium,
                        color: context.colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (_hasError)
            Container(
              color: context.colors.background,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(FluentIcons.document_error_24_regular,
                          size: 56, color: context.colors.error),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'تعذّر عرض ملف العقد',
                        style: TextStyle(
                          fontSize: AppFonts.headlineSmall,
                          fontWeight: FontWeight.bold,
                          color: context.colors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'قد لا يدعم المتصفح المدمج عرض ملفات PDF مباشرة.\nيرجى المحاولة مرة أخرى.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: AppFonts.bodyMedium,
                          color: context.colors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      ElevatedButton.icon(
                        onPressed: () => _controller.loadRequest(Uri.parse(widget.url)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.colors.primary,
                          foregroundColor: AppColors.white,
                        ),
                        icon: const Icon(FluentIcons.arrow_clockwise_24_regular),
                        label: const Text('إعادة المحاولة'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
