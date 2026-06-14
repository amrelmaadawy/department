part of 'unit_details_cubit.dart';

abstract class UnitDetailsState extends Equatable {
  final ProjectUnitEntity? unit;
  const UnitDetailsState({this.unit});

  @override
  List<Object?> get props => [unit];
}

class UnitDetailsInitial extends UnitDetailsState {}

class UnitDetailsLoading extends UnitDetailsState {
  const UnitDetailsLoading({super.unit});
}

class UnitDetailsLoaded extends UnitDetailsState {
  const UnitDetailsLoaded({required ProjectUnitEntity unit}) : super(unit: unit);
}

class UnitDetailsError extends UnitDetailsState {
  final String message;
  const UnitDetailsError({required this.message, super.unit});

  @override
  List<Object?> get props => [message, unit];
}
