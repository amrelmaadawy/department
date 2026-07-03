import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:apartment/core/services/security/screenshot_prevention_service.dart';
import 'package:apartment/core/di/injection_container.dart';
import 'package:apartment/core/routes/app_router.dart';
import 'package:apartment/core/theme/app_fonts.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import '../../domain/entities/contract_entity.dart';
import '../../domain/entities/contract_type.dart';
import '../cubit/contracts_cubit.dart';
import '../cubit/contracts_state.dart';
import '../cubit/contract_print_cubit.dart';
import '../cubit/contract_print_state.dart';
import '../../../../core/widgets/app_toast.dart';
import 'contract_details_body.dart';
import '../widgets/contract_details_states_ui.dart';
import 'server_contract_print_preview_screen.dart';

class ContractDetailsScreen extends StatelessWidget {
  final int contractId;

  const ContractDetailsScreen({super.key, required this.contractId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<ContractsCubit>()..loadContractDetails(contractId)),
        BlocProvider(create: (_) => sl<ContractPrintCubit>()),
      ],
      child: const _ContractDetailsView(),
    );
  }
}

class _ContractDetailsView extends StatefulWidget {
  const _ContractDetailsView();

  @override
  State<_ContractDetailsView> createState() => _ContractDetailsViewState();
}

class _ContractDetailsViewState extends State<_ContractDetailsView> {
  @override
  void initState() {
    super.initState();
    ScreenshotPreventionService.enable();
  }

  @override
  void dispose() {
    ScreenshotPreventionService.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ContractPrintCubit, ContractPrintState>(
      listener: (context, printState) {
        if (printState is ContractPrintLoading) {
          AppToast.showInfo(context, 'جاري تحضير العقد...');
        } else if (printState is ContractPrintError) {
          AppToast.showError(context, printState.message);
        } else if (printState is ContractPrintWebViewReady) {
          context.push(
            AppRouter.contractWebView,
            extra: {
              'printUrl': printState.printUrl,
              'pdfUrl': printState.pdfUrl,
              'contractTitle': printState.contractTitle,
            },
          );
        } else if (printState is ContractPrintReady) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => ServerContractPrintPreviewScreen(
              pdfBytes: printState.pdfBytes,
              contractTitle: printState.contractTitle,
            ),
          ));
        }
      },
      child: BlocBuilder<ContractsCubit, ContractsState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: context.colors.background,
            body: _buildBody(context, state),
            floatingActionButton: _buildFab(context, state),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, ContractsState state) {
    if (state is ContractDetailsLoading || state is ContractsInitial) return const ContractDetailsShimmerView();
    if (state is ContractsError) return ContractDetailsErrorView(message: state.message);
    if (state is ContractDetailsLoaded) return ContractDetailsBody(contract: state.contract);
    return const SizedBox.shrink();
  }

  Widget? _buildFab(BuildContext context, ContractsState state) {
    if (state is! ContractDetailsLoaded) return null;
    final ContractEntity contract = state.contract;

    if (contract.status == 'pending_signature') {
      final contractType = contract.type.contains('finishing') ? ContractType.finishing : ContractType.unit;
      return FloatingActionButton.extended(
        onPressed: () => context.push(
          AppRouter.contractSigning,
          extra: {'type': contractType, 'contract': contract, 'overrideTotalAmount': contract.totalAmount},
        ),
        backgroundColor: context.colors.gold,
        foregroundColor: context.colors.white,
        icon: const Icon(Icons.draw_rounded, size: 20),
        label: const Text('وقّع الآن', style: TextStyle(fontWeight: FontWeight.bold, fontSize: AppFonts.bodyMedium)),
      );
    }
    return null;
  }
}
