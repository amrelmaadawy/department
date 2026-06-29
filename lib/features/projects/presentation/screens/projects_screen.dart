import 'dart:async';
import 'package:apartment/core/constants/app_constants.dart';
import 'package:apartment/features/projects/presentation/widgets/custom_search_bar.dart';
import 'package:apartment/features/projects/presentation/widgets/filter_chips_row.dart';
import 'package:apartment/features/projects/presentation/widgets/project_list_card.dart';
import 'package:apartment/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/network/cubit/network_cubit.dart';
import '../../../../core/network/cubit/network_state.dart';
import '../cubit/projects_cubit.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import '../../../../core/widgets/error_state_view.dart';


class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProjectsCubit>()..loadProjects(),
      child: const ProjectsView(),
    );
  }
}

class ProjectsView extends StatefulWidget {
  const ProjectsView({super.key});

  @override
  State<ProjectsView> createState() => _ProjectsViewState();
}

class _ProjectsViewState extends State<ProjectsView> {
  Timer? _debounce;

  void _onSearchChanged(BuildContext context, String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<ProjectsCubit>().searchProjects(query);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: BlocBuilder<ProjectsCubit, ProjectsState>(
          builder: (context, state) {
            return CustomScrollView(
              slivers: [
                // Title
                SliverPadding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  sliver: SliverToBoxAdapter(
                    child: Center(
                      child: Text(
                        l10n.navProjects,
                        style: TextStyle(
                          fontSize: AppFonts.headlineSmall,
                          fontWeight: FontWeight.bold,
                          color: context.colors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                ),

                // Cached Data Warning Banner
                BlocBuilder<NetworkCubit, NetworkState>(
                  builder: (context, networkState) {
                    if (networkState is NetworkOffline && state is ProjectsLoaded) {
                      return SliverToBoxAdapter(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: AppSpacing.lg),
                          color: Colors.amber.withValues(alpha: 0.1),
                          child: Row(
                            children: [
                              Icon(Icons.wifi_off_rounded, size: 16, color: Colors.amber[700]),
                              const SizedBox(width: AppSpacing.sm),
                              Expanded(
                                child: Text(
                                  l10n.offlineCacheWarning,
                                  style: TextStyle(fontSize: 12, color: Colors.amber[800], fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return const SliverToBoxAdapter(child: SizedBox.shrink());
                  },
                ),

                // Sticky Header: Search + Filters
                SliverPersistentHeader(
                  pinned: true,
                  floating: true,
                  delegate: _StickyHeaderDelegate(
                    child: Container(
                      color: context.colors.background,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg,
                            ),
                            child: CustomSearchBar(
                              hintText: l10n.searchProject,
                              onChanged: (query) =>
                                  _onSearchChanged(context, query),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          if (state is ProjectsLoaded)
                            Builder(
                              builder: (context) {
                                final dynamicFilters = [
                                  {'key': AppConstants.filterAll, 'label': l10n.filterAll},
                                  ...state.availableCities.map((city) => {'key': city, 'label': city}),
                                ];
                                
                                return FilterChipsRow(
                                  filters: dynamicFilters.map((e) => e['label'] as String).toList(),
                                  selectedFilter: dynamicFilters.firstWhere((e) => e['key'] == state.selectedFilter, orElse: () => dynamicFilters.first)['label'] as String,
                                  onFilterSelected: (label) {
                                    final key = dynamicFilters.firstWhere(
                                      (e) => e['label'] == label,
                                      orElse: () => dynamicFilters.first,
                                    )['key'] as String;
                                    context.read<ProjectsCubit>().filterByCity(key);
                                  },
                                );
                              }
                            ),
                          const SizedBox(height: AppSpacing.sm),
                        ],
                      ),
                    ),
                  ),
                ),

                // Content
                if (state is ProjectsLoading || state is ProjectsInitial)
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _buildShimmerCard(),
                      childCount: 5,
                    ),
                  )
                else if (state is ProjectsLoaded)
                  state.filteredProjects.isEmpty
                      ? SliverFillRemaining(
                          child: Center(
                            child: Text(
                              l10n.noProjectsFound,
                              style: TextStyle(
                                color: context.colors.textSecondary,
                                fontSize: AppFonts.bodyLarge,
                              ),
                            ),
                          ),
                        )
                      : SliverList(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            return ProjectListCard(
                              project: state.filteredProjects[index],
                            );
                          }, childCount: state.filteredProjects.length),
                        )
                else if (state is ProjectsError)
                  SliverFillRemaining(
                    child: Center(
                      child: ErrorStateView(
                        message: state.message,
                        onRetry: () => context.read<ProjectsCubit>().loadProjects(),
                      ),
                    ),
                  ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: 100),
                ), // Bottom padding
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildShimmerCard() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;
        final double cardHeight = (screenWidth * 0.3).clamp(110.0, 160.0);

        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Shimmer.fromColors(
          baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
          highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
          child: Container(
            height: cardHeight,
            margin: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: context.colors.white,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
          ),
        );
      },
    );
  }
}

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyHeaderDelegate({required this.child});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  double get maxExtent => 130.0;

  @override
  double get minExtent => 130.0;

  @override
  bool shouldRebuild(covariant _StickyHeaderDelegate oldDelegate) {
    return oldDelegate.child != child;
  }
}
