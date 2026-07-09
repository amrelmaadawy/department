import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_fonts.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/theme_extension.dart';
import '../../../../../l10n/app_localizations.dart';

class AiRendersErrorView extends StatefulWidget {
  final String message;
  final VoidCallback onRetry;

  const AiRendersErrorView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  State<AiRendersErrorView> createState() => _AiRendersErrorViewState();
}

class _AiRendersErrorViewState extends State<AiRendersErrorView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeIn;
  late final Animation<double> _slideUp;
  late final Animation<double> _iconScale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    _fadeIn = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );
    _slideUp = Tween<double>(begin: 40, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
      ),
    );
    _iconScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return FadeTransition(
          opacity: _fadeIn,
          child: Transform.translate(
            offset: Offset(0, _slideUp.value),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.xl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _ErrorHeroCard(iconScale: _iconScale.value, context: context),
                  const SizedBox(height: AppSpacing.xl),
                  _buildMessageCard(context),
                  const SizedBox(height: AppSpacing.xl),
                  _buildHelpTips(context),
                  const SizedBox(height: AppSpacing.xl),
                  _buildRetryButton(context, l10n),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMessageCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.colors.error.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: context.colors.error.withValues(alpha: 0.18),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            FluentIcons.info_24_regular,
            color: context.colors.error,
            size: 20,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              widget.message,
              style: TextStyle(
                fontSize: AppFonts.bodyMedium,
                color: context.colors.error,
                height: 1.6,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpTips(BuildContext context) {
    final tips = [
      (Icons.wifi_off_rounded, 'تحقق من اتصالك بالإنترنت'),
      (FluentIcons.arrow_sync_24_regular, 'حاول مرة أخرى بعد لحظات'),
      (FluentIcons.headset_24_regular, 'تواصل مع الدعم إذا تكرّرت المشكلة'),
    ];
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: context.colors.border.withValues(alpha: 0.7),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.xs),
                decoration: BoxDecoration(
                  color: context.colors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(
                  FluentIcons.lightbulb_24_regular,
                  size: 16,
                  color: context.colors.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'نصائح للحل',
                style: TextStyle(
                  fontSize: AppFonts.bodyLarge,
                  fontWeight: FontWeight.bold,
                  color: context.colors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ...tips.map(
            (tip) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Row(
                children: [
                  Icon(tip.$1, size: 17, color: context.colors.textSecondary),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      tip.$2,
                      style: TextStyle(
                        fontSize: AppFonts.bodyMedium,
                        color: context.colors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRetryButton(BuildContext context, AppLocalizations l10n) {
    return SizedBox(
      height: 52,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          gradient: LinearGradient(
            colors: [
              context.colors.primary,
              context.colors.primary.withValues(alpha: 0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: context.colors.primary.withValues(alpha: 0.35),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.transparent,
            shadowColor: AppColors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
          ),
          onPressed: widget.onRetry,
          icon: const Icon(
            FluentIcons.arrow_sync_24_regular,
            color: AppColors.white,
            size: 20,
          ),
          label: Text(
            l10n.aiRendersRetry,
            style: const TextStyle(
              fontSize: AppFonts.bodyLarge,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _ErrorHeroCard extends StatelessWidget {
  final double iconScale;
  final BuildContext context;

  const _ErrorHeroCard({
    required this.iconScale,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xl,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            context.colors.error.withValues(alpha: 0.12),
            context.colors.error.withValues(alpha: 0.04),
          ],
        ),
        border: Border.all(
          color: context.colors.error.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Transform.scale(
            scale: iconScale,
            child: _AnimatedErrorOrb(context: context),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'تعذّر توليد التصميم',
            style: TextStyle(
              fontSize: AppFonts.headlineMedium,
              fontWeight: FontWeight.bold,
              color: context.colors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'حدث خطأ أثناء معالجة طلبك.\nيرجى المحاولة مجدداً.',
            style: TextStyle(
              fontSize: AppFonts.bodyMedium,
              color: context.colors.textSecondary,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _AnimatedErrorOrb extends StatefulWidget {
  final BuildContext context;
  const _AnimatedErrorOrb({required this.context});

  @override
  State<_AnimatedErrorOrb> createState() => _AnimatedErrorOrbState();
}

class _AnimatedErrorOrbState extends State<_AnimatedErrorOrb>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulse,
      builder: (context, _) {
        final pulse = _pulse.value;
        return Stack(
          alignment: Alignment.center,
          children: [
            // Outer glow ring
            Container(
              width: 96 + (pulse * 12),
              height: 96 + (pulse * 12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.colors.error.withValues(alpha: 0.06 * (1 - pulse)),
              ),
            ),
            // Mid ring
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.colors.error.withValues(alpha: 0.1),
                border: Border.all(
                  color: context.colors.error.withValues(alpha: 0.25),
                  width: 1.5,
                ),
              ),
            ),
            // Core icon
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.colors.error.withValues(alpha: 0.15),
              ),
              child: CustomPaint(
                painter: _RotatingArcPainter(
                  progress: pulse,
                  color: context.colors.error.withValues(alpha: 0.4),
                ),
                child: Center(
                  child: Icon(
                    FluentIcons.dismiss_circle_24_filled,
                    color: context.colors.error,
                    size: 32,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _RotatingArcPainter extends CustomPainter {
  final double progress;
  final Color color;

  const _RotatingArcPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: size.width - 4,
      height: size.height - 4,
    );

    canvas.drawArc(
      rect,
      -math.pi / 2 + (progress * math.pi * 2),
      math.pi * 0.6,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_RotatingArcPainter old) => old.progress != progress;
}
