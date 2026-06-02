import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/project_entity.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  void loadHomeData() async {
    emit(HomeLoading());
    
    // Simulate API delay for Shimmer effect
    await Future.delayed(const Duration(seconds: 2));

    // Dummy data using the generated AI images
    final projects = [
      const ProjectEntity(
        id: '1',
        name: 'أثير ريزيدنس',
        location: 'الرياض - الياسمين',
        startingPrice: 650000,
        imagePath: 'assets/images/project_one_mock.png',
      ),
      const ProjectEntity(
        id: '2',
        name: 'ريان هايتس',
        location: 'الرياض - النرجس',
        startingPrice: 720000,
        imagePath: 'assets/images/project_two_mock.png',
      ),
    ];

    emit(HomeLoaded(featuredProjects: projects));
  }
}
