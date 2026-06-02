import 'package:apartment/features/auth/presentation/widgets/auth_tabs.dart';
import 'package:apartment/features/auth/presentation/widgets/phone_input_field.dart';
import 'package:apartment/features/auth/presentation/widgets/social_login_button.dart';
import 'package:apartment/l10n/app_localizations.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/custom_button.dart';
import '../cubit/auth_cubit.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthCubit>(),
      child: const AuthView(),
    );
  }
}

class AuthView extends StatelessWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: AppSpacing.xxl),
              
              // Logo
              Image.asset(
                'assets/images/auth_logo.png',
                height: AppSizes.logoMedium,
              ),
              
              const SizedBox(height: AppSpacing.lg),
              
              // Title
              Text(
                l10n.welcomeTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: AppFonts.displaySmall,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: AppSpacing.xs),
              
              // Subtitle
              Text(
                l10n.welcomeSubtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: AppFonts.bodyMedium,
                ),
              ),
              
              const SizedBox(height: AppSpacing.xxl),
              
              // Tabs
              const AuthTabs(),
              
              const SizedBox(height: AppSpacing.xxl),
              
              // Phone Input
              const PhoneInputField(),
              
              const SizedBox(height: AppSpacing.xl),
              
              // Next Button
              CustomButton(
                text: l10n.next,
                backgroundColor: AppColors.primary, // Using primary brand color instead of black
                textColor: AppColors.white,
                onPressed: () {
                  // TODO: Handle auth next
                },
              ),
              
              const SizedBox(height: AppSpacing.xxl),
              
              // Divider
              Row(
                children: [
                  const Expanded(child: Divider(color: AppColors.border)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    child: Text(
                      l10n.orVia,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: AppFonts.bodyMedium,
                      ),
                    ),
                  ),
                  const Expanded(child: Divider(color: AppColors.border)),
                ],
              ),
              
              const SizedBox(height: AppSpacing.xl),
              
              // Social Logins
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SocialLoginButton(
                    iconPath: 'assets/icons/google.svg',
                    onTap: () {},
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  SocialLoginButton(
                    iconPath: 'assets/icons/apple.svg',
                    onTap: () {},
                  ),
                ],
              ),
              
              const SizedBox(height: AppSpacing.xxl * 1.5),
              
              // Footer Terms
              Text.rich(
                TextSpan(
                  text: '${l10n.registerAgreement}\n',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: AppFonts.bodyMedium,
                    height: 1.5,
                  ),
                  children: [
                    TextSpan(
                      text: l10n.termsAndConditions,
                      style: const TextStyle(
                        color: AppColors.gold,
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()..onTap = () {},
                    ),
                    TextSpan(text: ' ${l10n.and} '),
                    TextSpan(
                      text: l10n.privacyPolicy,
                      style: const TextStyle(
                        color: AppColors.gold,
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()..onTap = () {},
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
