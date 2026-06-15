part of 'unit_details_cubit.dart';

abstract class UnitDetailsState extends Equatable {
  final ProjectUnitEntity? unit;
  final double totalFinishingCost;
  const UnitDetailsState({this.unit, this.totalFinishingCost = 0.0});

  @override
  List<Object?> get props => [unit, totalFinishingCost];
}

class UnitDetailsInitial extends UnitDetailsState {}

class UnitDetailsLoading extends UnitDetailsState {
  const UnitDetailsLoading({super.unit, super.totalFinishingCost});
}

class UnitDetailsLoaded extends UnitDetailsState {
  const UnitDetailsLoaded({required ProjectUnitEntity unit, super.totalFinishingCost}) : super(unit: unit);
}

class UnitDetailsError extends UnitDetailsState {
  final String message;
  const UnitDetailsError({required this.message, super.unit, super.totalFinishingCost});

  @override
  List<Object?> get props => [message, unit, totalFinishingCost];
}
