import 'package:apartment/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

import '../widgets/profile_header.dart';
import '../widgets/profile_stats_card.dart';
import '../widgets/profile_menu_list.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/di/injection_container.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProfileCubit>()..getProfile(),
      child: const ProfileView(),
    );
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

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

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

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Mock Data for stats
    final userType = l10n.premiumCustomer;
    const designsCount = 12;
    const contractsCount = 5;
    const unitsCount = 3;

    return Scaffold(
      backgroundColor: context.colors.background,
      body: BlocListener<AuthCubit, AuthState>(
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
            context.go(AppRouter.auth);
          }
        },
        child: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state is ProfileError) {
              AppToast.show(context, message: state.message, isError: true);
            }
          },
          builder: (context, profileState) {
            String userName = '...';
            String avatarUrl = 'assets/images/profile_avatar.png';

            if (profileState is ProfileLoaded) {
              userName = profileState.profile.name;
              avatarUrl = profileState.profile.avatarUrl ?? avatarUrl;
            } else if (profileState is ProfileError) {
              userName = 'خطأ في التحميل';
            } else if (profileState is ProfileLoading) {
              userName = 'جاري التحميل...';
            }

            return SingleChildScrollView(
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
                          ),
                        ),
                      ),
/*
                      Positioned(
                        bottom: -40, // Half of the card height approximately
                        left: 0,
                        right: 0,
                        child: ScaleTransition(
                          scale: _cardAnim,
                          child: ProfileStatsCard(
                            designsCount: designsCount,
                            contractsCount: contractsCount,
                            unitsCount: unitsCount,
                            designsLabel: l10n.myDesigns,
                            contractsLabel: l10n.myContracts,
                            unitsLabel: l10n.myUnits,
                          ),
                        ),
                      ),
*/
                    ],
                  ),

                  // Provide space for the overlapping card
                  // const SizedBox(height: 60),
                  const SizedBox(height: AppSpacing.xxl),

                  // Menu Groups
                  ProfileMenuList(listAnim: _listAnim),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
