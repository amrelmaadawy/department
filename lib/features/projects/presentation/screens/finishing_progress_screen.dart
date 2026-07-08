import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:apartment/core/di/injection_container.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/app_radius.dart';
import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import 'package:apartment/l10n/app_localizations.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

import '../cubit/finishing_progress_cubit.dart';
import '../cubit/finishing_progress_state.dart';
import '../../domain/entities/finishing_progress_stage_entity.dart';

class FinishingProgressScreen extends StatelessWidget {
  final int apartmentId;

  const FinishingProgressScreen({super.key, required this.apartmentId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<FinishingProgressCubit>()..loadFinishingProgress(apartmentId),
      child: const _FinishingProgressView(),
    );
  }
}

class _FinishingProgressView extends StatefulWidget {
  const _FinishingProgressView();

  @override
  State<_FinishingProgressView> createState() => _FinishingProgressViewState();
}

class _FinishingProgressViewState extends State<_FinishingProgressView> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: context.colors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          l10n.finishingProgress,
          style: TextStyle(
            color: context.colors.textPrimary,
            fontSize: AppFonts.headlineSmall,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(FluentIcons.ios_arrow_rtl_24_regular, color: context.colors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocBuilder<FinishingProgressCubit, FinishingProgressState>(
        builder: (context, state) {
          if (state is FinishingProgressLoading || state is FinishingProgressInitial) {
            return _buildShimmer(context);
          }

          if (state is FinishingProgressError) {
            return Center(
              child: Text(
                state.message,
                style: TextStyle(color: context.colors.error),
              ),
            );
          }

          if (state is FinishingProgressLoaded) {
            if (state.stages.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(FluentIcons.timeline_24_regular, size: 64, color: context.colors.textSecondary.withValues(alpha: 0.5)),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      l10n.noNotesYet,
                      style: TextStyle(fontSize: AppFonts.bodyLarge, color: context.colors.textSecondary),
                    ),
                  ],
                ),
              );
            }

            final allRoomsSet = <String>{};
            for (var stage in state.stages) {
              allRoomsSet.addAll(stage.rooms);
            }
            final roomsList = allRoomsSet.toList()..sort();
            
            // If no rooms exist in any stage, just show the timeline directly
            if (roomsList.isEmpty) {
              return _buildTimeline(state.stages, context);
            }

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final room = roomsList[index];
                        final roomStages = state.stages
                            .where((stage) => stage.rooms.contains(room))
                            .toList();
                        
                        double averageProgress = 0.0;
                        if (roomStages.isNotEmpty) {
                          averageProgress = roomStages.fold(
                              0.0, (sum, item) => sum + item.progressPercent) / roomStages.length;
                        }

                        return _RoomProgressCard(
                          roomName: room,
                          stages: roomStages,
                          progressPercent: averageProgress,
                        );
                      },
                      childCount: roomsList.length,
                    ),
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildTimeline(List<FinishingProgressStageEntity> stages, BuildContext context) {
    if (stages.isEmpty) {
      return Center(
        child: Text(
          'لا توجد مراحل هنا',
          style: TextStyle(color: context.colors.textSecondary),
        ),
      );
    }
    
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final stage = stages[index];
                final isLast = index == stages.length - 1;
                return _TimelineTile(
                  stage: stage,
                  isLast: isLast,
                );
              },
              childCount: stages.length,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildShimmer(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: context.colors.border.withValues(alpha: 0.3),
      highlightColor: context.colors.border.withValues(alpha: 0.1),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.md),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 12),
            decoration: BoxDecoration(
              color: context.colors.white,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: context.colors.border.withValues(alpha: 0.5)),
            ),
            child: Row(
              children: [
                // Icon placeholder
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 120,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 80,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                // Circular progress placeholder
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _RoomProgressCard extends StatelessWidget {
  final String roomName;
  final List<FinishingProgressStageEntity> stages;
  final double progressPercent;

  const _RoomProgressCard({
    required this.roomName,
    required this.stages,
    required this.progressPercent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: context.colors.border.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: context.colors.border.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 8),
          childrenPadding: const EdgeInsets.only(left: AppSpacing.sm, right: AppSpacing.sm, bottom: AppSpacing.md),
          shape: const RoundedRectangleBorder(side: BorderSide.none),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: context.colors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(FluentIcons.conference_room_24_regular, color: context.colors.primary),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      roomName,
                      style: TextStyle(
                        fontSize: AppFonts.bodyLarge,
                        fontWeight: FontWeight.bold,
                        color: context.colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${stages.length} مراحل',
                      style: TextStyle(
                        fontSize: AppFonts.bodySmall,
                        color: context.colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              // Circular progress
              SizedBox(
                width: 44,
                height: 44,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: progressPercent / 100,
                      strokeWidth: 3,
                      backgroundColor: context.colors.border,
                      color: progressPercent >= 100 ? context.colors.success : context.colors.primary,
                      strokeCap: StrokeCap.round,
                    ),
                    Text(
                      '${progressPercent.toInt()}%',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: progressPercent >= 100 ? context.colors.success : context.colors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          children: stages.map((stage) {
            final isLast = stages.last == stage;
            return _TimelineTile(stage: stage, isLast: isLast);
          }).toList(),
        ),
      ),
    );
  }
}

class _TimelineTile extends StatelessWidget {
  final FinishingProgressStageEntity stage;
  final bool isLast;

  const _TimelineTile({required this.stage, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = stage.status == 'completed';
    final bool isInProgress = stage.status == 'in_progress';
    
    Color statusColor;
    if (isCompleted) {
      statusColor = context.colors.success;
    } else if (isInProgress) {
      statusColor = context.colors.primary;
    } else {
      statusColor = context.colors.textSecondary.withValues(alpha: 0.5);
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Left side: Line and Indicator
          SizedBox(
            width: 40,
            child: Column(
              children: [
                // Indicator
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted ? statusColor : context.colors.background,
                    border: Border.all(
                      color: statusColor,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: isCompleted
                        ? Icon(FluentIcons.checkmark_16_regular, color: context.colors.white, size: 16)
                        : (isInProgress
                            ? SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                  value: stage.progressPercent / 100,
                                  strokeWidth: 2,
                                  color: statusColor,
                                ),
                              )
                            : Icon(FluentIcons.clock_16_regular, color: statusColor, size: 16)),
                  ),
                ),
                // Line
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: statusColor.withValues(alpha: 0.3),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          // Right side: Content Card
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: isInProgress ? context.colors.primary.withValues(alpha: 0.05) : context.colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(
                    color: isInProgress ? context.colors.primary.withValues(alpha: 0.3) : context.colors.border.withValues(alpha: 0.5),
                  ),
                  boxShadow: [
                    if (isInProgress)
                      BoxShadow(
                        color: context.colors.primary.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            stage.name,
                            style: TextStyle(
                              fontSize: AppFonts.bodyLarge,
                              fontWeight: FontWeight.bold,
                              color: context.colors.textPrimary,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(AppRadius.round),
                          ),
                          child: Text(
                            stage.statusLabel,
                            style: TextStyle(
                              fontSize: AppFonts.labelSmall,
                              fontWeight: FontWeight.bold,
                              color: statusColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (isInProgress) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(AppRadius.round),
                              child: LinearProgressIndicator(
                                value: stage.progressPercent / 100,
                                backgroundColor: context.colors.border,
                                color: statusColor,
                                minHeight: 6,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            '${stage.progressPercent}%',
                            style: TextStyle(
                              fontSize: AppFonts.labelSmall,
                              fontWeight: FontWeight.bold,
                              color: context.colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (stage.rooms.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.md),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: stage.rooms.map((room) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: context.colors.background,
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                            border: Border.all(color: context.colors.border),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(FluentIcons.building_16_regular, size: 14, color: context.colors.textSecondary),
                              const SizedBox(width: 4),
                              Text(
                                room,
                                style: TextStyle(
                                  fontSize: AppFonts.labelSmall,
                                  color: context.colors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        )).toList(),
                      ),
                    ],
                    if (stage.notes != null && stage.notes!.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.md),
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: context.colors.background,
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                          border: Border.all(color: context.colors.border.withValues(alpha: 0.5)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(FluentIcons.document_16_regular, size: 16, color: context.colors.textSecondary),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Text(
                                stage.notes!,
                                style: TextStyle(
                                  fontSize: AppFonts.bodySmall,
                                  color: context.colors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    if (stage.images.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.md),
                      SizedBox(
                        height: 80,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: stage.images.length,
                          separatorBuilder: (context, index) => const SizedBox(width: AppSpacing.sm),
                          itemBuilder: (context, index) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(AppRadius.sm),
                              child: CachedNetworkImage(
                                imageUrl: stage.images[index],
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  color: context.colors.border.withValues(alpha: 0.3),
                                  child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  color: context.colors.border.withValues(alpha: 0.3),
                                  child: Icon(FluentIcons.image_16_regular, color: context.colors.textSecondary),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
