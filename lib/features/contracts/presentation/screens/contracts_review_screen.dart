import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../features/home/domain/entities/project_unit_entity.dart';
import '../../../../features/design_studio/presentation/cubit/design_context_cubit.dart';
import '../../domain/entities/contract_type.dart';
import '../../domain/entities/contract_signature_status_entity.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import '../../../../l10n/app_localizations.dart';
import '../cubit/contracts_cubit.dart';
import '../cubit/contracts_state.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../../core/events/app_events.dart';
import '../widgets/contracts_total_amount_header.dart';
import '../widgets/contract_review_item_card.dart';

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
      context.read<ContractsCubit>().loadSignatureStatuses(unit.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final unit = widget.unit ?? sl<DesignContextCubit>().state.selectedUnit;
    final totalCost = (unit?.price ?? 0.0) + widget.totalFinishingCost;

    return Scaffold(
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
      body: BlocConsumer<ContractsCubit, ContractsState>(
        listener: _onContractStateListener,
        builder: (context, state) {
          final cubit = context.read<ContractsCubit>();
          final statuses = _resolveSortedStatuses(cubit, unit, l10n);
          final allSigned = statuses.isNotEmpty && statuses.every((s) => s.isSigned);

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              ContractsTotalAmountHeader(totalCost: totalCost),
              const SizedBox(height: AppSpacing.md),
              Text(
                l10n.contractsRequiredForSignature,
                style: TextStyle(fontSize: AppFonts.headlineMedium, fontWeight: FontWeight.bold, color: context.colors.primary),
              ),
              const SizedBox(height: AppSpacing.md),
              ...List.generate(statuses.length, (index) {
                final item = statuses[index];
                final prevSigned = index == 0 || statuses[index - 1].isSigned;
                final isLocked = !item.isSigned && !prevSigned;
                final isItemLoading = (state is BoneContractLoading && item.contractType == 'unit') ||
                    (state is FinishingContractLoading && item.contractType == 'finishing');

                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: ContractReviewItemCard(
                    title: item.title,
                    subtitle: item.contractType == 'unit'
                        ? (unit != null ? l10n.unitDetailsWithArea(unit.title, unit.area.toString()) : l10n.unitDetailsDefault)
                        : l10n.customFinishingComprehensive,
                    sequenceOrder: item.sequenceOrder,
                    isSigned: item.isSigned,
                    isLocked: isLocked,
                    isLoading: isItemLoading,
                    failureMessage: (_partialFailureType == item.contractType) ? _partialFailureMsg : null,
                    onSign: () => _handleSignClick(item, unit),
                  ),
                );
              }),
              const SizedBox(height: AppSpacing.xl),
              CustomButton(
                text: l10n.completeBookingAndPayment,
                onPressed: !allSigned ? null : () => AppToast.showSuccess(context, 'هذه الخاصية ستتوفر قريباً'),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          );
        },
      ),
    );
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
      AppToast.showError(context, state.message);
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
      if (type == ContractType.unit) AppEvents.emitContractSigned(unit.id);
    }
  }

  List<ContractSignatureStatusEntity> _resolveSortedStatuses(ContractsCubit cubit, ProjectUnitEntity? unit, AppLocalizations l10n) {
    if (cubit.contractStatusesList.isNotEmpty) {
      final list = List<ContractSignatureStatusEntity>.from(cubit.contractStatusesList);
      list.sort((a, b) => a.sequenceOrder.compareTo(b.sequenceOrder));
      return list;
    }
    return [
      ContractSignatureStatusEntity(contractType: 'unit', title: l10n.propertySaleContract, sequenceOrder: 1, isSigned: cubit.isUnitContractSigned),
      ContractSignatureStatusEntity(contractType: 'finishing', title: l10n.finishingContract, sequenceOrder: 2, isSigned: cubit.isFinishingContractSigned),
    ];
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
      context.read<ContractsCubit>().createFinishingContract(orderIds: widget.selectedFinishingOrderIds);
    }
  }
}
