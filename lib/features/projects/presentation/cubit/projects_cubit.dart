import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/network/app_cancel_token.dart';
import '../../../home/domain/entities/project_entity.dart';
import '../../domain/usecases/get_projects_usecase.dart';

part 'projects_state.dart';

class ProjectsCubit extends Cubit<ProjectsState> {
  final GetProjectsUseCase getProjectsUseCase;

  ProjectsCubit({required this.getProjectsUseCase}) : super(ProjectsInitial());

  final AppCancelToken _cancelToken = AppCancelToken();

  List<ProjectEntity> _allProjects = [];
  String _currentFilter = AppConstants.filterAll;
  String _currentSearchQuery = '';

  void loadProjects() async {
    emit(ProjectsLoading());

    final result = await getProjectsUseCase(cancelToken: _cancelToken);

    result.fold(
      (failure) => emit(ProjectsError(message: failure.message)), // Needs ProjectsError in state
      (projects) {
        _allProjects = projects;
        emit(
          ProjectsLoaded(
            allProjects: _allProjects,
            filteredProjects: _allProjects,
            selectedFilter: _currentFilter,
            availableCities: _availableCities,
          ),
        );
      },
    );
  }

  void filterByCity(String city) {
    _currentFilter = city;
    _applyFilters();
  }

  void searchProjects(String query) {
    _currentSearchQuery = query.toLowerCase();
    _applyFilters();
  }

  List<String> get _availableCities {
    final cities = _allProjects.map((p) => p.city).where((c) => c.isNotEmpty).toSet().toList();
    cities.sort();
    return cities;
  }

  void _applyFilters() {
    if (state is! ProjectsLoaded) return;

    List<ProjectEntity> filtered = _allProjects;

    // Apply city filter
    if (_currentFilter != AppConstants.filterAll) {
      filtered = filtered
          .where((p) => p.city == _currentFilter)
          .toList();
    }

    // Apply search query
    if (_currentSearchQuery.isNotEmpty) {
      filtered = filtered.where((p) {
        return p.name.toLowerCase().contains(_currentSearchQuery) ||
            p.location.toLowerCase().contains(_currentSearchQuery);
      }).toList();
    }

    emit(
      ProjectsLoaded(
        allProjects: _allProjects,
        filteredProjects: filtered,
        selectedFilter: _currentFilter,
        availableCities: _availableCities,
      ),
    );
  }

  @override
  Future<void> close() {
    _cancelToken.cancel('ProjectsCubit closed');
    return super.close();
  }
}
