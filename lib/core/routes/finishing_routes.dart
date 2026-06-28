import 'package:go_router/go_router.dart';
import 'package:apartment/core/routes/app_router.dart';
import 'package:apartment/core/routes/app_router_transitions.dart';

import 'package:apartment/features/projects/presentation/screens/finishing_summary_screen.dart';
import 'package:apartment/features/contracts/presentation/screens/booking_success_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apartment/features/contracts/presentation/screens/contracts_review_screen.dart';
import 'package:apartment/features/contracts/presentation/cubit/contracts_cubit.dart';
import 'package:apartment/core/di/injection_container.dart';
import 'package:apartment/features/home/domain/entities/project_unit_entity.dart';
import '../../../features/packages/presentation/screens/packages_screen.dart';

class FinishingRoutes {
  static final List<RouteBase> routes = [
    GoRoute(
      path: AppRouter.packages,
      redirect: (context, state) => state.extra == null ? AppRouter.layout : null,
      pageBuilder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        if (extra == null) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const RedirectFallback(route: AppRouter.layout),
            transitionsBuilder: AppRouterTransitions.fadeTransition,
          );
        }
        final unit = extra['unit'] as ProjectUnitEntity;
        return CustomTransitionPage(
          key: state.pageKey,
          transitionDuration: const Duration(milliseconds: 400),
          child: PackagesScreen(unit: unit),
          transitionsBuilder: AppRouterTransitions.slideFromRight,
        );
      },
    ),
    GoRoute(
      path: AppRouter.finishingSummary,
      redirect: (context, state) => state.extra == null ? AppRouter.layout : null,
      pageBuilder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        if (extra == null) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const RedirectFallback(route: AppRouter.layout),
            transitionsBuilder: AppRouterTransitions.fadeTransition,
          );
        }
        final totalFinishingCost = extra['totalFinishingCost'] as double? ?? 0.0;
        final unit = extra['unit'];
        return CustomTransitionPage(
          key: state.pageKey,
          transitionDuration: const Duration(milliseconds: 600),
          child: BlocProvider(
            create: (context) => sl<ContractsCubit>(),
            child: FinishingSummaryScreen(
              totalFinishingCost: totalFinishingCost,
              unit: unit,
            ),
          ),
          transitionsBuilder: AppRouterTransitions.slideFromRight,
        );
      },
    ),

    GoRoute(
      path: AppRouter.contractsReview,
      redirect: (context, state) => state.extra == null ? AppRouter.layout : null,
      pageBuilder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        if (extra == null) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const RedirectFallback(route: AppRouter.layout),
            transitionsBuilder: AppRouterTransitions.fadeTransition,
          );
        }
        final totalFinishingCost = extra['totalFinishingCost'] as double? ?? 0.0;
        final unit = extra['unit'];
        final selectedFinishingOrderIds = extra['selectedFinishingOrderIds'] as List<int>? ?? [];
        return CustomTransitionPage(
          key: state.pageKey,
          transitionDuration: const Duration(milliseconds: 600),
          child: BlocProvider(
            create: (context) => sl<ContractsCubit>(),
            child: ContractsReviewScreen(
              totalFinishingCost: totalFinishingCost,
              unit: unit,
              selectedFinishingOrderIds: selectedFinishingOrderIds,
            ),
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
