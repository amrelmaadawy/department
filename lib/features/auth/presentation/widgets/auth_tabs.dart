import 'package:apartment/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_spacing.dart';
import '../cubit/auth_cubit.dart';
import 'package:apartment/core/theme/theme_extension.dart';

class AuthTabs extends StatelessWidget {
  const AuthTabs({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return Row(
          children: [
            _buildTab(
              context,
              title: l10n.createAccount,
              isActive: !state.isLoginTab,
              onTap: () => context.read<AuthCubit>().toggleTab(false),
            ),
            _buildTab(
              context,
              title: l10n.login,
              isActive: state.isLoginTab,
              onTap: () => context.read<AuthCubit>().toggleTab(true),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTab(
    BuildContext context, {
    required String title,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                color: isActive ? context.colors.gold : context.colors.textSecondary,
                fontSize: AppFonts.bodyLarge,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Container(
              height: 2,
              color: isActive ? context.colors.gold : context.colors.border,
            ),
          ],
        ),
      ),
    );
  }
}
