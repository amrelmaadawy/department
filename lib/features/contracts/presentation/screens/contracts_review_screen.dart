import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../features/home/domain/entities/project_unit_entity.dart';
import '../../../../features/design_studio/presentation/cubit/design_context_cubit.dart';
import '../../domain/entities/contract_type.dart';
import '../../domain/entities/contract_signature_status_entity.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import '../../../../l10n/app_localizations.dart';
import '../cubit/contracts_cubit.dart';
import '../cubit/contracts_state.dart';
import '../cubit/contract_print_cubit.dart';
import '../cubit/contract_print_state.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../../core/events/app_events.dart';
import '../widgets/contracts_review_list.dart';
import 'server_contract_print_preview_screen.dart';

class ContractsReviewScreen extends StatefulWidget {
  final double totalFinishingCost;
  final ProjectUnitEntity? unit;
  final List<int> selectedFinishingOrderIds;

  const ContractsReviewScreen({
    super.key,
    required this.totalFinishingCost,
    this.unit,
    this.selectedFinishingOrderIds = const [],
  });

  @override
  State<ContractsReviewScreen> createState() => _ContractsReviewScreenState();
}

class _ContractsReviewScreenState extends State<ContractsReviewScreen> {
  String? _partialFailureType;
  String? _partialFailureMsg;
  ProjectUnitEntity? _currentUnit;

  /// Tracks whether finishing orders are still loading from the server.
  /// Shown as a loading indicator on the finishing contract card so the
  /// user cannot tap "Sign" before the order IDs are available.
  bool _isLoadingFinishingOrders = false;

  @override
  void initState() {
    super.initState();
    _currentUnit = widget.unit ?? sl<DesignContextCubit>().state.selectedUnit;
    if (_currentUnit != null) {
      context.read<ContractsCubit>().loadSignatureStatuses(_currentUnit!.id);

      final apartmentId = int.tryParse(_currentUnit!.id) ?? 0;

      if (widget.selectedFinishingOrderIds.isNotEmpty) {
        // IDs passed directly from the previous screen — seed the cache.
        context.read<ContractsCubit>().cachedFinishingOrderIds =
            widget.selectedFinishingOrderIds;
        context.read<ContractsCubit>().isFinishingOrdersReady = true;
      } else if (apartmentId > 0) {
        // Resume scenario: load from local storage first (instant),
        // then refresh from server in background.
        _loadFinishingOrdersForResume(apartmentId);
      }
    }
  }

  Future<void> _loadFinishingOrdersForResume(int apartmentId) async {
    final cubit = context.read<ContractsCubit>();

    // Step 1: Read from local storage immediately (no network, no spinner)
    await cubit.loadCachedFinishingOrderIds(apartmentId);

    // Step 2: If still empty after local read → show spinner and fetch from server
    if (!cubit.isFinishingOrdersReady) {
      if (mounted) setState(() => _isLoadingFinishingOrders = true);
      cubit.fetchFinishingOrders(apartmentId);
    } else {
      // IDs available from cache — silently refresh from server in background
      cubit.fetchFinishingOrders(apartmentId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final totalCost = (_currentUnit?.price ?? 0.0) + widget.totalFinishingCost;

    return BlocProvider(
      create: (_) => sl<ContractPrintCubit>(),
      child: Scaffold(
        backgroundColor: context.colors.background,
        appBar: AppBar(
          backgroundColor: context.colors.white,
          scrolledUnderElevation: 0,
          centerTitle: true,
          title: Text(
            l10n.reviewAndSignContracts,
            style: TextStyle(fontSize: AppFonts.headlineMedium, fontWeight: FontWeight.bold, color: context.colors.primary),
          ),
          leading: IconButton(
            icon: Icon(FluentIcons.arrow_left_24_filled, color: context.colors.primary),
            onPressed: () => context.pop(),
          ),
        ),
        body: BlocListener<ContractPrintCubit, ContractPrintState>(
          listener: _onPrintStateListener,
          child: BlocConsumer<ContractsCubit, ContractsState>(
            listener: _onContractStateListener,
            builder: (context, state) {
              return ContractsReviewList(
                totalCost: totalCost,
                unit: _currentUnit,
                l10n: l10n,
                cubit: context.read<ContractsCubit>(),
                state: state,
                partialFailureType: _partialFailureType,
                partialFailureMsg: _partialFailureMsg,
                isLoadingFinishingOrders: _isLoadingFinishingOrders,
                onSignClick: _handleSignClick,
              );
            },
          ),
        ),
      ),
    );
  }

  void _onPrintStateListener(BuildContext context, ContractPrintState state) {
    if (state is ContractPrintLoading) {
      AppToast.showInfo(context, 'جاري جلب بيانات العقد...');
    } else if (state is ContractPrintError) {
      AppToast.showError(context, state.message);
    } else if (state is ContractPrintWebViewReady) {
      // Preferred path: open the server print_url in an in-app WebView
      context.push(
        AppRouter.contractWebView,
        extra: {
          'printUrl': state.printUrl,
          'pdfUrl': state.pdfUrl,
          'contractTitle': state.contractTitle,
        },
      );
    } else if (state is ContractPrintReady) {
      // Fallback: legacy PDF bytes path (kept for backward compatibility)
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => ServerContractPrintPreviewScreen(
          pdfBytes: state.pdfBytes,
          contractTitle: state.contractTitle,
        ),
      ));
    }
  }

  void _onContractStateListener(BuildContext context, ContractsState state) {
    if (state is ContractsError) {
      // If finishing orders failed to load, clear the loading flag so the
      // user sees the error and can retry.
      if (_isLoadingFinishingOrders) {
        setState(() => _isLoadingFinishingOrders = false);
      }
      AppToast.showError(context, state.message);
    } else if (state is FinishingOrdersLoaded) {
      // Orders are now cached in cubit.cachedFinishingOrderIds — hide spinner.
      if (_isLoadingFinishingOrders) {
        setState(() => _isLoadingFinishingOrders = false);
      }
    } else if (state is ContractPartialSigningFailure) {
      setState(() {
        _partialFailureType = state.contractType;
        _partialFailureMsg = state.message;
      });
    } else if (state is BoneContractCreated) {
      _navigateToSign(ContractType.unit, _currentUnit, state.contract);
    } else if (state is FinishingContractCreated) {
      _navigateToSign(ContractType.finishing, _currentUnit, state.contract);
    }
  }

  Future<void> _navigateToSign(ContractType type, ProjectUnitEntity? unit, dynamic contract) async {
    final cubit = context.read<ContractsCubit>();
    final result = await context.push(
      AppRouter.contractSigning,
      extra: {'type': type, 'unit': unit, 'contract': contract, 'finishingTotal': widget.totalFinishingCost},
    );
    if (!mounted) return;
    if (result == true && unit != null) {
      setState(() {
        _partialFailureType = null;
        _partialFailureMsg = null;
      });
      final typeStr = type == ContractType.unit ? 'unit' : 'finishing';
      cubit.markContractAsSigned(unit.id, typeStr);
      if (type == ContractType.unit) {
        AppEvents.emitContractSigned(unit.id);
        setState(() {
          _currentUnit = _currentUnit?.copyWith(
            status: UnitStatus.sold,
            statusLabel: 'مباعة',
          );
        });
      }
    }
  }

  void _handleSignClick(ContractSignatureStatusEntity item, ProjectUnitEntity? unit) {
    if (unit == null) return;
    setState(() {
      _partialFailureType = null;
      _partialFailureMsg = null;
    });

    if (item.contractType == 'unit') {
      context.read<ContractsCubit>().createBoneContract(
            apartmentId: int.tryParse(unit.id) ?? 0,
          );
      return;
    }

    if (item.contractType == 'finishing') {
      final cubit = context.read<ContractsCubit>();

      // Guard: still loading orders → show toast instead of creating with empty IDs
      if (_isLoadingFinishingOrders || cubit.isLoadingFinishingOrders) {
        AppToast.showInfo(context, 'جاري جلب بيانات التشطيب، يرجى الانتظار لحظة...');
        return;
      }

      // Resolve IDs: prefer widget-provided → then cubit cache (resume scenario)
      final orderIds = widget.selectedFinishingOrderIds.isNotEmpty
          ? widget.selectedFinishingOrderIds
          : cubit.cachedFinishingOrderIds;

      if (orderIds.isEmpty) {
        // Orders fetch may have failed — retry fetch then show error
        AppToast.showError(context, 'لم يتم جلب بيانات طلبات التشطيب. تحقق من اتصالك وأعد المحاولة.');
        final apartmentId = int.tryParse(unit.id) ?? 0;
        if (apartmentId > 0) {
          setState(() => _isLoadingFinishingOrders = true);
          cubit.fetchFinishingOrders(apartmentId);
        }
        return;
      }

      cubit.createFinishingContract(orderIds: orderIds);
    }
  }
}
