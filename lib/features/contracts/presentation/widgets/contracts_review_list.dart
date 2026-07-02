import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../../features/home/domain/entities/project_unit_entity.dart';
import 'package:apartment/core/theme/theme_extension.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/contract_signature_status_entity.dart';
import '../cubit/contracts_cubit.dart';
import '../cubit/contracts_state.dart';
import '../cubit/contract_print_cubit.dart';
import 'contracts_total_amount_header.dart';
import 'contract_review_item_card.dart';

class ContractsReviewList extends StatelessWidget {
  final double totalCost;
  final ProjectUnitEntity? unit;
  final AppLocalizations l10n;
  final ContractsCubit cubit;
  final ContractsState state;
  final String? partialFailureType;
  final String? partialFailureMsg;
  final Function(ContractSignatureStatusEntity, ProjectUnitEntity?) onSignClick;

  const ContractsReviewList({
    super.key,
    required this.totalCost,
    required this.unit,
    required this.l10n,
    required this.cubit,
    required this.state,
    required this.partialFailureType,
    required this.partialFailureMsg,
    required this.onSignClick,
  });

  List<ContractSignatureStatusEntity> _resolveStatuses() {
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

  @override
  Widget build(BuildContext context) {
    final statuses = _resolveStatuses();
    final allSigned = statuses.isNotEmpty && statuses.every((s) => s.isSigned);

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        ContractsTotalAmountHeader(totalCost: totalCost),
        const SizedBox(height: AppSpacing.md),
        Text(
          l10n.contractsRequiredForSignature,
          style: TextStyle(
            fontSize: AppFonts.headlineMedium,
            fontWeight: FontWeight.bold,
            color: context.colors.primary,
          ),
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
                  ? (unit != null ? l10n.unitDetailsWithArea(unit!.title, unit!.area.toString()) : l10n.unitDetailsDefault)
                  : l10n.customFinishingComprehensive,
              sequenceOrder: item.sequenceOrder,
              isSigned: item.isSigned,
              isLocked: isLocked,
              isLoading: isItemLoading,
              failureMessage: (partialFailureType == item.contractType) ? partialFailureMsg : null,
              onSign: () => onSignClick(item, unit),
              onPrint: () {
                if (unit == null) return;
                final aptId = int.tryParse(unit!.id) ?? 0;
                if (item.contractType == 'unit') {
                  context.read<ContractPrintCubit>().fetchAndPrepareBoneContract(aptId);
                } else {
                  context.read<ContractPrintCubit>().fetchAndPrepareFinishingContract(aptId);
                }
              },
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
  }
}
