import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import 'widgets/booking_success_icon.dart';
import 'widgets/booking_order_details.dart';
import 'widgets/booking_success_actions.dart';

class BookingSuccessScreen extends StatefulWidget {
  final String orderId;

  const BookingSuccessScreen({super.key, required this.orderId});

  @override
  State<BookingSuccessScreen> createState() => _BookingSuccessScreenState();
}

class _BookingSuccessScreenState extends State<BookingSuccessScreen>
    with TickerProviderStateMixin {
  late AnimationController _animController;
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeIn),
      ),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _copyOrderId(BuildContext context) {
    Clipboard.setData(ClipboardData(text: widget.orderId));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم نسخ رقم الطلب بنجاح'),
        backgroundColor: AppColors.primary,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Elegant background glow effect
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.gold.withValues(alpha: 0.05),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.gold.withValues(alpha: 0.1),
                    blurRadius: 100,
                    spreadRadius: 50,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.03),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.05),
                    blurRadius: 80,
                    spreadRadius: 40,
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(flex: 2),

                  // Animated Success Icon with pulsing glow
                  BookingSuccessIcon(
                    scaleAnimation: _scaleAnimation,
                    pulseAnimation: _pulseAnimation,
                  ),

                  const Spacer(flex: 1),

                  // Text Content
                  FadeTransition(
                    opacity: _opacityAnimation,
                    child: Column(
                      children: [
                        Text(
                          l10n.bookingSuccessTitle,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: AppFonts.displaySmall,
                            fontWeight: FontWeight.w900,
                            color: AppColors.gold,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          l10n.bookingSuccessSubtitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: AppFonts.bodyLarge,
                            color: AppColors.textPrimary.withValues(alpha: 0.7),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xxl),

                  // Order Details Card
                  FadeTransition(
                    opacity: _opacityAnimation,
                    child: BookingOrderDetails(orderId: widget.orderId),
                  ),

                  const Spacer(flex: 2),

                  // Action Buttons
                  FadeTransition(
                    opacity: _opacityAnimation,
                    child: const BookingSuccessActions(),
                  ),

                  const SizedBox(height: AppSpacing.xxl),

                  // Watermark
                  FadeTransition(
                    opacity: _opacityAnimation,
                    child: Center(
                      child: Text(
                        l10n.finishItYourWay,
                        style: TextStyle(
                          fontSize: AppFonts.labelSmall,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary.withValues(alpha: 0.2),
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
