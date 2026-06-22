part of 'unit_details_cubit.dart';

abstract class UnitDetailsState extends Equatable {
  final ProjectUnitEntity? unit;
  final double totalFinishingCost;
  final Map<int, double> roomCosts;
  final Set<int> completedRoomIds;
  final List<RoomCustomerRendersEntity> customerRenders;
  
  const UnitDetailsState({
    this.unit, 
    this.totalFinishingCost = 0.0,
    this.roomCosts = const {},
    this.completedRoomIds = const {},
    this.customerRenders = const [],
  });

  @override
  List<Object?> get props => [unit, totalFinishingCost, roomCosts, completedRoomIds, customerRenders];
}

class UnitDetailsInitial extends UnitDetailsState {}

class UnitDetailsLoading extends UnitDetailsState {
  const UnitDetailsLoading({super.unit, super.totalFinishingCost, super.roomCosts, super.completedRoomIds, super.customerRenders});
}

class UnitDetailsLoaded extends UnitDetailsState {
  const UnitDetailsLoaded({required ProjectUnitEntity unit, super.totalFinishingCost, super.roomCosts, super.completedRoomIds, super.customerRenders}) : super(unit: unit);
}

class UnitDetailsError extends UnitDetailsState {
  final String message;
  const UnitDetailsError({required this.message, super.unit, super.totalFinishingCost, super.roomCosts, super.completedRoomIds, super.customerRenders});

  @override
  List<Object?> get props => [message, unit, totalFinishingCost, roomCosts, completedRoomIds, customerRenders];
}
