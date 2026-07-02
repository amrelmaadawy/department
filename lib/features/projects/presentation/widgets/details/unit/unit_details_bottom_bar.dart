import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/routes/app_router.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_fonts.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/theme_extension.dart';
import '../../../../../../core/widgets/custom_button.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../home/domain/entities/project_unit_entity.dart';
import '../../../cubit/unit_details_cubit.dart';

class UnitDetailsBottomBar extends StatelessWidget {
  final ProjectUnitEntity unit;

  const UnitDetailsBottomBar({super.key, required this.unit});

  void _showUnavailableDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: ctx.colors.background,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: AppColors.error, size: 48),
            const SizedBox(height: AppSpacing.md),
            const Text(
              'تم بيع هذه الوحدة، للأسف لم يعد بالإمكان إكمال هذه الرحلة',
              style: TextStyle(fontSize: AppFonts.bodyLarge, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            CustomButton(
              text: 'تصفح وحدات بديلة',
              onPressed: () {
                Navigator.pop(ctx);
                context.go(AppRouter.layout);
              },
            ),
            const SizedBox(height: AppSpacing.sm),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                context.push(AppRouter.support);
              },
              child: const Text('تواصل مع الدعم الفني', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (unit.status.isUnavailable && !unit.isCurrentUserUnit) {
      return const SizedBox.shrink();
    }

    final buttonText = unit.isCurrentUserUnit
        ? 'متابعة رحلة التشطيب وتوقيع العقود'
        : l10n.startFinishingJourney;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: CustomButton(
            text: buttonText,
            onPressed: () {
              final state = context.read<UnitDetailsCubit>().state;
              if (state is UnitDetailsError &&
                  (state.message.contains('صلاحية') || state.message.contains('بيعت') || state.message.contains('مرفوض'))) {
                _showUnavailableDialog(context);
                return;
              }

              context.push(AppRouter.finishingGuide, extra: {'unit': unit});
            },
          ),
        ),
      ),
    );
  }
}
