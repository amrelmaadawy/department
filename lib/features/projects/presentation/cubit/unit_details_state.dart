part of 'unit_details_cubit.dart';

abstract class UnitDetailsState extends Equatable {
  final ProjectUnitEntity? unit;
  final double totalFinishingCost;
  final Set<int> completedRoomIds;
  
  const UnitDetailsState({
    this.unit, 
    this.totalFinishingCost = 0.0,
    this.completedRoomIds = const {},
  });

  @override
  List<Object?> get props => [unit, totalFinishingCost, completedRoomIds];
}

class UnitDetailsInitial extends UnitDetailsState {}

class UnitDetailsLoading extends UnitDetailsState {
  const UnitDetailsLoading({super.unit, super.totalFinishingCost, super.completedRoomIds});
}

class UnitDetailsLoaded extends UnitDetailsState {
  const UnitDetailsLoaded({required ProjectUnitEntity unit, super.totalFinishingCost, super.completedRoomIds}) : super(unit: unit);
}

class UnitDetailsError extends UnitDetailsState {
  final String message;
  const UnitDetailsError({required this.message, super.unit, super.totalFinishingCost, super.completedRoomIds});

  @override
  List<Object?> get props => [message, unit, totalFinishingCost, completedRoomIds];
}
