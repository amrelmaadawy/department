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
import 'package:apartment/core/widgets/full_screen_gallery.dart';

import '../cubit/finishing_progress_cubit.dart';
import '../cubit/finishing_progress_state.dart';
import '../../domain/entities/finishing_progress_stage_entity.dart';

class FinishingProgressScreen extends StatelessWidget {
  final int apartmentId;
  final String projectName;
  final String unitName;

  const FinishingProgressScreen({
    super.key,
    required this.apartmentId,
    required this.projectName,
    required this.unitName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<FinishingProgressCubit>()..loadFinishingProgress(apartmentId),
      child: _FinishingProgressView(
        projectName: projectName,
        unitName: unitName,
      ),
    );
  }
}

class _FinishingProgressView extends StatefulWidget {
  final String projectName;
  final String unitName;

  const _FinishingProgressView({
    required this.projectName,
    required this.unitName,
  });

  @override
  State<_FinishingProgressView> createState() => _FinishingProgressViewState();
}

class _FinishingProgressViewState extends State<_FinishingProgressView> {
  /// Groups stages by room and returns a flat list of [Widget]s:
  /// a styled header for each room, followed by its timeline tiles.
  List<Widget> _buildGroupedStages(
    BuildContext context,
    List<FinishingProgressStageEntity> stages,
  ) {
    // Maintain insertion order: room → stages
    final grouped = <String, List<FinishingProgressStageEntity>>{};
    for (final stage in stages) {
      final room = stage.rooms.isNotEmpty ? stage.rooms.first : 'أعمال عامة';
      grouped.putIfAbsent(room, () => []).add(stage);
    }

    final widgets = <Widget>[];
    grouped.forEach((room, roomStages) {
      // Room header
      widgets.add(_RoomSectionHeader(roomName: room));
      // Timeline tiles for this room
      for (int i = 0; i < roomStages.length; i++) {
        widgets.add(_TimelineTile(
          stage: roomStages[i],
          isFirst: i == 0,
          isLast: i == roomStages.length - 1,
        ));
      }
      // Small gap between groups
      widgets.add(const SizedBox(height: AppSpacing.md));
    });
    return widgets;
  }

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
          l10n.finishingProgress, // "متابعة التنفيذ"
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
            return const _ShimmerLoading();
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
            return Stack(
              children: [
                CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Project & Unit Names
                            if (widget.projectName.isNotEmpty)
                              Text(
                                widget.projectName,
                                style: TextStyle(
                                  color: context.colors.textPrimary,
                                  fontSize: AppFonts.headlineMedium,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            if (widget.unitName.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                widget.unitName,
                                style: TextStyle(
                                  color: context.colors.textSecondary,
                                  fontSize: AppFonts.bodyMedium,
                                ),
                              ),
                            ],

                            const SizedBox(height: AppSpacing.xl),

                            // Progress Percentage and Label
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${state.totalProgress}%',
                                  style: TextStyle(
                                    color: context.colors.textPrimary,
                                    fontSize: AppFonts.displaySmall,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  l10n.completionPercentage, // "نسبة الإنجاز"
                                  style: TextStyle(
                                    color: context.colors.textSecondary,
                                    fontSize: AppFonts.bodyMedium,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            // Horizontal Progress Bar
                            ClipRRect(
                              borderRadius: BorderRadius.circular(AppRadius.round),
                              child: LinearProgressIndicator(
                                value: state.totalProgress / 100,
                                backgroundColor: context.colors.border.withValues(alpha: 0.3),
                                color: const Color(0xFFC49A45), // Gold color from screenshot
                                minHeight: 12,
                              ),
                            ),

                            const SizedBox(height: AppSpacing.xl),

                            // Stages Title
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                l10n.executionStages, // "مراحل التنفيذ"
                                style: TextStyle(
                                  color: context.colors.textPrimary,
                                  fontSize: AppFonts.headlineSmall,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.md),
                          ],
                        ),
                      ),
                    ),
                    
                    if (state.stages.isEmpty)
                      SliverToBoxAdapter(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: AppSpacing.xxl),
                            child: Text(
                              'لا توجد مراحل هنا',
                              style: TextStyle(color: context.colors.textSecondary),
                            ),
                          ),
                        ),
                      )
                    else
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate(
                            _buildGroupedStages(context, state.stages),
                          ),
                        ),
                      ),
                      
                    // Add padding at the bottom for the fixed button
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 100),
                    ),
                  ],
                ),

                // Bottom Button: "عرض صور الموقع"
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          context.colors.background,
                          context.colors.background.withValues(alpha: 0.8),
                          context.colors.background.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                    padding: EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, MediaQuery.paddingOf(context).bottom + AppSpacing.md),
                    child: ElevatedButton(
                      onPressed: () => _showSitePhotos(context, state.stages),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.colors.textPrimary, // Dark black color
                        foregroundColor: context.colors.background, // White text/icon
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            l10n.viewSitePhotos, // "عرض صور الموقع"
                            style: TextStyle(
                              fontSize: AppFonts.bodyLarge,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          const Icon(FluentIcons.arrow_reply_20_filled, size: 20), // Standard icon that exists in fluent_ui
                        ],
                      ),
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

  void _showSitePhotos(BuildContext context, List<FinishingProgressStageEntity> stages) {
    // Filter stages that actually have images
    final stagesWithImages = stages.where((s) => s.images.isNotEmpty).toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (_, controller) {
            return Container(
              decoration: BoxDecoration(
                color: context.colors.background,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: context.colors.border,
                      borderRadius: BorderRadius.circular(AppRadius.round),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    l10n.viewSitePhotos,
                    style: TextStyle(
                      color: context.colors.textPrimary,
                      fontSize: AppFonts.headlineSmall,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Expanded(
                    child: stagesWithImages.isEmpty
                        ? Center(
                            child: Text(
                              'لا توجد صور للموقع حالياً',
                              style: TextStyle(color: context.colors.textSecondary, fontSize: AppFonts.bodyLarge),
                            ),
                          )
                        : ListView.builder(
                            controller: controller,
                            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
                            itemCount: stagesWithImages.length,
                            itemBuilder: (context, index) {
                              final stage = stagesWithImages[index];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: AppSpacing.sm, top: AppSpacing.md),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          stage.name,
                                          style: TextStyle(
                                            color: context.colors.textPrimary,
                                            fontSize: AppFonts.bodyLarge,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        if (stage.rooms.isNotEmpty)
                                          Expanded(
                                            child: Text(
                                              stage.rooms.join('، '),
                                              style: TextStyle(
                                                color: context.colors.textSecondary,
                                                fontSize: AppFonts.bodySmall,
                                              ),
                                              textAlign: TextAlign.end,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  GridView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: AppSpacing.sm,
                                      mainAxisSpacing: AppSpacing.sm,
                                    ),
                                    itemCount: stage.images.length,
                                    itemBuilder: (context, imgIndex) {
                                      return GestureDetector(
                                        onTap: () {
                                          FullScreenGallery.show(
                                            context,
                                            images: stage.images,
                                            initialIndex: imgIndex,
                                            heroTagPrefix: 'site_photo_${stage.id}',
                                          );
                                        },
                                        child: Hero(
                                          tag: imgIndex == 0 
                                              ? 'site_photo_${stage.id}' 
                                              : 'site_photo_${stage.id}_$imgIndex',
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(AppRadius.md),
                                            child: CachedNetworkImage(
                                              imageUrl: stage.images[imgIndex],
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) => Shimmer.fromColors(
                                                baseColor: context.colors.border.withValues(alpha: 0.3),
                                                highlightColor: context.colors.border.withValues(alpha: 0.1),
                                                child: Container(color: Colors.white),
                                              ),
                                              errorWidget: (context, url, error) => Container(
                                                color: context.colors.border.withValues(alpha: 0.3),
                                                child: Icon(FluentIcons.image_16_regular, color: context.colors.textSecondary),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

/// Styled room section header shown above each group of stages.
class _RoomSectionHeader extends StatelessWidget {
  final String roomName;
  const _RoomSectionHeader({required this.roomName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xs, bottom: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: context.colors.border.withValues(alpha: 0.5),
              thickness: 1,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: context.colors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(AppRadius.round),
              border: Border.all(
                color: context.colors.primary.withValues(alpha: 0.25),
              ),
            ),
            child: Text(
              roomName,
              style: TextStyle(
                fontSize: AppFonts.bodySmall,
                fontWeight: FontWeight.bold,
                color: context.colors.primary,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Divider(
              color: context.colors.border.withValues(alpha: 0.5),
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineTile extends StatelessWidget {
  final FinishingProgressStageEntity stage;
  final bool isLast;
  final bool isFirst;

  const _TimelineTile({
    required this.stage,
    required this.isLast,
    required this.isFirst,
  });

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = stage.status == 'completed';
    final bool isInProgress = stage.status == 'in_progress';
    final bool isCancelled = stage.status == 'cancelled';
    final bool isPending = !isCompleted && !isInProgress && !isCancelled;

    // Define colors based on status
    const Color completedColor = Color(0xFF1F8B50);   // Green
    final Color inProgressColor = context.colors.textPrimary; // Black/Dark
    final Color cancelledColor = context.colors.textSecondary; // Muted grey instead of red
    final Color pendingColor = context.colors.textSecondary.withValues(alpha: 0.4); // Light Grey

    Color statusColor;
    if (isCompleted) {
      statusColor = completedColor;
    } else if (isInProgress) {
      statusColor = inProgressColor;
    } else if (isCancelled) {
      statusColor = cancelledColor;
    } else {
      statusColor = pendingColor;
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // RIGHT side (first in code = right in RTL): Timeline Indicator
          SizedBox(
            width: 32,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Connecting line (above & below circle)
                Column(
                  children: [
                    Expanded(
                      child: Container(
                        width: 2,
                        color: isFirst 
                            ? Colors.transparent 
                            : ((isCompleted || isInProgress) ? completedColor : pendingColor),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: 2,
                        color: isLast
                            ? Colors.transparent
                            : (isCompleted ? completedColor : pendingColor),
                      ),
                    ),
                  ],
                ),

                // Circle Indicator
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCancelled
                        ? cancelledColor.withValues(alpha: 0.1)
                        : context.colors.background,
                    border: Border.all(color: statusColor, width: 2),
                  ),
                  child: Center(
                    child: isCompleted
                        ? Icon(FluentIcons.checkmark_16_regular, color: completedColor, size: 14)
                        : isCancelled
                            ? Icon(FluentIcons.dismiss_16_regular, color: cancelledColor, size: 12)
                            : isInProgress
                                ? Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: inProgressColor,
                                      shape: BoxShape.circle,
                                    ),
                                  )
                                : Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: pendingColor,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: AppSpacing.md),

          // CENTER: Stage Name + per-stage progress bar
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    stage.name,
                    style: TextStyle(
                      fontSize: AppFonts.bodyLarge,
                      fontWeight: FontWeight.bold,
                      color: isCancelled
                          ? cancelledColor.withValues(alpha: 0.7)
                          : (isPending
                              ? context.colors.textSecondary
                              : context.colors.textPrimary),
                      decoration: isCancelled ? TextDecoration.lineThrough : null,
                      decorationColor: cancelledColor,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        '${stage.progressPercent}%',
                        style: TextStyle(
                          fontSize: AppFonts.labelSmall,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(AppRadius.round),
                          child: LinearProgressIndicator(
                            value: (stage.progressPercent / 100).clamp(0.0, 1.0),
                            backgroundColor:
                                context.colors.border.withValues(alpha: 0.3),
                            color: isCancelled
                                ? cancelledColor
                                : (isCompleted
                                    ? completedColor
                                    : (isInProgress
                                        ? const Color(0xFFC49A45)
                                        : pendingColor)),
                            minHeight: 5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: AppSpacing.md),

          // LEFT side (last in code = left in RTL): Status Label
          SizedBox(
            width: 72,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                stage.statusLabel,
                style: TextStyle(
                  fontSize: AppFonts.bodySmall,
                  fontWeight: isPending ? FontWeight.normal : FontWeight.bold,
                  color: statusColor,
                ),
                textAlign: TextAlign.start,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ));
  }
}


class _ShimmerLoading extends StatelessWidget {
  const _ShimmerLoading();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: context.colors.border.withValues(alpha: 0.3),
      highlightColor: context.colors.border.withValues(alpha: 0.1),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xl),
        itemCount: 6,
        itemBuilder: (context, index) {
          if (index == 0) {
             return Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Container(width: 200, height: 24, color: Colors.white),
                 const SizedBox(height: 8),
                 Container(width: 150, height: 16, color: Colors.white),
                 const SizedBox(height: 32),
                 Container(width: double.infinity, height: 12, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10))),
                 const SizedBox(height: 32),
                 Container(width: 100, height: 20, color: Colors.white),
                 const SizedBox(height: 16),
               ],
             );
          }
          return Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Row(
              children: [
                Container(width: 60, height: 16, color: Colors.white),
                const SizedBox(width: 16),
                Expanded(child: Container(height: 20, color: Colors.white)),
                const SizedBox(width: 16),
                Container(width: 24, height: 24, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
              ],
            ),
          );
        },
      ),
    );
  }
}
