import 'package:go_router/go_router.dart';

import '../../../features/app_startup/presentation/screens/welcome_screen.dart';

class AppRouter {
  static const String initial = '/';

  static final router = GoRouter(
    initialLocation: initial,
    routes: [
      GoRoute(
        path: initial,
        builder: (context, state) => const WelcomeScreen(),
      ),
    ],
  );
}
