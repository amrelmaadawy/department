import 'package:go_router/go_router.dart';

import '../../../features/app_startup/presentation/screens/welcome_screen.dart';
import '../../../features/auth/presentation/screens/auth_screen.dart';
import '../../../features/layout/presentation/screens/layout_screen.dart';

class AppRouter {
  static const String initial = '/';
  static const String auth = '/auth';
  static const String layout = '/layout';

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
    ],
  );
}
