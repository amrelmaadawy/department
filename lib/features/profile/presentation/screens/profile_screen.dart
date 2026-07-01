import 'package:apartment/core/theme/app_spacing.dart';
import 'package:apartment/features/layout/presentation/cubit/layout_cubit.dart';
import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

import '../widgets/profile_header.dart';
import '../widgets/profile_stats_card.dart';
import '../widgets/profile_menu_list.dart';
import '../widgets/profile_shimmer_loading.dart';
import '../../../../core/widgets/error_state_view.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/di/injection_container.dart';
import '../../../design_studio/presentation/cubit/design_context_cubit.dart';
import '../widgets/profile_recent_orders_section.dart';
import '../../../projects/domain/entities/finishing_order_entity.dart';
import '../../../../core/network/cubit/network_cubit.dart';
import '../../../../core/network/cubit/network_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    try {
      context.read<ProfileCubit>();
      return const ProfileView();
    } catch (_) {
      return BlocProvider(
        create: (context) => sl<ProfileCubit>(),
        child: const ProfileView(),
      );
    }
  }
}

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _headerAnim;
  late Animation<double> _cardAnim;
  late Animation<double> _listAnim;
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    context.read<ProfileCubit>().loadProfileIfNeeded();

    _headerAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutCubic),
      ),
    );

    _cardAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.3, 0.7, curve: Curves.elasticOut),
      ),
    );

    _listAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOutCubic),
      ),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    context.read<ProfileCubit>().getProfile();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final userType = l10n.premiumCustomer;

    return Scaffold(
      backgroundColor: context.colors.background,
      body: MultiBlocListener(
        listeners: [
          BlocListener<NetworkCubit, NetworkState>(
            listener: (context, networkState) {
              if (networkState is NetworkOnline) {
                final s = context.read<ProfileCubit>().state;
                if (s is ProfileError || s is ProfileInitial) {
                  context.read<ProfileCubit>().getProfile();
                }
              }
            },
          ),
          BlocListener<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state.status == AuthStatus.failure) {
                AppToast.show(
                  context,
                  message: state.errorMessage ?? l10n.bookingError,
                  isError: true,
                );
              } else if (state.status == AuthStatus.success) {
                AppToast.show(
                  context,
                  message: l10n.logoutSuccess,
                  isError: false,
                );
                
                // Clear global states, router auth cache, and caches on logout
                sl<DesignContextCubit>().clearUnitSelection();
                AppRouter.clearAuthCache();
                
                context.go(AppRouter.auth);
              }
            },
          ),
          BlocListener<LayoutCubit, int>(
            listener: (context, index) {
              // 2 is the index of Profile tab
              if (index == 2) {
                context.read<ProfileCubit>().getProfile();
              }
            },
          ),
        ],
        child: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state is ProfileError) {
              AppToast.show(context, message: state.message, isError: true);
            } else if (state is ProfileLoaded && !_hasAnimated) {
              _hasAnimated = true;
              _animController.forward();
            }
          },
          builder: (context, profileState) {
            if (profileState is ProfileLoading || profileState is ProfileInitial) {
              return RefreshIndicator(
                onRefresh: _onRefresh,
                color: context.colors.primary,
                child: const SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      ProfileShimmerLoading(),
                      ProfileMenuList(listAnim: AlwaysStoppedAnimation(1.0)),
                    ],
                  ),
                ),
              );
            }

            String userName = '...';
            String? avatarUrl;
            int designsCount = 0;
            int contractsCount = 0;
            int unitsCount = 0;
            int aiCredits = 0;
            double totalSpent = 0.0;
            List<FinishingOrderEntity> recentOrders = [];

            if (profileState is ProfileLoaded) {
              userName = profileState.profile.user.name;
              avatarUrl = profileState.profile.user.avatarUrl;
              designsCount = profileState.profile.statistics.totalOrders;
              contractsCount = profileState.profile.statistics.totalSavedDesigns;
              unitsCount = profileState.profile.statistics.totalApartments;
              aiCredits = profileState.profile.user.aiCredits;
              totalSpent = profileState.profile.statistics.totalSpent;
              recentOrders = profileState.profile.recentOrders;
            }

            if (profileState is ProfileError) {
              return RefreshIndicator(
                onRefresh: _onRefresh,
                color: context.colors.primary,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: ErrorStateView(
                      message: profileState.message,
                      onRetry: _onRefresh,
                    ),
                  ),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: _onRefresh,
              color: context.colors.primary,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    // Header with stacked stats card
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        FadeTransition(
                          opacity: _headerAnim,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, -0.2),
                              end: Offset.zero,
                            ).animate(_headerAnim),
                            child: ProfileHeader(
                              userName: userName,
                              userType: userType,
                              avatarUrl: avatarUrl,
                              aiCredits: aiCredits,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -80, // Updated for 2x2 grid height
                          left: 0,
                          right: 0,
                          child: ScaleTransition(
                            scale: _cardAnim,
                            child: ProfileStatsCard(
                              designsCount: designsCount,
                              contractsCount: contractsCount,
                              unitsCount: unitsCount,
                              totalSpent: totalSpent,
                              designsLabel: l10n.myDesigns,
                              contractsLabel: l10n.myContracts,
                              unitsLabel: l10n.myUnits,
                              totalSpentLabel: l10n.totalSpent,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Provide space for the overlapping card
                    const SizedBox(height: 100),
                    const SizedBox(height: AppSpacing.md),

                    // Recent Orders
                    ProfileRecentOrdersSection(recentOrders: recentOrders),

                    // Menu Groups
                    ProfileMenuList(listAnim: _listAnim),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
