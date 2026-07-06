import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';

import '../../../home/domain/entities/project_entity.dart';
import '../../../home/domain/entities/project_unit_entity.dart';
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
    _contractSignedSubscription = AppEvents.onContractSigned.listen((unitId) {
      if (!isClosed && state is ProjectDetailsLoaded) {
        final currentState = state as ProjectDetailsLoaded;
        final updatedUnits = currentState.project.units.map((u) {
          if (u.id == unitId || u.id.toString() == unitId) {
            return u.copyWith(
              status: UnitStatus.owned,
              statusLabel: 'مملوكة',
              isCurrentUserUnit: true,
            );
          }
          return u;
        }).toList();

        final updatedProject = currentState.project.copyWith(units: updatedUnits);
        emit(ProjectDetailsLoaded(
          project: updatedProject,
          features: currentState.features,
        ));
      }
      
      // Still reload in background to get accurate data, but silently
      if (_currentProjectId != null && !isClosed) {
        _silentReloadProjectDetails(_currentProjectId!);
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
    final unitsList = unitsResult.getOrElse(() => throw Exception()) as List;
    final units = unitsList.map((u) {
      if (u is ProjectUnitEntity) {
        return u.projectName.isNotEmpty ? u : u.copyWith(projectName: project.name);
      }
      return u;
    }).toList();

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
      units: List<ProjectUnitEntity>.from(units),
    );

    if (!isClosed) {
      emit(ProjectDetailsLoaded(
        project: projectWithUnits,
        features: projectWithUnits.features,
      ));
    }
  }

  void _silentReloadProjectDetails(int id) async {
    final results = await Future.wait([
      getProjectDetailsUseCase(id),
      getProjectUnitsUseCase(id),
    ]);

    final detailsResult = results[0] as Either;
    final unitsResult = results[1] as Either;

    if (detailsResult.isLeft() || unitsResult.isLeft()) return;

    final project = detailsResult.getOrElse(() => throw Exception()) as ProjectEntity;
    final unitsList = unitsResult.getOrElse(() => throw Exception()) as List;
    final units = unitsList.map((u) {
      if (u is ProjectUnitEntity) {
        return u.projectName.isNotEmpty ? u : u.copyWith(projectName: project.name);
      }
      return u;
    }).toList();

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
      units: List<ProjectUnitEntity>.from(units),
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
