import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apartment/l10n/app_localizations.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extension.dart';
import '../../../home/domain/entities/project_entity.dart';
import '../cubit/project_details_cubit.dart';
import '../widgets/details/project_amenities_row.dart';
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
            List<String> amenities = [];
            bool isLoading = state is ProjectDetailsLoading || state is ProjectDetailsInitial;

            if (state is ProjectDetailsLoaded) {
              displayProject = state.project;
              amenities = state.parsedAmenities;
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

                // 3. Amenities or Loading Indicator
                SliverToBoxAdapter(
                  child: isLoading
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(
                              color: context.colors.gold,
                            ),
                          ),
                        )
                      : ProjectAmenitiesRow(amenities: amenities),
                ),

                // 4. Units Section Title
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: AppSpacing.lg,
                      right: AppSpacing.lg,
                      top: AppSpacing.xl,
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
                  child: ProjectUnitsTab(units: displayProject.units),
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
}
