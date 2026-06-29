import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import 'package:go_router/go_router.dart';

class AiCreditsDepletedDialog extends StatelessWidget {
  const AiCreditsDepletedDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: context.colors.background.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(AppRadius.xl),
                border: Border.all(
                  color: context.colors.error.withValues(alpha: 0.3),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Premium Icon Container
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: context.colors.error.withValues(alpha: 0.1),
                      border: Border.all(
                        color: context.colors.error.withValues(alpha: 0.3),
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.error_outline_rounded,
                      color: context.colors.error,
                      size: 48,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  
                  // Title
                  Text(
                    'نفذ رصيدك',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: AppFonts.headlineMedium,
                      fontWeight: FontWeight.bold,
                      color: context.colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  
                  // Message
                  Text(
                    'عذراً، رصيدك الحالي لا يكفي لإنشاء تصميم جديد. يرجى ترقية باقتك للوصول إلى المزيد من التصاميم المذهلة.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: AppFonts.bodyMedium,
                      color: context.colors.textSecondary,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  
                  // Action Button
                  SizedBox(
                    width: double.infinity,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        gradient: LinearGradient(
                          colors: [
                            context.colors.error,
                            context.colors.error.withValues(alpha: 0.8),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: context.colors.error.withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                        ),
                        onPressed: () {
                          // Placeholder action: close dialog
                          context.pop();
                        },
                        child: const Text(
                          'حسناً',
                          style: TextStyle(
                            fontSize: AppFonts.bodyLarge,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
