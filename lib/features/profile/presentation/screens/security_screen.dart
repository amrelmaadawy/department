import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  bool _isBiometricEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0.0,
        title: const Text(
          'الأمان وكلمة المرور',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: AppFonts.headlineSmall,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(FluentIcons.ios_arrow_rtl_24_regular, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'تغيير كلمة المرور',
              style: TextStyle(
                fontSize: AppFonts.bodyLarge,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            
            const CustomTextField(
              label: 'كلمة المرور الحالية',
              hint: '••••••••',
              icon: FluentIcons.password_24_regular,
              isPassword: true,
            ),
            const SizedBox(height: AppSpacing.xl),
            
            const CustomTextField(
              label: 'كلمة المرور الجديدة',
              hint: '••••••••',
              icon: FluentIcons.key_24_regular,
              isPassword: true,
            ),
            const SizedBox(height: AppSpacing.xl),
            
            const CustomTextField(
              label: 'تأكيد كلمة المرور الجديدة',
              hint: '••••••••',
              icon: FluentIcons.key_24_regular,
              isPassword: true,
            ),
            
            const SizedBox(height: AppSpacing.xxxl),
            const Divider(color: AppColors.border),
            const SizedBox(height: AppSpacing.xxxl),

            // Biometric Toggle
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadius.xl),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: AppColors.gold.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: const Icon(FluentIcons.fingerprint_24_regular, color: AppColors.gold),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'تسجيل الدخول بالبصمة',
                          style: TextStyle(
                            fontSize: AppFonts.bodyLarge,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: AppSpacing.xs),
                        Text(
                          'استخدم بصمة الإصبع أو الوجه لتسجيل الدخول السريع',
                          style: TextStyle(
                            fontSize: AppFonts.bodySmall,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch.adaptive(
                    value: _isBiometricEnabled,
                    activeColor: AppColors.success,
                    onChanged: (value) {
                      setState(() {
                        _isBiometricEnabled = value;
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xxxl * 1.5),

            // Save Button
            CustomButton(
              text: 'تحديث البيانات',
              onPressed: () {
                context.pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
