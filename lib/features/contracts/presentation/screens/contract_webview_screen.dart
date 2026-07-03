import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_extension.dart';

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
  // Cached safe URL (http→https) computed once in _initWebView,
  // reused by _reload to avoid re-computing on every retry.
  String _safeUrl = '';
  // Scroll slider: tracks current scroll position (0.0 – 1.0).
  double _scrollProgress = 0.0;
  // True once the page finishes loading — shows the right-side slider.
  bool _pageLoaded = false;
  // Loading message shown during retries so the user sees progress.
  String _loadingMessage = 'جاري تحضير العقد...';

  @override
  void initState() {
    super.initState();
    // Defer WebView init to after the first frame to avoid main-thread jank.
    WidgetsBinding.instance.addPostFrameCallback((_) => _initWebView());
  }

  Future<void> _initWebView() async {
    if (!mounted) return;

    // Guard: empty URL — show error immediately instead of blank page.
    if (widget.printUrl.isEmpty) {
      setState(() {
        _isPageLoading = false;
        _hasError = true;
        _errorMessage = 'رابط العقد غير متاح. يرجى المحاولة مرة أخرى.';
      });
      return;
    }

    // Android 9+: cleartext HTTP is blocked. Always use HTTPS.
    _safeUrl = widget.printUrl.replaceFirst(RegExp(r'^http://'), 'https://');

    // ── Navigation delegate ──────────────────────────────────────────────────
    final delegate = NavigationDelegate(
      onPageStarted: (_) {
        if (mounted) setState(() => _isPageLoading = true);
      },
      onPageFinished: (url) {
        if (mounted) setState(() { _isPageLoading = false; _pageLoaded = true; });
        // 1. Force scrolling — print CSS sets overflow:hidden / height:100vh which
        //    blocks touch on real devices. Emulators are permissive, masking this.
        // 2. Inject Cairo Arabic font.
        // 3. Listen for scroll events and post progress to Flutter.
        _controller?.runJavaScript(r"""
          (function() {
            /* ── Scroll fix ── */
            var s = document.createElement('style');
            s.innerHTML = 'html,body{overflow:auto!important;height:auto!important;min-height:100%!important;-webkit-overflow-scrolling:touch!important;}';
            document.head.appendChild(s);

            /* ── Arabic font ── */
            var fl = document.createElement('link');
            fl.rel = 'stylesheet';
            fl.href = 'https://fonts.googleapis.com/css2?family=Cairo:wght@400;500;600;700&display=swap';
            document.head.appendChild(fl);
            var fs = document.createElement('style');
            fs.innerHTML = "*{font-family:'Cairo',sans-serif!important;direction:rtl;}";
            document.head.appendChild(fs);

            /* ── Scroll progress channel ── */
            function report() {
              if (typeof ScrollSync === 'undefined') return;
              var max = document.body.scrollHeight - window.innerHeight;
              ScrollSync.postMessage(max > 0 ? (window.scrollY / max).toFixed(4) : '0.0000');
            }
            window.addEventListener('scroll', report, { passive: true });
            setTimeout(report, 600);
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
    );

    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(AppColors.white)
      ..addJavaScriptChannel(
        'ScrollSync',
        onMessageReceived: (msg) {
          final progress = double.tryParse(msg.message) ?? 0.0;
          if (mounted) setState(() => _scrollProgress = progress.clamp(0.0, 1.0));
        },
      )
      ..setNavigationDelegate(delegate);

    if (mounted) setState(() => _controller = controller);

    // ── Load strategy ──────────────────────────────────────────────────
    // Preferred: fetch the HTML via Dio so the request carries the Bearer token
    // (interceptors handle auth automatically). This solves net::ERR_FAILED when
    // the server requires auth headers that a plain WebView request never sends.
    await _loadViaProxy(controller);
  }

  /// Fetches the HTML from [_safeUrl] via Dio (auth + interceptors) then loads
  /// it with loadHtmlString. Retries up to [_maxRetries] times with exponential
  /// back-off because the server generates the contract PDF on first request and
  /// may not be ready immediately (causing the "needs many refreshes" symptom).
  static const int _maxRetries = 4;
  static const List<Duration> _retryDelays = [
    Duration(seconds: 2),
    Duration(seconds: 4),
    Duration(seconds: 8),
  ];

  Future<void> _loadViaProxy(WebViewController controller) async {
    final messages = [
      'جاري تحضير العقد...',
      'يتم إعداد العقد — المحاولة 1 من $_maxRetries...',
      'يتم إعداد العقد — المحاولة 2 من $_maxRetries...',
      'يتم إعداد العقد — المحاولة 3 من $_maxRetries...',
    ];

    for (int attempt = 0; attempt < _maxRetries; attempt++) {
      if (!mounted) return;

      // Update loading message so the user knows we’re retrying, not frozen.
      if (mounted) setState(() => _loadingMessage = messages[attempt]);

      try {
        final dio = sl<Dio>();
        final response = await dio.get<String>(
          _safeUrl,
          options: Options(
            responseType: ResponseType.plain,
            receiveTimeout: const Duration(seconds: 30),
          ),
        );
        final html = (response.data ?? '').replaceFirst('﻿', '').trim();
        final lower = html.toLowerCase();
        // Detect HTML regardless of doctype casing or leading whitespace.
        if (lower.startsWith('<!') || lower.startsWith('<html') ||
            lower.contains('<!doctype html')) {
          await controller.loadHtmlString(html, baseUrl: _safeUrl);
          return;  // ✔️ success
        }
        // Server returned something that isn’t HTML yet (e.g. JSON progress response).
        debugPrint('[ContractWebView] attempt $attempt: non-HTML response, retrying...');
      } on DioException catch (e) {
        debugPrint('[ContractWebView] attempt $attempt: DioException: ${e.message}');
      } catch (e) {
        debugPrint('[ContractWebView] attempt $attempt: $e');
      }

      // Wait before next retry (last attempt has no delay — go to fallback).
      if (attempt < _retryDelays.length) {
        await Future.delayed(_retryDelays[attempt]);
      }
    }

    // All retries exhausted — fall back to direct WebView load.
    // This works if the URL is a signed/public URL that doesn’t need auth headers.
    if (mounted) setState(() => _loadingMessage = 'جاري تحميل العقد...');
    debugPrint('[ContractWebView] All Dio retries failed — falling back to loadRequest.');
    await controller.loadRequest(Uri.parse(_safeUrl));
  }

  Future<void> _reload() async {
    if (_safeUrl.isEmpty) {
      _initWebView();
      return;
    }
    if (_controller == null) {
      await _initWebView();
      return;
    }
    setState(() {
      _isPageLoading = true;
      _hasError = false;
      _errorMessage = '';
      _pageLoaded = false;
    });
    await _loadViaProxy(_controller!);
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
          // WebView — fills the entire body.
          if (!_hasError && _controller != null)
            WebViewWidget(
              controller: _controller!,
              // gestureRecognizers: gives WebView priority in Flutter's gesture arena
              // so vertical touch-scroll works on real Android devices (not just emulators).
              gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                Factory<VerticalDragGestureRecognizer>(
                  () => VerticalDragGestureRecognizer(),
                ),
                Factory<HorizontalDragGestureRecognizer>(
                  () => HorizontalDragGestureRecognizer(),
                ),
              },
            ),
          // Right-side vertical scroll slider — always visible after page loads.
          // Drag the thumb up/down to scroll the contract. Guaranteed to work
          // even when WebView touch gestures compete with Flutter's gesture arena.
          if (_pageLoaded && !_hasError && _controller != null)
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              width: 36,
              child: _buildVerticalScrollSlider(context),
            ),
          if (_isPageLoading) _buildLoadingOverlay(context),
          if (_hasError) _buildErrorView(context),
        ],
      ),
    );
  }

  /// Right-side vertical scroll slider.
  /// The Flutter Slider widget is horizontal by default; RotatedBox(quarterTurns:1)
  /// rotates it 90° clockwise: left-end (0.0) → top, right-end (1.0) → bottom.
  /// LayoutBuilder provides the available height so the rotated slider fills it.
  Widget _buildVerticalScrollSlider(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        return Container(
          decoration: BoxDecoration(
            color: context.colors.white.withValues(alpha: 0.88),
            border: Border(
              left: BorderSide(
                color: context.colors.border,
                width: 1,
              ),
            ),
          ),
          child: RotatedBox(
            quarterTurns: 1,            // 90° CW: left(0.0)=top, right(1.0)=bottom
            child: SizedBox(
              width: constraints.maxHeight,
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 3,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 9),
                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 18),
                  activeTrackColor: context.colors.primary,
                  inactiveTrackColor: context.colors.border,
                  thumbColor: context.colors.primary,
                  overlayColor: context.colors.primary.withValues(alpha: 0.15),
                ),
                child: Slider(
                  value: _scrollProgress,
                  onChanged: (value) {
                    setState(() => _scrollProgress = value);
                    // Directly scroll the WebView via JS — no smooth behavior
                    // (smooth is unsupported on some Android system WebViews).
                    _controller?.runJavaScript(
                      'window.scrollTo(0, $value * (document.body.scrollHeight - window.innerHeight));',
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
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
              _loadingMessage,
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
