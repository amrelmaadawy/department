import 'package:apartment/core/theme/app_colors.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import 'package:apartment/features/profile/domain/entities/profile_entity.dart';
import 'package:apartment/features/profile/domain/entities/unit_finishing_progress_entity.dart';
import 'package:apartment/features/profile/domain/usecases/calculate_finishing_progress_usecase.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

class ProfileFinishingProgressSection extends StatefulWidget {
  final ProfileEntity profile;

  const ProfileFinishingProgressSection({super.key, required this.profile});

  @override
  State<ProfileFinishingProgressSection> createState() => _ProfileFinishingProgressSectionState();
}

class _ProfileFinishingProgressSectionState extends State<ProfileFinishingProgressSection> {
  late List<UnitFinishingProgressEntity> _progressList;

  @override
  void initState() {
    super.initState();
    _calculateProgress();
  }

  @override
  void didUpdateWidget(covariant ProfileFinishingProgressSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.profile != widget.profile) {
      _calculateProgress();
    }
  }

  void _calculateProgress() {
    // Check if registered in GetIt (handles Hot Reload vs Hot Restart)
    final useCase = GetIt.I.isRegistered<CalculateFinishingProgressUseCase>()
        ? GetIt.I<CalculateFinishingProgressUseCase>()
        : CalculateFinishingProgressUseCase();
    _progressList = useCase.call(widget.profile);
  }

  @override
  Widget build(BuildContext context) {
    if (_progressList.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
          child: Row(
            children: [
              Icon(FluentIcons.data_bar_vertical_24_filled, color: context.colors.gold, size: 20),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'متابعة تشطيب الوحدات', // Should be in l10n ideally
                style: TextStyle(
                  color: context.colors.textPrimary,
                  fontSize: AppFonts.headlineSmall,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 105,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            scrollDirection: Axis.horizontal,
            itemCount: _progressList.length,
            separatorBuilder: (context, index) => const SizedBox(width: AppSpacing.md),
            itemBuilder: (context, index) {
              final progress = _progressList[index];
              return _UnitProgressCard(progress: progress);
            },
          ),
        ),
      ],
    );
  }
}

class _UnitProgressCard extends StatelessWidget {
  final UnitFinishingProgressEntity progress;

  const _UnitProgressCard({required this.progress});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/unit-progress', extra: progress.activeOrder);
      },
      child: Container(
        width: 260,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: context.colors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: context.colors.border.withValues(alpha: 0.5)),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Header: Unit Name & Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    progress.unit.title,
                    style: TextStyle(
                      color: context.colors.textPrimary,
                      fontSize: AppFonts.bodyMedium,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: context.colors.gold.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.round),
                  ),
                  child: Text(
                    progress.currentStage,
                    style: TextStyle(
                      color: context.colors.gold,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            
            // Financials or Actions
            if (progress.activeOrder != null && progress.totalCost > 0)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCostItem(context, 'المدفوع', progress.paidAmount, context.colors.primary),
                  _buildCostItem(context, 'المتبقي', progress.remainingAmount, context.colors.error),
                ],
              )
            else
              Text(
                'لا يوجد بيانات مالية مسجلة',
                style: TextStyle(
                  color: context.colors.textSecondary,
                  fontSize: AppFonts.labelSmall,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCostItem(BuildContext context, String label, double amount, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: context.colors.textSecondary,
            fontSize: 10,
          ),
        ),
        Text(
          '${amount.toStringAsFixed(0)} ج.م',
          style: TextStyle(
            color: color,
            fontSize: AppFonts.bodySmall,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
