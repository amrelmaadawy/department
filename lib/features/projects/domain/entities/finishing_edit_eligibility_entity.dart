import 'package:equatable/equatable.dart';

/// Reasons why a user may be blocked from editing finishing selections.
enum FinishingEditBlockReason {
  /// The unit does not belong to the current logged-in user.
  notUnitOwner,

  /// The unit has not been sold yet, so there is nothing to finish.
  unitNotSold,

  /// The finishing contract has already been signed — edits are locked.
  contractAlreadySigned,
}

/// Encapsulates the result of the eligibility check for editing finishing.
class FinishingEditEligibilityEntity extends Equatable {
  /// Whether the current user is allowed to edit the finishing selections.
  final bool canEdit;

  /// The reason editing is blocked; null when [canEdit] is true.
  final FinishingEditBlockReason? blockReason;

  const FinishingEditEligibilityEntity({
    required this.canEdit,
    this.blockReason,
  });

  /// Shorthand constructor for an allowed edit.
  const FinishingEditEligibilityEntity.allowed()
      : canEdit = true,
        blockReason = null;

  /// Shorthand constructor for a blocked edit with an explicit reason.
  const FinishingEditEligibilityEntity.blocked(FinishingEditBlockReason reason)
      : canEdit = false,
        blockReason = reason;

  @override
  List<Object?> get props => [canEdit, blockReason];
}
