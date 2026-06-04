import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_fonts.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../domain/entities/material_category.dart';
import '../../cubit/custom_finishing_cubit.dart';
import '../../cubit/custom_finishing_state.dart';
import 'review_selection_card.dart';
import 'cost_breakdown_card.dart';

class CustomFinishingReviewView extends StatelessWidget {
  const CustomFinishingReviewView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<CustomFinishingCubit, CustomFinishingState>(
      builder: (context, state) {
        return ListView(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.xl,
            horizontal: AppSpacing.md,
          ),
          children: [
            Text(
              l10n.selectionsSummary,
              style: const TextStyle(
                fontSize: AppFonts.headlineMedium,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Render selected materials
            ...state.selectedMaterials.values.map((material) {
              return ReviewSelectionCard(material: material);
            }),

            const SizedBox(height: AppSpacing.xl),

            // Note
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.gold.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(
                  color: AppColors.gold.withValues(alpha: 0.3),
                  width: 1,
                  style: BorderStyle
                      .solid, // In a real app we might use a dashed border package here, but solid is safe.
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.gold.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      FluentIcons.info_20_filled,
                      color: AppColors.gold,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      l10n.reviewNote,
                      style: TextStyle(
                        fontSize: AppFonts.bodyMedium,
                        color: AppColors.textPrimary.withValues(alpha: 0.8),
                        height: 1.6,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // Cost Breakdown
            CostBreakdownCard(state: state),

            const SizedBox(height: AppSpacing.xxl),

            // Actions
            Container(
              height: 60,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.gold, Color(0xFFE5B962)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppRadius.lg),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.gold.withValues(alpha: 0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  onTap: state.bookingStatus == BookingStatus.loading
                      ? null
                      : () {
                          context.read<CustomFinishingCubit>().confirmBooking();
                        },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: state.bookingStatus == BookingStatus.loading
                        ? const [
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: AppColors.white,
                                strokeWidth: 2,
                              ),
                            ),
                          ]
                        : [
                            Text(
                              'تأكيد واستخراج العقود',
                              style: const TextStyle(
                                fontSize: AppFonts.headlineSmall,
                                fontWeight: FontWeight.bold,
                                color: AppColors.white,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            const Icon(
                              FluentIcons.checkmark_24_filled,
                              color: AppColors.white,
                            ),
                          ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            OutlinedButton(
              onPressed: () {
                context.read<CustomFinishingCubit>().selectCategory(
                  MaterialCategory.floors,
                );
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 18),
                side: BorderSide(
                  color: AppColors.border.withValues(alpha: 0.8),
                  width: 1.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    FluentIcons.edit_20_regular,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    l10n.editSelectionsBtn,
                    style: const TextStyle(
                      fontSize: AppFonts.headlineMedium,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            Center(
              child: Text(
                l10n.termsAgreementText,
                style: TextStyle(
                  fontSize: AppFonts.labelSmall,
                  color: AppColors.textPrimary.withValues(alpha: 0.5),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
          ],
        );
      },
    );
  }
}
