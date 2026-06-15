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

  @override
  void initState() {
    super.initState();
    _cubit = sl<ProjectDetailsCubit>()..loadProjectDetails(widget.project.id);
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider.value(
      value: _cubit,
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

            return CustomScrollView(
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
                SliverToBoxAdapter(
                  child: SizedBox(height: 40),
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
    final baseColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;
    final highlightColor = isDark ? Colors.grey[700]! : Colors.grey[100]!;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(
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
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(height: AppSpacing.sm),
                    Container(
                      width: 50,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.white,
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
    final baseColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;
    final highlightColor = isDark ? Colors.grey[700]! : Colors.grey[100]!;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
            );
          },
        ),
      ),
    );
  }
}
