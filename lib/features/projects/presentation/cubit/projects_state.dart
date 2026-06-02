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

  const ProjectsLoaded({
    required this.allProjects,
    required this.filteredProjects,
    required this.selectedFilter,
  });

  @override
  List<Object> get props => [allProjects, filteredProjects, selectedFilter];
}

class ProjectsError extends ProjectsState {
  final String message;

  const ProjectsError({required this.message});

  @override
  List<Object> get props => [message];
}
