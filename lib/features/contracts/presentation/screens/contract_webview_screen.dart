import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
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
  double _scrollProgress = 0.0;
  bool _pageLoaded = false;
  String _loadingMessage = 'جاري تحضير العقد...';
  // Scrollbar auto-hide: visible for 2 s after any scroll activity.
  bool _showScrollbar = false;
  Timer? _scrollbarHideTimer;

  void _onScrollActivity() {
    _scrollbarHideTimer?.cancel();
    if (!_showScrollbar && mounted) setState(() => _showScrollbar = true);
    _scrollbarHideTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _showScrollbar = false);
    });
  }

  @override
  void dispose() {
    _scrollbarHideTimer?.cancel();
    super.dispose();
  }

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
        // Inject scroll fix + scroll-progress channel via JS.
        // NOTE: Do NOT add external resources (e.g. Google Fonts) here —
        // any failed sub-resource request fires onWebResourceError which
        // was previously swallowing the whole page as a fatal error.
        _controller?.runJavaScript(r"""
          (function init() {
            /* ── Aggressive overflow unlock ──────────────────────────────────────
               Contract pages often wrap all content in a fixed-height container
               (height:100vh, overflow:hidden). We must fix EVERY element, not
               just html/body, otherwise window.scrollTo has nothing to scroll.  */
            function unlockScroll() {
              var els = document.querySelectorAll('*');
              for (var i = 0; i < els.length; i++) {
                var el = els[i];
                var cs = window.getComputedStyle(el);
                if (cs.overflow === 'hidden' || cs.overflowY === 'hidden') {
                  el.style.setProperty('overflow',  'visible', 'important');
                  el.style.setProperty('overflow-y','visible', 'important');
                }
                /* Un-fix any element taller than 90% of the viewport */
                var h = parseFloat(cs.height);
                if (!isNaN(h) && h >= window.innerHeight * 0.9) {
                  el.style.setProperty('height',    'auto',    'important');
                  el.style.setProperty('max-height','none',    'important');
                }
              }
              /* Make the document itself scrollable */
              document.documentElement.style.setProperty('overflow-y','auto','important');
              document.documentElement.style.setProperty('height',    'auto','important');
              document.body.style.setProperty('overflow-y','auto','important');
              document.body.style.setProperty('height',    'auto','important');
            }

            /* Run immediately and again after 1 s (lazy-rendered frameworks) */
            unlockScroll();
            setTimeout(unlockScroll, 1000);

            /* ── Scroll progress channel ── */
            function report() {
              if (typeof ScrollSync === 'undefined') return;
              var docH = Math.max(
                document.body.scrollHeight,
                document.documentElement.scrollHeight
              );
              var max = docH - window.innerHeight;
              var pos = window.scrollY || document.documentElement.scrollTop || 0;
              ScrollSync.postMessage(max > 0 ? (pos / max).toFixed(4) : '0.0000');
            }
            window.addEventListener('scroll', report, { passive: true });
            setTimeout(report, 1200);
          })();
        """);
      },
      onWebResourceError: (error) {
        // CRITICAL: Only treat MAIN-FRAME errors as fatal.
        // Sub-resource failures (CSS, images, external fonts) are expected
        // on restricted networks and must NOT block the contract from showing.
        // error.isForMainFrame is null on older platform versions — treat null as main-frame.
        if (error.isForMainFrame == false) return;
        if (mounted) {
          setState(() {
            _isPageLoading = false;
            _hasError = true;
            _errorMessage = error.description;
          });
        }
      },
    );

    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is AndroidWebViewPlatform) {
      params = AndroidWebViewControllerCreationParams();
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final controller = WebViewController.fromPlatformCreationParams(params)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(AppColors.white)
      ..addJavaScriptChannel(
        'ScrollSync',
        onMessageReceived: (msg) {
          final progress = double.tryParse(msg.message) ?? 0.0;
          if (mounted) {
            setState(() => _scrollProgress = progress.clamp(0.0, 1.0));
            _onScrollActivity(); // auto-show scrollbar when page scrolls
          }
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
          // Inject scroll-fix CSS directly into the HTML *before* loading.
          // This is more reliable than injecting via JS after onPageFinished
          // because it prevents any page JS from overriding overflow:hidden.
          final fixedHtml = _injectScrollCss(html);
          await controller.loadHtmlString(fixedHtml, baseUrl: _safeUrl);
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

  /// Injects scroll-fix CSS into the HTML string before it is loaded.
  /// Injecting here (not via runJavaScript after load) prevents page scripts
  /// from overriding the styles before the browser has applied them.
  static String _injectScrollCss(String html) {
    // Targets all common block containers used in server-rendered contract pages.
    // `!important` overrides any inline style or print-stylesheet rules.
    const css = '<style>'
        'html,body,div,section,main,article,aside,header,footer,form,table{'
        '  overflow:visible!important;'
        '  height:auto!important;'
        '  min-height:0!important;'
        '  max-height:none!important;'
        '}'
        'html,body{'
        '  overflow-y:auto!important;'
        '  -webkit-overflow-scrolling:touch!important;'
        '  position:relative!important;'
        '}'
        '@media print{'
        '  html,body{overflow:auto!important;height:auto!important;}'
        '}'
        '</style>';
    final lower = html.toLowerCase();
    final idx = lower.indexOf('</head>');
    if (idx != -1) return html.substring(0, idx) + css + html.substring(idx);
    final bodyIdx = lower.indexOf('<body');
    if (bodyIdx != -1) return html.substring(0, bodyIdx) + css + html.substring(bodyIdx);
    return css + html;
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
          // The WebView is rendered using Hybrid Composition on Android to ensure
          // touch events are correctly routed to the native Android view without
          // needing EagerGestureRecognizer, which previously blocked scrolling.
          if (!_hasError && _controller != null)
            Builder(
              builder: (context) {
                if (WebViewPlatform.instance is AndroidWebViewPlatform) {
                  return WebViewWidget.fromPlatformCreationParams(
                    params: AndroidWebViewWidgetCreationParams(
                      controller: _controller!.platform,
                      displayWithHybridComposition: true,
                    ),
                  );
                }
                return WebViewWidget(
                  controller: _controller!,
                );
              },
            ),
          // Native-style scrollbar overlay — thin iOS pill on the right edge.
          // It sits ABOVE the WebView in the Stack, so its GestureDetector
          // captures drags in the scrollbar area before the WebView does.
          if (_pageLoaded && !_hasError && _controller != null)
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              width: 20,
              child: _buildNativeScrollbar(context),
            ),
          if (_isPageLoading) _buildLoadingOverlay(context),
          if (_hasError) _buildErrorView(context),
        ],
      ),
    );
  }

  /// Native-style scrollbar: thin iOS-inspired pill painted via CustomPainter.
  /// The GestureDetector captures vertical drags in the 20px strip and
  /// translates them to JS window.scrollTo() calls.
  Widget _buildNativeScrollbar(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        final trackH = constraints.maxHeight;
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onVerticalDragUpdate: (d) {
            const thumbH = 48.0;
            final delta = d.delta.dy / (trackH - thumbH);
            final next = (_scrollProgress + delta).clamp(0.0, 1.0);
            setState(() => _scrollProgress = next);
            _controller?.runJavaScript('''
              (function(p) {
                var docH = Math.max(
                  document.body.scrollHeight,
                  document.documentElement.scrollHeight
                );
                var max = docH - window.innerHeight;
                if (max > 0) {
                  window.scrollTo(0, p * max);
                  document.documentElement.scrollTop = p * max;
                }
              })($next);
            ''');
            _onScrollActivity();
          },
          child: AnimatedOpacity(
            opacity: _showScrollbar ? 1.0 : 0.25,
            duration: const Duration(milliseconds: 300),
            child: CustomPaint(
              size: Size(20, trackH),
              painter: _ScrollbarPainter(
                progress: _scrollProgress,
                color: context.colors.primary,
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

/// iOS-inspired native scrollbar painter.
/// Track: 2px semi-transparent line.
/// Thumb: 4px pill, primary color, proportional height (min 40px, max 30% screen).
class _ScrollbarPainter extends CustomPainter {
  const _ScrollbarPainter({required this.progress, required this.color});

  final double progress;
  final Color color;

  static const double _thumbWidth = 4.0;
  static const double _thumbMinH = 40.0;
  static const double _rightPad = 4.0;

  @override
  void paint(Canvas canvas, Size size) {
    final thumbH = (size.height * 0.18).clamp(_thumbMinH, size.height * 0.35);
    final thumbTop = progress * (size.height - thumbH);
    final left = size.width - _thumbWidth - _rightPad;

    // Track (subtle)
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(left, 0, _thumbWidth, size.height),
        const Radius.circular(2),
      ),
      Paint()..color = color.withValues(alpha: 0.12),
    );

    // Thumb
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(left, thumbTop, _thumbWidth, thumbH),
        const Radius.circular(2),
      ),
      Paint()..color = color.withValues(alpha: 0.75),
    );
  }

  @override
  bool shouldRepaint(_ScrollbarPainter old) =>
      old.progress != progress || old.color != color;
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
