import 'package:apartment/core/network/app_cancel_token.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/project_entity.dart';
import '../../../../features/projects/domain/usecases/get_projects_usecase.dart';

part 'home_state.dart';


class HomeCubit extends Cubit<HomeState> {
  final GetProjectsUseCase getProjectsUseCase;
  final AppCancelToken _cancelToken = AppCancelToken();

  HomeCubit({required this.getProjectsUseCase}) : super(HomeInitial());

  Future<void> loadHomeData() async {
    emit(HomeLoading());

    final result = await getProjectsUseCase(cancelToken: _cancelToken);

    result.fold(
      (failure) => emit(HomeError(message: failure.message)),
      (projects) {
        // Filter for featured projects only
        final featured = projects.where((p) => p.isFeatured).toList();
        emit(HomeLoaded(featuredProjects: featured));
      },
    );
  }

  @override
  Future<void> close() {
    _cancelToken.cancel('HomeCubit closed');
    return super.close();
  }
}
