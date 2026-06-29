import 'package:apartment/core/theme/app_colors.dart';
import 'package:apartment/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/widgets/empty_state_view.dart';
import '../../../../core/widgets/error_state_view.dart';
import '../../../../core/theme/theme_extension.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/network/cubit/network_cubit.dart';
import '../../../../core/network/cubit/network_state.dart';
import '../cubit/home_cubit.dart';
import '../widgets/featured_project_card.dart';
import '../widgets/home_header.dart';
import '../widgets/company_services_carousel.dart';
import '../widgets/section_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HomeCubit>()..loadHomeData(),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: BlocListener<NetworkCubit, NetworkState>(
          listener: (context, networkState) {
            if (networkState is NetworkOnline) {
              final state = context.read<HomeCubit>().state;
              if (state is HomeError || (state is HomeLoaded && state.featuredProjects.isEmpty)) {
                context.read<HomeCubit>().loadHomeData();
              }
            }
          },
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              return RefreshIndicator(
                onRefresh: () async {
                  await context.read<HomeCubit>().loadHomeData();
                },
                color: context.colors.primary,
                child: CustomScrollView(
                  slivers: [
                    // Collapsable Header
                const SliverToBoxAdapter(child: HomeHeader()),

                // Cached Data Warning Banner
                BlocBuilder<NetworkCubit, NetworkState>(
                  builder: (context, networkState) {
                    if (networkState is NetworkOffline && state is HomeLoaded) {
                      return SliverToBoxAdapter(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: AppSpacing.lg),
                          color: context.colors.warning.withValues(alpha: 0.1),
                          child: Row(
                            children: [
                              Icon(Icons.wifi_off_rounded, size: 16, color: context.colors.warning),
                              const SizedBox(width: AppSpacing.sm),
                              Expanded(
                                child: Text(
                                  l10n.offlineCacheWarning,
                                  style: TextStyle(fontSize: 12, color: context.colors.warning, fontWeight: FontWeight.bold),
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

                // Content based on state
                if (state is HomeLoading || state is HomeInitial)
                  SliverToBoxAdapter(child: _buildShimmerLoading(context))
                else if (state is HomeLoaded)
                  SliverList(
                    delegate: SliverChildListDelegate([
                      const CompanyServicesCarousel(),
                      const SizedBox(height: AppSpacing.md),
                      SectionHeader(
                        title: l10n.featuredProjects,
                      ),
                      if (state.featuredProjects.isEmpty)
                        EmptyStateView(
                          icon: FluentIcons.building_desktop_24_regular,
                          title: l10n.homeNoProjectsTitle,
                          subtitle: l10n.homeNoProjectsSubtitle,
                        )
                      else
                        SizedBox(
                          height: 280,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg,
                            ),
                            itemCount: state.featuredProjects.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(width: AppSpacing.lg),
                            itemBuilder: (context, index) {
                              return FeaturedProjectCard(
                                project: state.featuredProjects[index],
                              );
                            },
                          ),
                        ),
                      const SizedBox(height: AppSpacing.xxl),
                    ]),
                  )
                else if (state is HomeError)
                  SliverFillRemaining(
                    child: Center(
                      child: ErrorStateView(
                        message: state.message,
                        onRetry: () => context.read<HomeCubit>().loadHomeData(),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
        ),
      ),
    ));
  }

  Widget _buildShimmerLoading(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? AppColors.grey800: AppColors.grey300,
      highlightColor: isDark ? AppColors.grey700: AppColors.grey100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Company Services Carousel Shimmer
          Container(
            width: double.infinity,
            height: 180,
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            decoration: BoxDecoration(
              color: context.colors.white,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          // Section Title Shimmer
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Container(
              width: 150,
              height: 24,
              decoration: BoxDecoration(
                color: context.colors.white,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          // Horizontal Cards Shimmer
          SizedBox(
            height: 280,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              itemCount: 3,
              separatorBuilder: (context, index) =>
                  const SizedBox(width: AppSpacing.lg),
              itemBuilder: (context, index) {
                return Container(
                  width: 220,
                  decoration: BoxDecoration(
                    color: context.colors.white,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
