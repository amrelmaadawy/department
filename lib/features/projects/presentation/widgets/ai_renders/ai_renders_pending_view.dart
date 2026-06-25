import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import '../../../../../core/theme/app_fonts.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/theme_extension.dart';

class AiRendersPendingView extends StatefulWidget {
  final String statusLabel;
  final List<String> projectFeatures;
  final String projectName;

  const AiRendersPendingView({
    super.key,
    required this.statusLabel,
    this.projectFeatures = const [],
    this.projectName = '',
  });

  @override
  State<AiRendersPendingView> createState() => _AiRendersPendingViewState();
}

class _AiRendersPendingViewState extends State<AiRendersPendingView>
    with TickerProviderStateMixin {
  late AnimationController _shimmerController;
  late AnimationController _pulseController;
  late AnimationController _featureController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _shimmerAnimation;

  Timer? _statusTimer;
  int _currentStatusIndex = 0;
  int _visibleFeatureCount = 0;
  Timer? _featureRevealTimer;

  final List<String> _aiStatuses = [
    'جاري تحليل أبعاد الغرفة...',
    'مطابقة الخامات مع النمط المختار...',
    'تطبيق التصميم المعماري...',
    'محاكاة الإضاءة الطبيعية والصناعية...',
    'ضبط زوايا الكاميرا...',
    'إضافة اللمسات الفنية النهائية...',
    'معالجة الصورة بجودة عالية...',
  ];

  @override
  void initState() {
    super.initState();

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _shimmerAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _featureController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _statusTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (mounted) {
        setState(() {
          _currentStatusIndex = (_currentStatusIndex + 1) % _aiStatuses.length;
        });
      }
    });

    // Reveal features one by one
    final features = _displayFeatures;
    if (features.isNotEmpty) {
      _featureRevealTimer = Timer.periodic(const Duration(milliseconds: 600), (t) {
        if (mounted && _visibleFeatureCount < features.length) {
          setState(() => _visibleFeatureCount++);
        } else {
          t.cancel();
        }
      });
    }
  }

  List<String> get _displayFeatures {
    final features = widget.projectFeatures.where((f) => f.trim().isNotEmpty).toList();
    return features.isEmpty ? _fallbackFeatures : features;
  }

  final List<String> _fallbackFeatures = [
    'تشطيب فاخر بأعلى المواد',
    'تصميم داخلي عصري ومميز',
    'موقع استراتيجي متميز',
    'مساحات واسعة ومريحة',
    'أمن وحراسة على مدار الساعة',
    'مواقف سيارات مخصصة',
  ];

  @override
  void dispose() {
    _shimmerController.dispose();
    _pulseController.dispose();
    _featureController.dispose();
    _statusTimer?.cancel();
    _featureRevealTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final features = _displayFeatures;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.lg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── AI Processing Card ──────────────────────────────
            _buildProcessingCard(context),
            const SizedBox(height: AppSpacing.xl),

            // ── Project Features Section ────────────────────────
            _buildSectionHeader(
              context,
              icon: FluentIcons.star_24_filled,
              title: widget.projectName.isNotEmpty
                  ? 'مميزات ${widget.projectName}'
                  : 'مميزات المشروع',
            ),
            const SizedBox(height: AppSpacing.md),

            // Features grid
            LayoutBuilder(
              builder: (context, constraints) {
                final chipWidth = (constraints.maxWidth - AppSpacing.sm) / 2;
                return Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: List.generate(
                    features.length,
                    (index) {
                      final isVisible = index < _visibleFeatureCount;
                      return AnimatedOpacity(
                        duration: const Duration(milliseconds: 400),
                        opacity: isVisible ? 1.0 : 0.0,
                        child: AnimatedSlide(
                          duration: const Duration(milliseconds: 400),
                          offset: isVisible ? Offset.zero : const Offset(0, 0.3),
                          child: SizedBox(
                            width: chipWidth,
                            child: _buildFeatureChip(context, features[index], index),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),

            const SizedBox(height: AppSpacing.xl),

            // ── Why AI Design? ──────────────────────────────────
            _buildSectionHeader(
              context,
              icon: FluentIcons.sparkle_24_filled,
              title: 'لماذا التصميم بالذكاء الاصطناعي؟',
            ),
            const SizedBox(height: AppSpacing.md),
            _buildAiBenefitsCard(context, isDark),

            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildProcessingCard(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  context.colors.primary,
                  context.colors.primary.withValues(alpha: 0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(AppRadius.xl),
              boxShadow: [
                BoxShadow(
                  color: context.colors.primary.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                const Icon(
                  FluentIcons.sparkle_28_filled,
                  color: Colors.white,
                  size: 40,
                ),
                const SizedBox(height: AppSpacing.md),
                const Text(
                  'الذكاء الاصطناعي يعمل الآن',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: AppFonts.headlineSmall,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder: (child, animation) =>
                      FadeTransition(opacity: animation, child: child),
                  child: Text(
                    widget.statusLabel.isNotEmpty
                        ? widget.statusLabel
                        : _aiStatuses[_currentStatusIndex],
                    key: ValueKey(_currentStatusIndex),
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: AppFonts.bodyMedium,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                // Shimmer progress bar
                AnimatedBuilder(
                  animation: _shimmerAnimation,
                  builder: (context, child) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.round),
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            stops: [
                              (_shimmerAnimation.value - 0.3).clamp(0.0, 1.0),
                              _shimmerAnimation.value.clamp(0.0, 1.0),
                              (_shimmerAnimation.value + 0.3).clamp(0.0, 1.0),
                            ],
                            colors: [
                              Colors.white.withValues(alpha: 0.2),
                              Colors.white.withValues(alpha: 0.8),
                              Colors.white.withValues(alpha: 0.2),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(
    BuildContext context, {
    required IconData icon,
    required String title,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: context.colors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Icon(icon, color: context.colors.primary, size: 18),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: AppFonts.bodyLarge,
              fontWeight: FontWeight.bold,
              color: context.colors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureChip(BuildContext context, String feature, int index) {
    final colors = [
      context.colors.primary,
      context.colors.gold,
      context.colors.success,
      context.colors.primary.withValues(alpha: 0.7),
    ];
    final color = colors[index % colors.length];

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(FluentIcons.checkmark_circle_24_filled, color: color, size: 16),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              feature,
              style: TextStyle(
                fontSize: AppFonts.bodySmall,
                color: context.colors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 3,
              overflow: TextOverflow.visible,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAiBenefitsCard(BuildContext context, bool isDark) {
    final benefits = [
      (FluentIcons.image_sparkle_24_regular, 'تصور واقعي بجودة فائقة قبل التنفيذ'),
      (FluentIcons.timer_24_regular, 'توفير الوقت والجهد في التخطيط'),
      (FluentIcons.paint_brush_24_regular, 'استكشاف أنماط لا نهائية من التصاميم'),
      (FluentIcons.money_24_regular, 'اتخاذ قرار شراء أكثر ثقة وذكاء'),
    ];

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.colors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(
          color: context.colors.gold.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: benefits.map((benefit) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: context.colors.gold.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(benefit.$1, color: context.colors.gold, size: 16),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Text(
                      benefit.$2,
                      style: TextStyle(
                        fontSize: AppFonts.bodyMedium,
                        color: context.colors.textPrimary,
                        height: 1.4,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
