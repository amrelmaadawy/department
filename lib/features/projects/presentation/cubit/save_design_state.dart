import 'package:equatable/equatable.dart';
import '../../domain/entities/saved_design_entity.dart';

abstract class SaveDesignState extends Equatable {
  const SaveDesignState();

  @override
  List<Object> get props => [];
}

class SaveDesignInitial extends SaveDesignState {}

class SaveDesignLoading extends SaveDesignState {}

class SaveDesignSuccess extends SaveDesignState {
  final SavedDesignEntity savedDesign;

  const SaveDesignSuccess({required this.savedDesign});

  @override
  List<Object> get props => [savedDesign];
}

class SaveDesignError extends SaveDesignState {
  final String message;

  const SaveDesignError({required this.message});

  @override
  List<Object> get props => [message];
}
