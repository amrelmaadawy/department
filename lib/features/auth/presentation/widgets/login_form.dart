import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:apartment/l10n/app_localizations.dart';
import 'package:apartment/core/utils/input_sanitizer.dart';
import '../../../../core/theme/app_spacing.dart';
import 'custom_text_field.dart';

class LoginForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const LoginForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTextField(
            controller: widget.emailController,
            hintText: l10n.email,
            prefixIcon: FluentIcons.mail_24_regular,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (!InputSanitizer.isNotEmpty(value)) {
                return l10n.requiredField;
              }
              if (!InputSanitizer.isValidEmail(value!)) {
                return 'بريد إلكتروني غير صحيح';
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
              return null;
            },
          ),
        ],
      ),
    );
  }
}
