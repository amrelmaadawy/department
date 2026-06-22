import 'package:go_router/go_router.dart';

import 'app_router.dart';
import '../../features/payment/presentation/screens/checkout_screen.dart';
import '../../features/payment/presentation/screens/payment_success_screen.dart';

class PaymentRoutes {
  static final routes = [
    GoRoute(
      path: AppRouter.checkout,
      builder: (context, state) {
        final totalCost = state.extra as double? ?? 0.0;
        return CheckoutScreen(totalFinishingCost: totalCost);
      },
    ),
    GoRoute(
      path: AppRouter.paymentSuccess,
      builder: (context, state) => const PaymentSuccessScreen(),
    ),
  ];
}
