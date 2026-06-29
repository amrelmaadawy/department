import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';

import '../../../home/domain/entities/project_entity.dart';
import '../../domain/usecases/get_project_details_usecase.dart';
import '../../domain/usecases/get_project_units_usecase.dart';

import '../../../../core/events/app_events.dart';
import 'dart:async';

part 'project_details_state.dart';

class ProjectDetailsCubit extends Cubit<ProjectDetailsState> {
  final GetProjectDetailsUseCase getProjectDetailsUseCase;
  final GetProjectUnitsUseCase getProjectUnitsUseCase;

  StreamSubscription? _contractSignedSubscription;
  int? _currentProjectId;

  ProjectDetailsCubit({
    required this.getProjectDetailsUseCase,
    required this.getProjectUnitsUseCase,
  }) : super(ProjectDetailsInitial()) {
    _contractSignedSubscription = AppEvents.onContractSigned.listen((_) {
      if (_currentProjectId != null) {
        loadProjectDetails(_currentProjectId!);
      }
    });
  }

  void loadProjectDetails(int id) async {
    _currentProjectId = id;
    emit(ProjectDetailsLoading());

    final results = await Future.wait([
      getProjectDetailsUseCase(id),
      getProjectUnitsUseCase(id),
    ]);

    final detailsResult = results[0] as Either;
    final unitsResult = results[1] as Either;

    if (detailsResult.isLeft()) {
      detailsResult.fold(
        (failure) {
          if (!isClosed) emit(ProjectDetailsError(message: failure.message));
        },
        (_) {},
      );
      return;
    }

    if (unitsResult.isLeft()) {
      unitsResult.fold(
        (failure) {
          if (!isClosed) emit(ProjectDetailsError(message: failure.message));
        },
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
      buildingArea: project.buildingArea,
      startingPrice: project.startingPrice,
      features: project.features,
      isFeatured: project.isFeatured,
      totalArea: project.totalArea,
      unitTypes: project.unitTypes,
      deliveryDate: project.deliveryDate,
      finishingType: project.finishingType,
      services: project.services,
      units: List.from(units),
    );

    if (!isClosed) {
      emit(ProjectDetailsLoaded(
        project: projectWithUnits,
        features: projectWithUnits.features,
      ));
    }
  }

  @override
  Future<void> close() {
    _contractSignedSubscription?.cancel();
    return super.close();
  }
}
