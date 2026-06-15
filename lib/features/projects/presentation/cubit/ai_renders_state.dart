import 'package:equatable/equatable.dart';

import '../../domain/entities/ai_renders_entity.dart';

abstract class AiRendersState extends Equatable {
  const AiRendersState();

  @override
  List<Object?> get props => [];
}

class AiRendersInitial extends AiRendersState {}

class AiRendersLoading extends AiRendersState {}

class AiRendersPending extends AiRendersState {
  final AiRendersEntity aiRenders;

  const AiRendersPending({required this.aiRenders});

  @override
  List<Object?> get props => [aiRenders];
}

class AiRendersCompleted extends AiRendersState {
  final AiRendersEntity aiRenders;

  const AiRendersCompleted({required this.aiRenders});

  @override
  List<Object?> get props => [aiRenders];
}

class AiRendersError extends AiRendersState {
  final String message;

  const AiRendersError({required this.message});

  @override
  List<Object?> get props => [message];
}
