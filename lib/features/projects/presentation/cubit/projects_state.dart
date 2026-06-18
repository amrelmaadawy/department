part of 'projects_cubit.dart';

abstract class ProjectsState extends Equatable {
  const ProjectsState();

  @override
  List<Object> get props => [];
}

class ProjectsInitial extends ProjectsState {}

class ProjectsLoading extends ProjectsState {}

class ProjectsLoaded extends ProjectsState {
  final List<ProjectEntity> allProjects;
  final List<ProjectEntity> filteredProjects;
  final String selectedFilter;
  final List<String> availableCities;

  const ProjectsLoaded({
    required this.allProjects,
    required this.filteredProjects,
    required this.selectedFilter,
    required this.availableCities,
  });

  @override
  List<Object> get props => [allProjects, filteredProjects, selectedFilter, availableCities];
}

class ProjectsError extends ProjectsState {
  final String message;

  const ProjectsError({required this.message});

  @override
  List<Object> get props => [message];
}


