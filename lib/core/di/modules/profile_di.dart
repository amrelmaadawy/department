import 'package:get_it/get_it.dart';

import 'package:apartment/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:apartment/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:apartment/features/profile/domain/repositories/profile_repository.dart';
import 'package:apartment/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:apartment/features/profile/domain/usecases/toggle_favorite_design_usecase.dart';
import 'package:apartment/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:apartment/features/profile/presentation/cubit/profile_cubit.dart';

Future<void> registerProfileDi(GetIt sl) async {
  // Cubit
  sl.registerLazySingleton(() => ProfileCubit(
    getProfileUseCase: sl(),
    toggleFavoriteDesignUseCase: sl(),
    updateProfileUseCase: sl(),
  ));

  // Use Cases
  sl.registerLazySingleton(() => GetProfileUseCase(sl()));
  sl.registerLazySingleton(() => ToggleFavoriteDesignUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProfileUseCase(sl()));

  // Repository
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(remoteDataSource: sl()),
  );

  // Data Source
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(apiClient: sl()),
  );
}
