import 'package:apartment/features/contracts/domain/entities/contract_signature_status_entity.dart';
import 'package:apartment/features/home/domain/entities/project_unit_entity.dart';
import 'package:apartment/features/projects/domain/entities/finishing_edit_eligibility_entity.dart';

/// Determines whether the current user is eligible to edit their finishing
/// selections for a given unit.
///
/// **Business Rules:**
/// 1. The unit must belong to the current user ([ProjectUnitEntity.isCurrentUserUnit]).
/// 2. The unit must have been sold ([UnitStatus.sold]).
/// 3. The finishing contract must not yet be signed.
///    - If no finishing contract exists yet → editing is allowed.
///    - If a finishing contract exists but is not signed → editing is allowed.
///    - If the finishing contract is signed → editing is permanently blocked.
///
/// This UseCase contains no I/O — it is a pure synchronous business rule.
/// All necessary data must be provided by the caller (Cubit / Presenter).
class CheckFinishingEditEligibilityUseCase {
  const CheckFinishingEditEligibilityUseCase();

  /// Returns a [FinishingEditEligibilityEntity] with the result.
  FinishingEditEligibilityEntity call({
    required ProjectUnitEntity unit,
    required List<ContractSignatureStatusEntity> contractStatuses,
  }) {
    // Rule 1: must be the current user's unit
    if (!unit.isCurrentUserUnit) {
      return const FinishingEditEligibilityEntity.blocked(
        FinishingEditBlockReason.notUnitOwner,
      );
    }

    // Rule 2: unit must be sold (i.e. purchased)
    if (unit.status != UnitStatus.sold) {
      return const FinishingEditEligibilityEntity.blocked(
        FinishingEditBlockReason.unitNotSold,
      );
    }

    // Rule 3: finishing contract must not be signed
    final finishingStatus = contractStatuses
        .where((s) => s.contractType == 'finishing')
        .firstOrNull;

    // No finishing contract yet → allowed
    if (finishingStatus == null) {
      return const FinishingEditEligibilityEntity.allowed();
    }

    // Contract exists but not signed → allowed
    if (!finishingStatus.isSigned) {
      return const FinishingEditEligibilityEntity.allowed();
    }

    // Contract signed → permanently blocked
    return const FinishingEditEligibilityEntity.blocked(
      FinishingEditBlockReason.contractAlreadySigned,
    );
  }
}
