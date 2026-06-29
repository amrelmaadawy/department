import 'package:apartment/core/theme/app_colors.dart';
import 'package:apartment/features/projects/presentation/cubit/comparison_state.dart' as import_comparison;
import 'package:apartment/features/projects/presentation/widgets/details/unit_comparison_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apartment/l10n/app_localizations.dart';
import 'package:shimmer/shimmer.dart';

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
        body: BlocBuilder<ProjectDetailsCubit, ProjectDetailsState>(
          builder: (context, state) {
            ProjectEntity displayProject = widget.project;
            List<String> features = [];
            bool isLoading = state is ProjectDetailsLoading || state is ProjectDetailsInitial;

            if (state is ProjectDetailsLoaded) {
              displayProject = state.project;
              
              // Fallback for fields that might be missing in the details API but present in the list API
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
                    // 1. Hero Header
                    ProjectDetailsHeader(
                      project: displayProject,
                      heroTag: widget.heroTag,
                    ),

                    // 2. Title & Location
                    SliverToBoxAdapter(
                      child: ProjectInfoSection(project: displayProject),
                    ),

                    // Description Section
                    SliverToBoxAdapter(
                      child: ProjectDescriptionSection(project: displayProject),
                    ),

                    // 3. Features or Loading Indicator
                    SliverToBoxAdapter(
                      child: isLoading
                          ? _buildFeaturesShimmer(context)
                          : ProjectFeaturesRow(features: features),
                    ),

                    // 4. Units Section Title
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: AppSpacing.lg,
                          right: AppSpacing.lg,
                          top: AppSpacing.md,
                          bottom: AppSpacing.sm,
                        ),
                        child: Text(
                          l10n.tabUnits, // Or "الوحدات المتاحة"
                          style: TextStyle(
                            fontSize: AppFonts.headlineSmall,
                            fontWeight: FontWeight.bold,
                            color: context.colors.textPrimary,
                          ),
                        ),
                      ),
                    ),

                    // 5. Units Content (Filters & List)
                    SliverToBoxAdapter(
                      child: isLoading
                          ? _buildUnitsShimmer(context)
                          : ProjectUnitsTab(units: displayProject.units),
                    ),

                    // Bottom Padding
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 100), // Extra padding for comparison bar
                    ),
                  ],
                ),
                
                // Comparison Bar
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
