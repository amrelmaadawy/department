import 'package:apartment/features/auth/presentation/widgets/auth_tabs.dart';
import 'package:apartment/features/auth/presentation/widgets/login_form.dart';
import 'package:apartment/features/auth/presentation/widgets/register_form.dart';
import 'package:apartment/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../../core/widgets/custom_button.dart';
import '../cubit/auth_cubit.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import 'package:apartment/core/utils/responsive_builder.dart';

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

class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  final _loginFormKey = GlobalKey<FormState>();
  final _registerFormKey = GlobalKey<FormState>();
  
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  final _regNameController = TextEditingController();
  final _regEmailController = TextEditingController();
  final _regPhoneController = TextEditingController();
  final _regPasswordController = TextEditingController();
  final _regConfirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _regNameController.dispose();
    _regEmailController.dispose();
    _regPhoneController.dispose();
    _regPasswordController.dispose();
    _regConfirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: context.colors.white,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: context.isDesktop ? 500 : (context.isTablet ? 450 : double.infinity)),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: AppSpacing.xxl),

              // Logo
              Image.asset(
                'assets/images/الشعارات-02.png',
                height: AppSizes.logoMedium,
              ),

              const SizedBox(height: AppSpacing.lg),

              // Title
              Text(
                l10n.welcomeTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: context.colors.textPrimary,
                  fontSize: AppFonts.displaySmall,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: AppSpacing.xs),

              // Subtitle
              Text(
                l10n.welcomeSubtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: context.colors.textSecondary,
                  fontSize: AppFonts.bodyMedium,
                ),
              ),

              const SizedBox(height: AppSpacing.xxl),

              // Tabs
              const AuthTabs(),

              const SizedBox(height: AppSpacing.xxl),

              // Forms
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: state.isLoginTab
                        ? LoginForm(
                            key: const ValueKey('login'),
                            formKey: _loginFormKey,
                            emailController: _emailController,
                            passwordController: _passwordController,
                          )
                        : RegisterForm(
                            key: const ValueKey('register'),
                            formKey: _registerFormKey,
                            nameController: _regNameController,
                            emailController: _regEmailController,
                            phoneController: _regPhoneController,
                            passwordController: _regPasswordController,
                            confirmPasswordController: _regConfirmPasswordController,
                          ),
                  );
                },
              ),

              const SizedBox(height: AppSpacing.xl),

              // Action Button
              BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state.status == AuthStatus.failure) {
                    AppToast.show(
                      context,
                      message: state.errorMessage ?? l10n.bookingError,
                      isError: true,
                    );
                  } else if (state.status == AuthStatus.success) {
                    if (state.successMessage != null) {
                      AppToast.show(
                        context,
                        message: state.successMessage!,
                        isError: false,
                      );
                      // Switch to login tab after successful registration
                      context.read<AuthCubit>().toggleTab(true);
                    } else {
                      AppRouter.setAuthenticated();
                      context.go(AppRouter.layout);
                    }
                  }
                },
                builder: (context, state) {
                  return CustomButton(
                    text: state.status == AuthStatus.loading 
                        ? '...' // Or you can keep text and add isLoading inside CustomButton if supported
                        : (state.isLoginTab ? l10n.login : l10n.createAccount),
                    backgroundColor: Theme.of(context).brightness == Brightness.dark 
                        ? context.colors.gold 
                        : context.colors.primary,
                    textColor: context.colors.white,
                    onPressed: state.status == AuthStatus.loading 
                        ? null 
                        : () {
                      bool isValid = false;
                      if (state.isLoginTab) {
                        isValid = _loginFormKey.currentState?.validate() ?? false;
                      } else {
                        isValid = _registerFormKey.currentState?.validate() ?? false;
                      }
                      
                      if (isValid) {
                        if (!state.isLoginTab) {
                          context.read<AuthCubit>().register(
                            name: _regNameController.text.trim(),
                            email: _regEmailController.text.trim(),
                            phone: _regPhoneController.text.trim(),
                            password: _regPasswordController.text,
                            passwordConfirmation: _regConfirmPasswordController.text,
                          );
                        } else {
                          context.read<AuthCubit>().login(
                            email: _emailController.text.trim(),
                            password: _passwordController.text,
                          );
                        }
                      }
                    },
                  );
                },
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
