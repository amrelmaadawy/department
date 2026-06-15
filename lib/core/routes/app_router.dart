import 'dart:typed_data';
import 'package:apartment/features/home/domain/entities/unit_room_entity.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:apartment/features/custom_finishing/presentation/screens/custom_finishing_screen.dart';
import 'package:apartment/features/custom_finishing/presentation/screens/booking_success_screen.dart';
import 'package:apartment/features/custom_finishing/presentation/screens/contracts_review_screen.dart';
import 'package:apartment/features/profile/presentation/screens/profile_screen.dart';

import '../../../features/app_startup/presentation/screens/welcome_screen.dart';
import '../../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../../features/profile/presentation/screens/app_settings_screen.dart';
import '../../../features/profile/presentation/screens/edit_profile_screen.dart';
import '../../../features/profile/presentation/screens/security_screen.dart';
import '../../../features/profile/presentation/screens/my_units_screen.dart';
import '../../../features/profile/presentation/screens/unit_contract_screen.dart';
import '../../../features/profile/presentation/screens/unit_progress_screen.dart';
import '../../../features/auth/presentation/screens/auth_screen.dart';
import '../../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../../features/layout/presentation/screens/layout_screen.dart';
import '../../../features/projects/presentation/screens/project_details_screen.dart';
import '../../../features/projects/presentation/screens/unit_details_screen.dart';
import '../../../features/projects/presentation/screens/room_details_screen.dart';
import '../../../features/contracts/presentation/screens/contract_signing_screen.dart';
import '../../../features/contracts/presentation/screens/contract_preview_screen.dart';
import '../../../features/contracts/domain/entities/contract_type.dart';
import '../../../features/packages/presentation/screens/packages_screen.dart';
import '../../../features/support/presentation/screens/support_screen.dart';
import '../../../features/home/domain/entities/project_entity.dart';
import '../../../features/home/domain/entities/project_unit_entity.dart';
import '../di/injection_container.dart';
import '../../features/custom_finishing/presentation/cubit/custom_finishing_cubit.dart';
import '../../features/custom_finishing/presentation/cubit/custom_finishing_state.dart';
import 'app_router_transitions.dart';

class AppRouter {
  static const String initial = '/';
  static const String onboarding = '/onboarding';
  static const String auth = '/auth';
  static const String layout = '/layout';
  static const String projectDetails = '/project-details';
  static const String unitDetails = '/unit-details';
  static const String roomDetails = '/room-details';
  static const String contractSigning = '/contract-signing';
  static const String contractPreview = '/contract-preview';
  static const String packages = '/packages';
  static const String customFinishing = '/custom-finishing';
  static const String bookingSuccess = '/booking-success';
  static const String contractsReview = '/contracts-review';
  static const String profile = '/profile';
  static const String myUnits = '/my-units';
  static const String unitProgress = '/unit-progress';
  static const String unitContract = '/unit-contract';
  static const String editProfile = '/edit-profile';
  static const String security = '/security';
  static const String appSettings = '/app-settings';
  static const String support = '/support';

  static final router = GoRouter(
    initialLocation: initial,
    routes: [
      GoRoute(
        path: initial,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(path: auth, builder: (context, state) => const AuthScreen()),
      GoRoute(path: layout, builder: (context, state) => const LayoutScreen()),
      GoRoute(
        path: projectDetails,
        redirect: (context, state) => state.extra == null ? layout : null,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          if (extra == null) {
            return CustomTransitionPage(
              key: state.pageKey,
              child: const _RedirectFallback(route: layout),
              transitionsBuilder: AppRouterTransitions.fadeTransition,
            );
          }
          return CustomTransitionPage(
            key: state.pageKey,
            transitionDuration: const Duration(milliseconds: 600),
            child: ProjectDetailsScreen(
              project: extra['project'] as ProjectEntity,
              heroTag: extra['heroTag'] as String,
            ),
            transitionsBuilder: AppRouterTransitions.slideUpFromBottom,
          );
        },
      ),
      GoRoute(
        path: unitDetails,
        redirect: (context, state) => state.extra == null ? layout : null,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          if (extra == null) {
            return CustomTransitionPage(
              key: state.pageKey,
              child: const _RedirectFallback(route: layout),
              transitionsBuilder: AppRouterTransitions.fadeTransition,
            );
          }
          return CustomTransitionPage(
            key: state.pageKey,
            transitionDuration: const Duration(milliseconds: 600),
            child: UnitDetailsScreen(
              unit: extra['unit'] as ProjectUnitEntity,
              heroTag: extra['heroTag'] as String,
            ),
            transitionsBuilder: AppRouterTransitions.slideUpFromBottom,
          );
        },
      ),
      GoRoute(
        path: roomDetails,
        redirect: (context, state) => state.extra == null ? layout : null,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          if (extra == null) {
            return CustomTransitionPage(
              key: state.pageKey,
              child: const _RedirectFallback(route: layout),
              transitionsBuilder: AppRouterTransitions.fadeTransition,
            );
          }
          return CustomTransitionPage(
            key: state.pageKey,
            transitionDuration: const Duration(milliseconds: 400),
            child: RoomDetailsScreen(
              initialRoom: extra['room'] as UnitRoomEntity,
              apartmentId: extra['apartmentId'] as int,
            ),
            transitionsBuilder: AppRouterTransitions.slideFromRight,
          );
        },
      ),
      GoRoute(
        path: contractSigning,
        pageBuilder: (context, state) {
          final args = state.extra as Map<String, dynamic>? ?? {};
          final contractType = args['type'] as ContractType? ?? ContractType.unit;
          final finishingTotal = args['finishingTotal'] as double?;
          
          return CustomTransitionPage(
            key: state.pageKey,
            transitionDuration: const Duration(milliseconds: 600),
            child: ContractSigningScreen(
              contractType: contractType,
              finishingTotal: finishingTotal,
            ),
            transitionsBuilder: AppRouterTransitions.slideFromRight,
          );
        },
      ),
      GoRoute(
        path: contractPreview,
        redirect: (context, state) => state.extra == null ? contractSigning : null,
        builder: (context, state) {
          final signatureImage = state.extra as Uint8List?;
          if (signatureImage == null) return const _RedirectFallback(route: contractSigning);
          return ContractPreviewScreen(signatureImage: signatureImage);
        },
      ),
      GoRoute(
        path: packages,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            transitionDuration: const Duration(milliseconds: 400),
            child: const PackagesScreen(),
            transitionsBuilder: AppRouterTransitions.slideFromRight,
          );
        },
      ),
      GoRoute(
        path: customFinishing,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: BlocProvider(
              create: (context) => sl<CustomFinishingCubit>()..loadMaterials(),
              child: const CustomFinishingScreen(),
            ),
            transitionsBuilder: AppRouterTransitions.slideFromRight,
          );
        },
      ),
      GoRoute(
        path: contractsReview,
        redirect: (context, state) => state.extra == null ? customFinishing : null,
        pageBuilder: (context, state) {
          final finishingState = state.extra as CustomFinishingState?;
          if (finishingState == null) {
            return CustomTransitionPage(
              key: state.pageKey,
              child: const _RedirectFallback(route: customFinishing),
              transitionsBuilder: AppRouterTransitions.fadeTransition,
            );
          }
          return CustomTransitionPage(
            key: state.pageKey,
            transitionDuration: const Duration(milliseconds: 600),
            child: ContractsReviewScreen(finishingState: finishingState),
            transitionsBuilder: AppRouterTransitions.slideFromRight,
          );
        },
      ),
      GoRoute(
        path: bookingSuccess,
        pageBuilder: (context, state) {
          final orderId = state.extra as String? ?? 'ORD-00000';
          return CustomTransitionPage(
            key: state.pageKey,
            transitionDuration: const Duration(milliseconds: 500),
            child: BookingSuccessScreen(orderId: orderId),
            transitionsBuilder: AppRouterTransitions.fadeTransition,
          );
        },
      ),
      GoRoute(
        path: profile,
        builder: (context, state) => BlocProvider(
          create: (_) => sl<AuthCubit>(),
          child: const ProfileScreen(),
        ),
      ),
      GoRoute(
        path: myUnits,
        builder: (context, state) => const MyUnitsScreen(),
      ),
      GoRoute(
        path: unitProgress,
        builder: (context, state) => const UnitProgressScreen(),
      ),
      GoRoute(
        path: unitContract,
        builder: (context, state) => const UnitContractScreen(),
      ),
      GoRoute(
        path: editProfile,
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: security,
        builder: (context, state) => const SecurityScreen(),
      ),
      GoRoute(
        path: appSettings,
        builder: (context, state) => const AppSettingsScreen(),
      ),
      GoRoute(
        path: support,
        builder: (context, state) => const SupportScreen(),
      ),
    ],
  );
}

class _RedirectFallback extends StatefulWidget {
  final String route;
  const _RedirectFallback({required this.route});

  @override
  State<_RedirectFallback> createState() => _RedirectFallbackState();
}

class _RedirectFallbackState extends State<_RedirectFallback> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.go(widget.route);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
