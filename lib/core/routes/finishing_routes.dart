import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:apartment/core/routes/app_router.dart';
import 'package:apartment/core/routes/app_router_transitions.dart';

import 'package:apartment/features/custom_finishing/presentation/screens/custom_finishing_screen.dart';
import 'package:apartment/features/custom_finishing/presentation/screens/booking_success_screen.dart';
import 'package:apartment/features/custom_finishing/presentation/screens/contracts_review_screen.dart';
import '../../../features/packages/presentation/screens/packages_screen.dart';
import '../di/injection_container.dart';
import '../../features/custom_finishing/presentation/cubit/custom_finishing_cubit.dart';

class FinishingRoutes {
  static final List<RouteBase> routes = [
    GoRoute(
      path: AppRouter.packages,
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
      path: AppRouter.customFinishing,
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
      path: AppRouter.contractsReview,
      redirect: (context, state) => state.extra == null ? AppRouter.customFinishing : null,
      pageBuilder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        if (extra == null) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const RedirectFallback(route: AppRouter.customFinishing),
            transitionsBuilder: AppRouterTransitions.fadeTransition,
          );
        }
        final totalFinishingCost = extra['totalFinishingCost'] as double? ?? 0.0;
        final unit = extra['unit'];
        return CustomTransitionPage(
          key: state.pageKey,
          transitionDuration: const Duration(milliseconds: 600),
          child: ContractsReviewScreen(
            totalFinishingCost: totalFinishingCost,
            unit: unit,
          ),
          transitionsBuilder: AppRouterTransitions.slideFromRight,
        );
      },
    ),
    GoRoute(
      path: AppRouter.bookingSuccess,
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
  ];
}
