part of 'project_details_cubit.dart';

abstract class ProjectDetailsState extends Equatable {
  const ProjectDetailsState();

  @override
  List<Object?> get props => [];
}

class ProjectDetailsInitial extends ProjectDetailsState {}

class ProjectDetailsLoading extends ProjectDetailsState {}

class ProjectDetailsLoaded extends ProjectDetailsState {
  final ProjectEntity project;
  final List<String> features;

  const ProjectDetailsLoaded({
    required this.project,
    required this.features,
  });

  @override
  List<Object?> get props => [project, features];
}

class ProjectDetailsError extends ProjectDetailsState {
  final String message;

  const ProjectDetailsError({required this.message});

  @override
  List<Object> get props => [message];
}
