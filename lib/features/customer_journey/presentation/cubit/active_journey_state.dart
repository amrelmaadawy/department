import 'package:equatable/equatable.dart';
import '../../domain/entities/active_journey_entity.dart';

abstract class ActiveJourneyState extends Equatable {
  const ActiveJourneyState();

  @override
  List<Object?> get props => [];
}

class ActiveJourneyInitial extends ActiveJourneyState {}

class ActiveJourneyLoading extends ActiveJourneyState {}

class ActiveJourneyLoaded extends ActiveJourneyState {
  final List<ActiveJourneyEntity> journeys;

  const ActiveJourneyLoaded(this.journeys);

  @override
  List<Object?> get props => [journeys];
}

class ActiveJourneyError extends ActiveJourneyState {
  final String message;

  const ActiveJourneyError(this.message);

  @override
  List<Object?> get props => [message];
}
