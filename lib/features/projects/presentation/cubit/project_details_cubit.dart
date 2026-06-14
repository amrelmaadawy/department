import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';

import '../../../home/domain/entities/project_entity.dart';
import '../../domain/usecases/get_project_details_usecase.dart';
import '../../domain/usecases/get_project_units_usecase.dart';

part 'project_details_state.dart';

class ProjectDetailsCubit extends Cubit<ProjectDetailsState> {
  final GetProjectDetailsUseCase getProjectDetailsUseCase;
  final GetProjectUnitsUseCase getProjectUnitsUseCase;

  ProjectDetailsCubit({
    required this.getProjectDetailsUseCase,
    required this.getProjectUnitsUseCase,
  }) : super(ProjectDetailsInitial());

  void loadProjectDetails(int id) async {
    emit(ProjectDetailsLoading());

    final results = await Future.wait([
      getProjectDetailsUseCase(id),
      getProjectUnitsUseCase(id),
    ]);

    final detailsResult = results[0] as Either;
    final unitsResult = results[1] as Either;

    if (detailsResult.isLeft()) {
      detailsResult.fold(
        (failure) => emit(ProjectDetailsError(message: failure.message)),
        (_) {},
      );
      return;
    }

    if (unitsResult.isLeft()) {
      unitsResult.fold(
        (failure) => emit(ProjectDetailsError(message: failure.message)),
        (_) {},
      );
      return;
    }

    final project = detailsResult.getOrElse(() => throw Exception()) as ProjectEntity;
    final units = unitsResult.getOrElse(() => throw Exception()) as List;

    // Attach units to project
    final projectWithUnits = ProjectEntity(
      id: project.id,
      name: project.name,
      description: project.description,
      location: project.location,
      status: project.status,
      images: project.images,
      apartmentsCount: project.apartmentsCount,
      units: List.from(units),
    );

    // Parse description into amenities based on line breaks
    List<String> amenities = [];
    if (projectWithUnits.description.isNotEmpty) {
      amenities = projectWithUnits.description
          .split(RegExp(r'\r\n|\n'))
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
    }

    emit(ProjectDetailsLoaded(
      project: projectWithUnits,
      parsedAmenities: amenities,
    ));
  }
}
