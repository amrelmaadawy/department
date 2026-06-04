import 'dart:typed_data';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:apartment/features/custom_finishing/presentation/screens/custom_finishing_screen.dart';
import 'package:apartment/features/custom_finishing/presentation/screens/booking_success_screen.dart';
import 'package:apartment/features/custom_finishing/presentation/screens/contracts_review_screen.dart';
import 'package:apartment/features/profile/presentation/screens/profile_screen.dart';

import '../../../features/app_startup/presentation/screens/welcome_screen.dart';
import '../../../features/auth/presentation/screens/auth_screen.dart';
import '../../../features/layout/presentation/screens/layout_screen.dart';
import '../../../features/projects/presentation/screens/project_details_screen.dart';
import '../../../features/projects/presentation/screens/unit_details_screen.dart';
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
  static const String auth = '/auth';
  static const String layout = '/layout';
  static const String projectDetails = '/project-details';
  static const String unitDetails = '/unit-details';
  static const String contractSigning = '/contract-signing';
  static const String contractPreview = '/contract-preview';
  static const String packages = '/packages';
  static const String customFinishing = '/custom-finishing';
  static const String bookingSuccess = '/booking-success';
  static const String contractsReview = '/contracts-review';
  static const String profile = '/profile';
  static const String support = '/support';

  static final router = GoRouter(
    initialLocation: initial,
    routes: [
      GoRoute(
        path: initial,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(path: auth, builder: (context, state) => const AuthScreen()),
      GoRoute(path: layout, builder: (context, state) => const LayoutScreen()),
      GoRoute(
        path: projectDetails,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
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
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
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
        builder: (context, state) {
          final signatureImage = state.extra as Uint8List;
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
        pageBuilder: (context, state) {
          final finishingState = state.extra as CustomFinishingState;
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
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: support,
        builder: (context, state) => const SupportScreen(),
      ),
    ],
  );
}
