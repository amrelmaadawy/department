import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import '../../../../../core/theme/app_fonts.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/theme_extension.dart';
import '../../../../../l10n/app_localizations.dart';

class AiRendersPendingView extends StatefulWidget {
  final String statusLabel;

  const AiRendersPendingView({super.key, required this.statusLabel});

  @override
  State<AiRendersPendingView> createState() => _AiRendersPendingViewState();
}

class _AiRendersPendingViewState extends State<AiRendersPendingView> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  
  Timer? _statusTimer;
  Timer? _tipsTimer;

  int _currentStatusIndex = 0;
  int _currentTipIndex = 0;

  final List<String> _fakeStatuses = [
    'جاري تحليل أبعاد الغرفة ومصادر الإضاءة...',
    'يتم الآن مطابقة الخامات والألوان المختارة مع نمط التصميم...',
    'تطبيق النمط المعماري وتوزيع قطع الأثاث بذكاء...',
    'يتم محاكاة الإضاءة الطبيعية والصناعية لواقعية أكبر...',
    'ضبط زوايا الكاميرا للحصول على أفضل لقطة للغرفة...',
    'دراسة تباين الألوان بين الأرضيات والحوائط...',
    'إضافة اللمسات السحرية والإكسسوارات للتصميم...',
    'جاري معالجة الصورة بجودة فائقة (4K Render)...',
    'اللمسات النهائية قبل عرض النتيجة الساحرة...',
  ];

  final List<String> _designTips = [
    'نصيحة: الألوان الفاتحة في الحوائط والأسقف تعطي إحساساً باتساع المكان وتزيد من الإضاءة الطبيعية.',
    'معلومة: استخدام الإضاءة المخفية (البروفايل) في الأسقف يبرز جمال الخامات ويفصل بين المساحات بصرياً.',
    'نصيحة: المرايا الكبيرة ليست فقط للزينة، بل تضاعف كمية الإضاءة وتوهم بمساحة أكبر للغرفة.',
    'نصيحة: اختيار أرضيات خشبية داكنة مع حوائط فاتحة يعطي تبايناً فخماً ويبرز قطع الأثاث بوضوح.',
    'معلومة: تناسق ألوان الأثاث مع ألوان التشطيبات هو سر التصميم الداخلي الناجح والمريح للعين.',
    'نصيحة: النباتات الداخلية تضيف حياة وروحاً للمكان وتساعد في تنقية الهواء داخل الغرف.',
    'معلومة: الإضاءة الدافئة (Warm Light) مثالية لغرف النوم والمعيشة لأنها تعطي شعوراً بالاسترخاء والهدوء.',
    'نصيحة: استخدم السجاد لتحديد مساحات الجلوس في الغرف الكبيرة المفتوحة بدلاً من بناء حوائط.',
    'معلومة: توزيع الإضاءة على مستويات مختلفة (سقف، جدار، أرضية) يخلق عمقاً ودراما في التصميم.',
    'نصيحة: الأسقف العالية تمنحك فرصة ذهبية لاستخدام ثريات (نجف) كبيرة ومتدلية كقطعة فنية.',
  ];

  @override
  void initState() {
    super.initState();
    
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _statusTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        setState(() {
          _currentStatusIndex = (_currentStatusIndex + 1) % _fakeStatuses.length;
        });
      }
    });

    _tipsTimer = Timer.periodic(const Duration(seconds: 8), (timer) {
      if (mounted) {
        setState(() {
          _currentTipIndex = (_currentTipIndex + 1) % _designTips.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _statusTimer?.cancel();
    _tipsTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            
            // Pulsing AI Icon
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Container(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  decoration: BoxDecoration(
                    color: context.colors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: context.colors.primary.withValues(alpha: 0.2 * _pulseAnimation.value),
                        blurRadius: 40 * _pulseAnimation.value,
                        spreadRadius: 10 * _pulseAnimation.value,
                      ),
                    ],
                  ),
                  child: Icon(
                    FluentIcons.sparkle_24_filled,
                    size: 80,
                    color: context.colors.primary,
                  ),
                );
              },
            ),
            
            const SizedBox(height: AppSpacing.xxl),
            
            // Static Title
            Text(
              AppLocalizations.of(context)!.aiWorkingTitle,
              style: TextStyle(
                fontSize: AppFonts.headlineMedium,
                fontWeight: FontWeight.bold,
                color: context.colors.textPrimary,
              ),
            ),
            
            const SizedBox(height: AppSpacing.md),
            
            // Dynamic Status Subtitle
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (child, animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: Text(
                widget.statusLabel.isNotEmpty ? widget.statusLabel : _fakeStatuses[_currentStatusIndex],
                key: ValueKey<String>(widget.statusLabel.isNotEmpty ? widget.statusLabel : _fakeStatuses[_currentStatusIndex]),
                style: TextStyle(
                  fontSize: AppFonts.bodyLarge,
                  color: context.colors.textSecondary,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            
            const SizedBox(height: AppSpacing.xl),
            
            // Loading Indicator
            SizedBox(
              width: 48,
              height: 48,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: context.colors.primary,
                backgroundColor: context.colors.primary.withValues(alpha: 0.1),
                strokeCap: StrokeCap.round,
              ),
            ),
            
            const Spacer(),
            
            // Design Tips Carousel
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: context.colors.white,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: context.colors.gold.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(FluentIcons.lightbulb_24_filled, color: context.colors.gold, size: 20),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        'هل تعلم؟',
                        style: TextStyle(
                          fontSize: AppFonts.labelMedium,
                          fontWeight: FontWeight.bold,
                          color: context.colors.gold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 600),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0.0, 0.2),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: Text(
                      _designTips[_currentTipIndex],
                      key: ValueKey<int>(_currentTipIndex),
                      style: TextStyle(
                        fontSize: AppFonts.bodyMedium,
                        color: context.colors.textSecondary,
                        height: 1.6,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
