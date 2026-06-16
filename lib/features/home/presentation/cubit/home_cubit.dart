import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import '../../domain/entities/project_entity.dart';
import '../../domain/entities/project_service_entity.dart';
import '../../domain/entities/project_unit_entity.dart';
import '../../../../features/projects/domain/usecases/get_projects_usecase.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetProjectsUseCase getProjectsUseCase;

  HomeCubit({required this.getProjectsUseCase}) : super(HomeInitial());

  void loadHomeData() async {
    emit(HomeLoading());

    final result = await getProjectsUseCase();


    result.fold(
      (failure) => emit(HomeLoaded(featuredProjects: const [])), // Or handle error state appropriately
      (projects) {
        // Filter for featured projects only
        final featured = projects.where((p) => p.isFeatured).toList();
        emit(HomeLoaded(featuredProjects: featured));
      },
    );
  }
}
