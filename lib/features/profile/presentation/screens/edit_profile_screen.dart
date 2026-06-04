import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0.0,
        title: const Text(
          'تعديل البيانات الشخصية',
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
          children: [
            // Avatar
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.gold, width: 3),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/user_avatar_mock.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.white, width: 2),
                    ),
                    child: const Icon(FluentIcons.camera_24_regular, color: AppColors.white, size: 20),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxxl),

            // Form Fields
            const CustomTextField(
              label: 'الاسم بالكامل',
              hint: 'أحمد محمود العطار',
              icon: FluentIcons.person_24_regular,
            ),
            const SizedBox(height: AppSpacing.xl),
            
            const CustomTextField(
              label: 'البريد الإلكتروني',
              hint: 'ahmed.alattar@example.com',
              icon: FluentIcons.mail_24_regular,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: AppSpacing.xl),
            
            const CustomTextField(
              label: 'رقم الهاتف',
              hint: '+20 100 123 4567',
              icon: FluentIcons.phone_24_regular,
              keyboardType: TextInputType.phone,
            ),
            
            const SizedBox(height: AppSpacing.xxxl * 1.5),

            // Save Button
            CustomButton(
              text: 'حفظ التعديلات',
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
