import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/core/widgets/custom_button.dart';
import 'package:apartment/core/routes/app_router.dart';
import 'package:apartment/l10n/app_localizations.dart';
import 'package:apartment/features/home/domain/entities/project_unit_entity.dart';
import 'package:go_router/go_router.dart';
import 'package:apartment/core/di/injection_container.dart';
import 'package:apartment/features/design_studio/presentation/cubit/design_context_cubit.dart';
import 'package:apartment/core/theme/theme_extension.dart';


class UnitBottomActions extends StatelessWidget {
  final ProjectUnitEntity unit;

  const UnitBottomActions({super.key, required this.unit});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final formatter = NumberFormat.currency(symbol: '', decimalDigits: 0);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: context.colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.priceTitle,
                  style: TextStyle(
                    fontSize: AppFonts.labelMedium,
                    color: context.colors.textSecondary,
                  ),
                ),
                Text(
                  '${formatter.format(unit.price).trim()} ${l10n.sar}',
                  style: TextStyle(
                    fontSize: AppFonts.headlineSmall,
                    fontWeight: FontWeight.bold,
                    color: context.colors.textPrimary,
                  ),
                ),
              ],
            ),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: CustomButton(
                text: l10n.designAndBookUnit,
                onPressed: () {
                  sl<DesignContextCubit>().selectUnit(unit);
                  context.push(AppRouter.customFinishing);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
