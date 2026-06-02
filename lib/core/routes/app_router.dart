import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../features/app_startup/presentation/screens/welcome_screen.dart';
import '../../../features/auth/presentation/screens/auth_screen.dart';
import '../../../features/layout/presentation/screens/layout_screen.dart';
import '../../../features/projects/presentation/screens/project_details_screen.dart';
import '../../../features/home/domain/entities/project_entity.dart';

class AppRouter {
  static const String initial = '/';
  static const String auth = '/auth';
  static const String layout = '/layout';
  static const String projectDetails = '/project-details';

  static final router = GoRouter(
    initialLocation: initial,
    routes: [
      GoRoute(
        path: initial,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: auth,
        builder: (context, state) => const AuthScreen(),
      ),
      GoRoute(
        path: layout,
        builder: (context, state) => const LayoutScreen(),
      ),
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
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(0.0, 1.0); // Slide up from bottom
              const end = Offset.zero;
              const curve = Curves.easeOutCubic;

              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          );
        },
      ),
    ],
  );
}
