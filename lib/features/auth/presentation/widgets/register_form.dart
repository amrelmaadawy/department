import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:apartment/l10n/app_localizations.dart';
import '../../../../core/theme/app_spacing.dart';
import 'custom_text_field.dart';

class RegisterForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  const RegisterForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.passwordController,
    required this.confirmPasswordController,
  });

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTextField(
            controller: widget.nameController,
            hintText: l10n.fullName,
            prefixIcon: FluentIcons.person_24_regular,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return l10n.requiredField;
              }
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.md),
          CustomTextField(
            controller: widget.emailController,
            hintText: l10n.email,
            prefixIcon: FluentIcons.mail_24_regular,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return l10n.requiredField;
              }
              if (!value.contains('@')) {
                return l10n.invalidEmail;
              }
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.md),
          CustomTextField(
            controller: widget.phoneController,
            hintText: l10n.mobileNumber,
            prefixIcon: FluentIcons.phone_24_regular,
            keyboardType: TextInputType.phone,
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.right, // Align text right for Arabic standard
            validator: (value) {
              if (value == null || value.isEmpty) {
                return l10n.requiredField;
              }
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.md),
          CustomTextField(
            controller: widget.passwordController,
            hintText: l10n.password,
            prefixIcon: FluentIcons.lock_closed_24_regular,
            isPassword: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return l10n.requiredField;
              }
              if (value.length < 6) {
                return l10n.passwordTooShort;
              }
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.md),
          CustomTextField(
            controller: widget.confirmPasswordController,
            hintText: l10n.confirmPassword,
            prefixIcon: FluentIcons.lock_closed_24_regular,
            isPassword: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return l10n.requiredField;
              }
              if (value != widget.passwordController.text) {
                return l10n.passwordsDoNotMatch;
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
