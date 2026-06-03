import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:apartment/features/custom_finishing/presentation/screens/custom_finishing_screen.dart';
import 'package:apartment/features/custom_finishing/presentation/screens/booking_success_screen.dart';
import 'package:apartment/features/profile/presentation/screens/profile_screen.dart';

import '../../../features/app_startup/presentation/screens/welcome_screen.dart';
import '../../../features/auth/presentation/screens/auth_screen.dart';
import '../../../features/layout/presentation/screens/layout_screen.dart';
import '../../../features/projects/presentation/screens/project_details_screen.dart';
import '../../../features/projects/presentation/screens/unit_details_screen.dart';
import '../../../features/packages/presentation/screens/packages_screen.dart';
import '../../../features/support/presentation/screens/support_screen.dart';
import '../../../features/home/domain/entities/project_entity.dart';
import '../../../features/home/domain/entities/project_unit_entity.dart';
import '../di/injection_container.dart';
import '../../features/custom_finishing/presentation/cubit/custom_finishing_cubit.dart';

class AppRouter {
  static const String initial = '/';
  static const String auth = '/auth';
  static const String layout = '/layout';
  static const String projectDetails = '/project-details';
  static const String unitDetails = '/unit-details';
  static const String packages = '/packages';
  static const String customFinishing = '/custom-finishing';
  static const String bookingSuccess = '/booking-success';
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
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = Offset(0.0, 1.0); // Slide up from bottom
                  const end = Offset.zero;
                  const curve = Curves.easeOutCubic;

                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: curve));

                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
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
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = Offset(0.0, 1.0); // Slide up from bottom
                  const end = Offset.zero;
                  const curve = Curves.easeOutCubic;

                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: curve));

                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
          );
        },
      ),
      GoRoute(
        path: packages,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            transitionDuration: const Duration(milliseconds: 400),
            child: const PackagesScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0); // Slide from right
                  const end = Offset.zero;
                  const curve = Curves.easeOutCubic;
                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: curve));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
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
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.easeInOut;

                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: curve));
                  var offsetAnimation = animation.drive(tween);

                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                },
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
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
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
