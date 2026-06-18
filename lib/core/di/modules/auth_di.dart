import 'package:get_it/get_it.dart';

import 'package:apartment/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:apartment/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:apartment/features/auth/domain/repositories/auth_repository.dart';
import 'package:apartment/features/auth/domain/usecases/login_usecase.dart';
import 'package:apartment/features/auth/domain/usecases/logout_usecase.dart';
import 'package:apartment/features/auth/domain/usecases/register_usecase.dart';
import 'package:apartment/features/auth/presentation/cubit/auth_cubit.dart';

Future<void> registerAuthDi(GetIt sl) async {
  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiClient: sl()),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      secureStorage: sl(),
      sharedPreferences: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));

  // Cubit
  sl.registerFactory(
    () => AuthCubit(
      registerUseCase: sl(),
      loginUseCase: sl(),
      logoutUseCase: sl(),
    ),
  );
}
