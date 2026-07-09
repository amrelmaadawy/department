import 'package:apartment/core/theme/app_colors.dart';
import 'package:apartment/features/projects/presentation/cubit/comparison_state.dart' as import_comparison;
import 'package:apartment/features/projects/presentation/widgets/details/unit_comparison_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apartment/l10n/app_localizations.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/network/cubit/network_cubit.dart';
import '../../../../core/network/cubit/network_state.dart';
import '../../../../core/widgets/error_state_view.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extension.dart';
import '../../../home/domain/entities/project_entity.dart';
import '../cubit/project_details_cubit.dart';
import '../cubit/comparison_cubit.dart' as import_comparison;
import '../widgets/details/project_features_row.dart';
import '../widgets/details/project_description_section.dart';
import '../widgets/details/project_details_header.dart';
import '../widgets/details/project_info_section.dart';
import '../widgets/details/project_units_tab.dart';

class ProjectDetailsScreen extends StatefulWidget {
  final ProjectEntity project;
  final String heroTag;

  const ProjectDetailsScreen({
    super.key,
    required this.project,
    required this.heroTag,
  });

  @override
  State<ProjectDetailsScreen> createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
  late ProjectDetailsCubit _cubit;
  late import_comparison.ComparisonCubit _comparisonCubit;

  @override
  void initState() {
    super.initState();
    _cubit = sl<ProjectDetailsCubit>()..loadProjectDetails(widget.project.id);
    _comparisonCubit = sl<import_comparison.ComparisonCubit>();
  }

  @override
  void dispose() {
    _cubit.close();
    _comparisonCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _cubit),
        BlocProvider.value(value: _comparisonCubit),
      ],
      child: Scaffold(
        backgroundColor: context.colors.background,
        body: BlocListener<NetworkCubit, NetworkState>(
          listener: (context, networkState) {
            if (networkState is NetworkOnline) {
              final s = _cubit.state;
              if (s is ProjectDetailsError || s is ProjectDetailsInitial) {
                _cubit.loadProjectDetails(widget.project.id, forceRefresh: true);
              }
            }
          },
          child: BlocBuilder<ProjectDetailsCubit, ProjectDetailsState>(
            builder: (context, state) {
              // ── Error State ────────────────────────────────────────────────
              if (state is ProjectDetailsError) {
                return Stack(
                  children: [
                    CustomScrollView(
                      slivers: [
                        ProjectDetailsHeader(
                          project: widget.project,
                          heroTag: widget.heroTag,
                        ),
                        SliverFillRemaining(
                          child: Center(
                            child: ErrorStateView(
                              message: state.message,
                              onRetry: () => _cubit.loadProjectDetails(widget.project.id, forceRefresh: true),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }

              ProjectEntity displayProject = widget.project;
              List<String> features = [];
              bool isLoading = state is ProjectDetailsLoading || state is ProjectDetailsInitial;

              if (state is ProjectDetailsLoaded) {
                displayProject = state.project;
                displayProject = displayProject.copyWith(
                  buildingArea: displayProject.buildingArea == 0 ? widget.project.buildingArea : displayProject.buildingArea,
                  apartmentsCount: displayProject.apartmentsCount == 0 ? widget.project.apartmentsCount : displayProject.apartmentsCount,
                  images: displayProject.images.isEmpty ? widget.project.images : displayProject.images,
                );
                features = state.features;
              }

              return Stack(
                children: [
                  CustomScrollView(
                    slivers: [
                      ProjectDetailsHeader(
                        project: displayProject,
                        heroTag: widget.heroTag,
                      ),
                      SliverToBoxAdapter(
                        child: ProjectInfoSection(project: displayProject),
                      ),
                      SliverToBoxAdapter(
                        child: ProjectDescriptionSection(project: displayProject),
                      ),
                      SliverToBoxAdapter(
                        child: isLoading
                            ? _buildFeaturesShimmer(context)
                            : ProjectFeaturesRow(features: features),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: AppSpacing.lg,
                            right: AppSpacing.lg,
                            top: AppSpacing.sm,
                            bottom: AppSpacing.xs,
                          ),
                          child: Text(
                            l10n.tabUnits,
                            style: TextStyle(
                              fontSize: AppFonts.headlineSmall,
                              fontWeight: FontWeight.bold,
                              color: context.colors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: isLoading
                            ? _buildUnitsShimmer(context)
                            : ProjectUnitsTab(units: displayProject.units),
                      ),
                      const SliverToBoxAdapter(
                        child: SizedBox(height: 100),
                      ),
                    ],
                  ),
                  BlocBuilder<import_comparison.ComparisonCubit, import_comparison.ComparisonState>(
                    builder: (context, compState) {
                      return AnimatedPositioned(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOutCubic,
                        bottom: compState.isComparisonMode ? 0 : -150,
                        left: 0,
                        right: 0,
                        child: UnitComparisonBar(selectedUnits: compState.selectedUnits),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturesShimmer(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? AppColors.grey800 : AppColors.grey300;
    final highlightColor = isDark ? AppColors.grey700 : AppColors.grey100;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.md,
        horizontal: AppSpacing.lg,
      ),
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(5, (index) {
            return Padding(
              padding: EdgeInsets.only(
                right: index == 0 ? 0 : AppSpacing.xl,
              ),
              child: SizedBox(
                width: 75,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 52, // 26 * 2 (radius)
                      height: 52,
                      decoration: const BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Container(
                      width: 50,
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildUnitsShimmer(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? AppColors.grey800 : AppColors.grey300;
    final highlightColor = isDark ? AppColors.grey700 : AppColors.grey100;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
          itemBuilder: (context, index) {
            return Container(
              height: 140, // Approximate height of a unit card
              margin: const EdgeInsets.only(bottom: AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
            );
          },
        ),
      ),
    );
  }
}
