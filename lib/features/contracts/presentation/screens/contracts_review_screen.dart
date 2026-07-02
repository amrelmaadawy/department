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

  @override
  void initState() {
    super.initState();
    final unit = widget.unit ?? sl<DesignContextCubit>().state.selectedUnit;
    if (unit != null) {
      // جلب حالات التوقيع دائماً
      context.read<ContractsCubit>().loadSignatureStatuses(unit.id);

      // لو اليوزر رجع لاستئناف توقيع عقد التشطيب بدون IDs (مثلاً بعد ما طلع وعقد العظم موقّع)
      // نجلب الـ Finishing Orders من السيرفر تلقائياً
      if (widget.selectedFinishingOrderIds.isEmpty) {
        final apartmentId = int.tryParse(unit.id) ?? 0;
        if (apartmentId > 0) {
          context.read<ContractsCubit>().fetchFinishingOrders(apartmentId);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final unit = widget.unit ?? sl<DesignContextCubit>().state.selectedUnit;
    final totalCost = (unit?.price ?? 0.0) + widget.totalFinishingCost;

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
                unit: unit,
                l10n: l10n,
                cubit: context.read<ContractsCubit>(),
                state: state,
                partialFailureType: _partialFailureType,
                partialFailureMsg: _partialFailureMsg,
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
      AppToast.showInfo(context, 'جاري جلب وتحضير العقد للطباعة من الخادم...');
    } else if (state is ContractPrintError) {
      AppToast.showError(context, state.message);
    } else if (state is ContractPrintReady) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => ServerContractPrintPreviewScreen(pdfBytes: state.pdfBytes, contractTitle: state.contractTitle),
      ));
    }
  }

  void _onContractStateListener(BuildContext context, ContractsState state) {
    final unit = widget.unit ?? sl<DesignContextCubit>().state.selectedUnit;
    if (state is ContractsError) {
      AppToast.showError(context, state.message);
    } else if (state is ContractPartialSigningFailure) {
      setState(() {
        _partialFailureType = state.contractType;
        _partialFailureMsg = state.message;
      });
    } else if (state is BoneContractCreated) {
      _navigateToSign(ContractType.unit, unit, state.contract);
    } else if (state is FinishingContractCreated) {
      _navigateToSign(ContractType.finishing, unit, state.contract);
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
      context.read<ContractsCubit>().createBoneContract(apartmentId: int.tryParse(unit.id) ?? 0);
    } else if (item.contractType == 'finishing') {
      // لو الـ IDs ممررة من الشاشة السابقة استخدمها مباشرة
      // لو فارغة (حالة الاستئناف) نجيب الـ IDs من الـ State اللي جبناه من السيرفر
      List<int> orderIds = widget.selectedFinishingOrderIds;
      if (orderIds.isEmpty) {
        final cubitState = context.read<ContractsCubit>().state;
        if (cubitState is FinishingOrdersLoaded) {
          orderIds = cubitState.rooms
              .expand((room) => room.orders)
              .map((order) => order.id)
              .toList();
        }
      }
      context.read<ContractsCubit>().createFinishingContract(orderIds: orderIds);
    }
  }
}
