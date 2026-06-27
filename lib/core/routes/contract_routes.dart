
import 'dart:typed_data';

import 'package:go_router/go_router.dart';
import 'package:apartment/core/routes/app_router.dart';
import 'package:apartment/core/routes/app_router_transitions.dart';

import '../../../features/contracts/presentation/screens/contract_signing_screen.dart';
import '../../../features/contracts/presentation/screens/contract_review_screen.dart';
import '../../../features/contracts/presentation/screens/contract_details_screen.dart';
import '../../../features/contracts/domain/entities/contract_type.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../features/contracts/presentation/cubit/contracts_cubit.dart';
import 'package:apartment/core/di/injection_container.dart';

class ContractRoutes {
  static final List<RouteBase> routes = [
    GoRoute(
      path: AppRouter.contractSigning,
      pageBuilder: (context, state) {
        final args = state.extra as Map<String, dynamic>? ?? {};
        final contractType = args['type'] as ContractType? ?? ContractType.unit;
        final finishingTotal = args['finishingTotal'] as double?;
        final unit = args['unit'];
        final contract = args['contract'];
        final overrideTotalAmount = args['overrideTotalAmount'] as double?;

        return CustomTransitionPage(
          key: state.pageKey,
          transitionDuration: const Duration(milliseconds: 600),
          child: BlocProvider(
            create: (context) => sl<ContractsCubit>(),
            child: ContractSigningScreen(
              contractType: contractType,
              finishingTotal: finishingTotal,
              unit: unit,
              contract: contract,
              overrideTotalAmount: overrideTotalAmount,
            ),
          ),
          transitionsBuilder: AppRouterTransitions.slideFromRight,
        );
      },
    ),
    GoRoute(
      path: AppRouter.contractReview,
      pageBuilder: (context, state) {
        final args = state.extra as Map<String, dynamic>? ?? {};
        final contract = args['contract'];
        // Cast explicitly to Uint8List — GoRouter preserves in-memory objects
        // as-is when navigating within the same process, so this cast is safe.
        final signatureImage = args['signatureImage'] as Uint8List?;
        return CustomTransitionPage(
          key: state.pageKey,
          transitionDuration: const Duration(milliseconds: 500),
          child: ContractReviewScreen(
            contract: contract,
            signatureImage: signatureImage ?? Uint8List(0),
          ),
          transitionsBuilder: AppRouterTransitions.slideUpFromBottom,
        );
      },
    ),

    GoRoute(
      path: AppRouter.contractDetails,
      pageBuilder: (context, state) {
        final args = state.extra as Map<String, dynamic>? ?? {};
        final contractId = args['contractId'] as int? ?? 0;
        return CustomTransitionPage(
          key: state.pageKey,
          transitionDuration: const Duration(milliseconds: 500),
          child: ContractDetailsScreen(contractId: contractId),
          transitionsBuilder: AppRouterTransitions.slideFromRight,
        );
      },
    ),
  ];
}
