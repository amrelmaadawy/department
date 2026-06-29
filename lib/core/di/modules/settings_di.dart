import 'package:get_it/get_it.dart';
import '../../../features/settings/data/datasources/settings_local_datasource.dart';
import '../../../features/settings/data/datasources/settings_remote_datasource.dart';
import '../../../features/settings/data/repositories/settings_repository_impl.dart';
import '../../../features/settings/domain/repositories/settings_repository.dart';
import '../../../features/settings/domain/usecases/get_general_settings_usecase.dart';
import '../../../features/settings/presentation/cubit/settings_cubit.dart';

Future<void> registerSettingsDi(GetIt sl) async {
  // Cubits
  sl.registerFactory(
    () => SettingsCubit(getGeneralSettingsUseCase: sl()),
  );

  // UseCases
  sl.registerLazySingleton(
    () => GetGeneralSettingsUseCase(repository: sl()),
  );

  // Repositories
  sl.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // DataSources
  sl.registerLazySingleton<SettingsRemoteDataSource>(
    () => SettingsRemoteDataSourceImpl(apiClient: sl()),
  );
  sl.registerLazySingleton<SettingsLocalDataSource>(
    () => SettingsLocalDataSourceImpl(sharedPreferences: sl()),
  );
}
