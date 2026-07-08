import 'package:equatable/equatable.dart';
import '../../domain/entities/finishing_progress_stage_entity.dart';

abstract class FinishingProgressState extends Equatable {
  const FinishingProgressState();

  @override
  List<Object> get props => [];
}

class FinishingProgressInitial extends FinishingProgressState {}

class FinishingProgressLoading extends FinishingProgressState {}

class FinishingProgressLoaded extends FinishingProgressState {
  final List<FinishingProgressStageEntity> stages;
  final int totalProgress;
  final String activeStageName;

  const FinishingProgressLoaded({
    required this.stages,
    required this.totalProgress,
    required this.activeStageName,
  });

  @override
  List<Object> get props => [stages, totalProgress, activeStageName];
}

class FinishingProgressError extends FinishingProgressState {
  final String message;

  const FinishingProgressError(this.message);

  @override
  List<Object> get props => [message];
}
