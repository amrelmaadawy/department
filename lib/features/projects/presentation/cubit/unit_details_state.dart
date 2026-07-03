part of 'unit_details_cubit.dart';

// ignore_for_file: avoid_equals_and_hash_code_on_mutable_classes

abstract class UnitDetailsState extends Equatable {
  final ProjectUnitEntity? unit;
  final double totalFinishingCost;
  final Map<int, double> roomCosts;
  final Set<int> completedRoomIds;
  final List<RoomCustomerRendersEntity> customerRenders;

  /// Whether the current user may edit finishing selections.
  /// Defaults to false (safe — deny until proven otherwise).
  final bool canEditFinishing;

  /// The reason edits are blocked; null when [canEditFinishing] is true.
  final FinishingEditBlockReason? editBlockReason;

  const UnitDetailsState({
    this.unit,
    this.totalFinishingCost = 0.0,
    this.roomCosts = const {},
    this.completedRoomIds = const {},
    this.customerRenders = const [],
    this.canEditFinishing = false,
    this.editBlockReason,
  });

  @override
  List<Object?> get props => [
        unit,
        totalFinishingCost,
        roomCosts,
        completedRoomIds,
        customerRenders,
        canEditFinishing,
        editBlockReason,
      ];
}

class UnitDetailsInitial extends UnitDetailsState {}

class UnitDetailsLoading extends UnitDetailsState {
  const UnitDetailsLoading({
    super.unit,
    super.totalFinishingCost,
    super.roomCosts,
    super.completedRoomIds,
    super.customerRenders,
    super.canEditFinishing,
    super.editBlockReason,
  });
}

class UnitDetailsLoaded extends UnitDetailsState {
  const UnitDetailsLoaded({
    required ProjectUnitEntity unit,
    super.totalFinishingCost,
    super.roomCosts,
    super.completedRoomIds,
    super.customerRenders,
    super.canEditFinishing,
    super.editBlockReason,
  }) : super(unit: unit);
}

class UnitDetailsError extends UnitDetailsState {
  final String message;
  const UnitDetailsError({
    required this.message,
    super.unit,
    super.totalFinishingCost,
    super.roomCosts,
    super.completedRoomIds,
    super.customerRenders,
    super.canEditFinishing,
    super.editBlockReason,
  });

  @override
  List<Object?> get props => [
        message,
        unit,
        totalFinishingCost,
        roomCosts,
        completedRoomIds,
        customerRenders,
        canEditFinishing,
        editBlockReason,
      ];
}
