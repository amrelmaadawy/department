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
  final List<String> parsedAmenities;

  const ProjectDetailsLoaded({
    required this.project,
    required this.parsedAmenities,
  });

  @override
  List<Object?> get props => [project, parsedAmenities];
}

class ProjectDetailsError extends ProjectDetailsState {
  final String message;

  const ProjectDetailsError({required this.message});

  @override
  List<Object> get props => [message];
}
