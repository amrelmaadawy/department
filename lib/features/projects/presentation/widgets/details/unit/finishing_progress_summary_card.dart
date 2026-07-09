import 'package:apartment/core/routes/app_router.dart';
import 'package:apartment/features/home/domain/entities/project_unit_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import 'package:apartment/l10n/app_localizations.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import '../../../cubit/finishing_progress_cubit.dart';
import '../../../cubit/finishing_progress_state.dart';
import 'package:shimmer/shimmer.dart';

class FinishingProgressSummaryCard extends StatelessWidget {
  final ProjectUnitEntity unit;

  const FinishingProgressSummaryCard({super.key, required this.unit});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FinishingProgressCubit, FinishingProgressState>(
      builder: (context, state) {
        if (state is FinishingProgressLoading || state is FinishingProgressInitial) {
          return const _ShimmerCard();
        }

        if (state is FinishingProgressError) {
          return const SizedBox.shrink(); // Don't show if error
        }

        if (state is FinishingProgressLoaded) {
          if (state.stages.isEmpty) return const SizedBox.shrink();

          final l10n = AppLocalizations.of(context)!;
          
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: InkWell(
              onTap: () {
                final apartmentId = int.tryParse(unit.id) ?? 0;
                if (apartmentId <= 0) return;
                context.push(
                  AppRouter.finishingProgress(apartmentId),
                  extra: {
                    'projectName': unit.projectName,
                    'unitName': unit.title,
                  },
                );
              },
              borderRadius: BorderRadius.circular(AppRadius.lg),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: context.colors.primary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(color: context.colors.primary.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator(
                            value: state.totalProgress / 100,
                            strokeWidth: 4,
                            backgroundColor: context.colors.border,
                            color: context.colors.primary,
                            strokeCap: StrokeCap.round,
                          ),
                        ),
                        Text(
                          '${state.totalProgress}%',
                          style: TextStyle(
                            fontSize: AppFonts.labelSmall,
                            fontWeight: FontWeight.bold,
                            color: context.colors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.finishingProgressSummary,
                            style: TextStyle(
                              fontSize: AppFonts.bodyMedium,
                              fontWeight: FontWeight.bold,
                              color: context.colors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${l10n.activeStage}: ${state.activeStageName}',
                            style: TextStyle(
                              fontSize: AppFonts.bodySmall,
                              color: context.colors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      FluentIcons.ios_arrow_rtl_24_regular,
                      color: context.colors.primary,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class _ShimmerCard extends StatelessWidget {
  const _ShimmerCard();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Shimmer.fromColors(
        baseColor: context.colors.border.withValues(alpha: 0.4),
        highlightColor: context.colors.white.withValues(alpha: 0.5),
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            color: context.colors.white,
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
        ),
      ),
    );
  }
}
