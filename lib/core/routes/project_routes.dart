import 'package:go_router/go_router.dart';
import 'package:apartment/core/routes/app_router.dart';
import 'package:apartment/core/routes/app_router_transitions.dart';

import '../../../features/projects/presentation/screens/project_details_screen.dart';
import '../../../features/projects/presentation/screens/unit_details_screen.dart';
import '../../../features/projects/presentation/screens/unit_customization_screen.dart';

import '../../../features/projects/presentation/screens/ai_renders_screen.dart';
import '../../../features/home/domain/entities/project_entity.dart';
import '../../../features/home/domain/entities/project_unit_entity.dart';

class ProjectRoutes {
  static final List<RouteBase> routes = [
    GoRoute(
      path: AppRouter.projectDetails,
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
      path: AppRouter.unitDetails,
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
      path: AppRouter.unitCustomization,
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
        return CustomTransitionPage(
          key: state.pageKey,
          transitionDuration: const Duration(milliseconds: 600),
          child: UnitCustomizationScreen(
            unit: extra['unit'] as ProjectUnitEntity,
          ),
          transitionsBuilder: AppRouterTransitions.slideUpFromBottom,
        );
      },
    ),
    GoRoute(
      path: '/ai-renders/:orderId',
      builder: (context, state) {
        final orderIdStr = state.pathParameters['orderId'];
        final orderId = int.tryParse(orderIdStr ?? '0') ?? 0;
        final extra = state.extra as Map<String, dynamic>?;
        final features = (extra?['features'] as List<dynamic>?)?.cast<String>() ?? [];
        final projectName = extra?['projectName'] as String? ?? '';
        return AiRendersScreen(
          orderId: orderId,
          projectFeatures: features,
          projectName: projectName,
        );
      },
    ),
  ];
}
