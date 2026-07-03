import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';
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
            // 1. Force scrolling — print CSS often sets overflow:hidden / height:100vh
            //    which blocks touch scrolling on real devices (emulator ignores this).
            // 2. Inject Cairo Arabic font for readable contract text.
            _controller?.runJavaScript(r"""
              (function() {
                /* ── Scroll fix ── */
                var scrollStyle = document.createElement('style');
                scrollStyle.innerHTML = [
                  'html, body {',
                  '  overflow: auto !important;',
                  '  height: auto !important;',
                  '  min-height: 100% !important;',
                  '  -webkit-overflow-scrolling: touch !important;',
                  '}',
                  '@media print {',
                  '  html, body {',
                  '    overflow: auto !important;',
                  '    height: auto !important;',
                  '  }',
                  '}'
                ].join('');
                document.head.appendChild(scrollStyle);

                /* ── Arabic font ── */
                var fontLink = document.createElement('link');
                fontLink.rel = 'stylesheet';
                fontLink.href = 'https://fonts.googleapis.com/css2?family=Cairo:wght@400;500;600;700&display=swap';
                document.head.appendChild(fontLink);

                var fontStyle = document.createElement('style');
                fontStyle.innerHTML = "* { font-family: 'Cairo', sans-serif !important; direction: rtl; }";
                document.head.appendChild(fontStyle);
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
