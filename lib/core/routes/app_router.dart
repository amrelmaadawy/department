import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../features/app_startup/presentation/screens/welcome_screen.dart';
import '../../../features/layout/presentation/screens/layout_screen.dart';
import '../di/injection_container.dart';

import 'auth_routes.dart';
import 'project_routes.dart';
import 'profile_routes.dart';
import 'contract_routes.dart';
import 'finishing_routes.dart';
import 'payment_routes.dart';

class AppRouter {
  static const String initial = '/';
  static const String onboarding = '/onboarding';
  static const String auth = '/auth';
  static const String layout = '/layout';
  static const String projectDetails = '/project-details';
  static const String unitDetails = '/unit-details';

  static const String contractSigning = '/contract-signing';
  static const String contractPreview = '/contract-preview';
  static const String packages = '/packages';

  static const String finishingSummary = '/finishing-summary';
  static const String bookingSuccess = '/booking-success';
  static const String contractsReview = '/contracts-review';
  static const String checkout = '/checkout';
  static const String paymentSuccess = '/payment-success';
  static const String profile = '/profile';
  static const String myUnits = '/my-units';
  static const String unitProgress = '/unit-progress';
  static const String unitContract = '/unit-contract';
  static const String editProfile = '/edit-profile';
  static const String security = '/security';
  static const String appSettings = '/app-settings';
  static const String unitCustomization = '/unit-customization';
  static const String support = '/support';
  static const String aiGallery = '/ai-gallery';
  static const String savedDesigns = '/saved-designs';
  static const String finishingGuide = '/finishing-guide';

  static final router = GoRouter(
    initialLocation: initial,
    redirect: (context, state) async {
      final secureStorage = sl<FlutterSecureStorage>();
      final token = await secureStorage.read(key: 'auth_token');
      final isAuth = token != null && token.isNotEmpty;

      final isGoingToAuth = state.uri.path == auth;
      final isGoingToOnboarding = state.uri.path == onboarding;
      final isGoingToInitial = state.uri.path == initial;
      
      final isPublicRoute = isGoingToInitial || isGoingToOnboarding || isGoingToAuth;

      if (!isAuth && !isPublicRoute) {
        return auth;
      }

      if (isAuth && (isGoingToAuth || isGoingToOnboarding)) {
        return layout;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: initial,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(path: layout, builder: (context, state) => const LayoutScreen()),
      ...AuthRoutes.routes,
      ...ProjectRoutes.routes,
      ...ProfileRoutes.routes,
      ...ContractRoutes.routes,
      ...FinishingRoutes.routes,
      ...PaymentRoutes.routes,
    ],
  );
}

class RedirectFallback extends StatefulWidget {
  final String route;
  const RedirectFallback({super.key, required this.route});

  @override
  State<RedirectFallback> createState() => _RedirectFallbackState();
}

class _RedirectFallbackState extends State<RedirectFallback> {
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
