import 'package:apartment/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../cubit/home_cubit.dart';
import '../widgets/featured_project_card.dart';
import '../widgets/home_header.dart';
import '../widgets/promo_banner_card.dart';
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
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            return CustomScrollView(
              slivers: [
                // Collapsable Header
                const SliverToBoxAdapter(child: HomeHeader()),

                // Content based on state
                if (state is HomeLoading || state is HomeInitial)
                  SliverToBoxAdapter(child: _buildShimmerLoading())
                else if (state is HomeLoaded)
                  SliverList(
                    delegate: SliverChildListDelegate([
                      const PromoBannerCard(),
                      SectionHeader(
                        title: l10n.featuredProjects,
                        onViewAll: () {},
                      ),
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
                    child: Center(child: Text(state.message)),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Promo Banner Shimmer
          Container(
            width: double.infinity,
            height: 200,
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          // Section Title Shimmer
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Container(
              width: 150,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.white,
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
                    color: Colors.white,
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
