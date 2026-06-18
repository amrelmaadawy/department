import 'package:go_router/go_router.dart';
import 'package:apartment/core/routes/app_router.dart';

import '../../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../../features/auth/presentation/screens/auth_screen.dart';

class AuthRoutes {
  static final List<RouteBase> routes = [
    GoRoute(
      path: AppRouter.onboarding,
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: AppRouter.auth,
      builder: (context, state) => const AuthScreen(),
    ),
  ];
}
