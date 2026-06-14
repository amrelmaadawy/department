import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../home/domain/entities/project_entity.dart';
import '../../domain/usecases/get_project_details_usecase.dart';

part 'project_details_state.dart';

class ProjectDetailsCubit extends Cubit<ProjectDetailsState> {
  final GetProjectDetailsUseCase getProjectDetailsUseCase;

  ProjectDetailsCubit({required this.getProjectDetailsUseCase}) : super(ProjectDetailsInitial());

  void loadProjectDetails(int id) async {
    emit(ProjectDetailsLoading());

    final result = await getProjectDetailsUseCase(id);

    result.fold(
      (failure) => emit(ProjectDetailsError(message: failure.message)),
      (project) {
        // Parse description into amenities based on line breaks
        List<String> amenities = [];
        if (project.description.isNotEmpty) {
          amenities = project.description
              .split(RegExp(r'\r\n|\n'))
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList();
        }

        emit(ProjectDetailsLoaded(
          project: project,
          parsedAmenities: amenities,
        ));
      },
    );
  }
}
