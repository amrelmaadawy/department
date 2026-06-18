import 'dart:typed_data';
import 'package:go_router/go_router.dart';
import 'package:apartment/core/routes/app_router.dart';
import 'package:apartment/core/routes/app_router_transitions.dart';

import '../../../features/contracts/presentation/screens/contract_signing_screen.dart';
import '../../../features/contracts/presentation/screens/contract_preview_screen.dart';
import '../../../features/contracts/domain/entities/contract_type.dart';

class ContractRoutes {
  static final List<RouteBase> routes = [
    GoRoute(
      path: AppRouter.contractSigning,
      pageBuilder: (context, state) {
        final args = state.extra as Map<String, dynamic>? ?? {};
        final contractType = args['type'] as ContractType? ?? ContractType.unit;
        final finishingTotal = args['finishingTotal'] as double?;
        final unit = args['unit'];
        
        return CustomTransitionPage(
          key: state.pageKey,
          transitionDuration: const Duration(milliseconds: 600),
          child: ContractSigningScreen(
            contractType: contractType,
            finishingTotal: finishingTotal,
            unit: unit,
          ),
          transitionsBuilder: AppRouterTransitions.slideFromRight,
        );
      },
    ),
    GoRoute(
      path: AppRouter.contractPreview,
      redirect: (context, state) => state.extra == null ? AppRouter.contractSigning : null,
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>?; 
        final signatureImage = args != null ? args['signatureImage'] as Uint8List? : null;
        if (signatureImage == null) return const RedirectFallback(route: AppRouter.contractSigning);
        return ContractPreviewScreen(signatureImage: signatureImage, contractType: args?['contractType'], price: args?['price'], unit: args?['unit']);
      },
    ),
  ];
}
