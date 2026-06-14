import 'package:apartment/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:apartment/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:apartment/features/auth/domain/repositories/auth_repository.dart';
import 'package:apartment/features/auth/domain/usecases/login_usecase.dart';
import 'package:apartment/features/auth/domain/usecases/logout_usecase.dart';
import 'package:apartment/features/auth/domain/usecases/register_usecase.dart';
import 'package:apartment/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:apartment/features/home/presentation/cubit/home_cubit.dart';
import 'package:apartment/features/layout/presentation/cubit/layout_cubit.dart';
import 'package:apartment/features/projects/data/datasources/project_remote_data_source.dart';
import 'package:apartment/features/projects/data/repositories/project_repository_impl.dart';
import 'package:apartment/features/projects/domain/repositories/project_repository.dart';
import 'package:apartment/features/projects/domain/usecases/get_projects_usecase.dart';
import 'package:apartment/features/projects/domain/usecases/get_project_details_usecase.dart';
import 'package:apartment/features/projects/domain/usecases/get_project_units_usecase.dart';
import 'package:apartment/features/projects/domain/usecases/get_unit_details_usecase.dart';
import 'package:apartment/features/projects/presentation/cubit/project_details_cubit.dart';
import 'package:apartment/features/projects/presentation/cubit/projects_cubit.dart';
import 'package:apartment/features/projects/presentation/cubit/unit_details_cubit.dart';
import 'package:apartment/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:apartment/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:apartment/features/profile/domain/repositories/profile_repository.dart';
import 'package:apartment/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:apartment/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:apartment/features/design_studio/presentation/cubit/design_context_cubit.dart';
import 'package:apartment/core/localization/cubit/locale_cubit.dart';
import 'package:apartment/core/theme/cubit/theme_cubit.dart';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';

import '../network/api_client.dart';
import '../network/api_endpoints.dart';
import '../network/interceptors/auth_interceptor.dart';
import '../network/interceptors/error_interceptor.dart';
import '../network/interceptors/logging_interceptor.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Features - Auth
  sl.registerFactory(
    () => AuthCubit(
      registerUseCase: sl(),
      loginUseCase: sl(),
      logoutUseCase: sl(),
    ),
  );
  
  // Use cases
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      secureStorage: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiClient: sl()),
  );

  // Features - Layout
  sl.registerFactory(() => LayoutCubit());

  // Features - Home
  sl.registerFactory(() => HomeCubit(getProjectsUseCase: sl()));

  // Features - Projects
  sl.registerFactory(() => ProjectsCubit(getProjectsUseCase: sl()));
  sl.registerFactory(
    () => ProjectDetailsCubit(
      getProjectDetailsUseCase: sl(),
      getProjectUnitsUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => UnitDetailsCubit(
      getUnitDetailsUseCase: sl(),
    ),
  );
  sl.registerLazySingleton(() => GetProjectsUseCase(sl()));
  sl.registerLazySingleton(() => GetProjectDetailsUseCase(sl()));
  sl.registerLazySingleton(() => GetProjectUnitsUseCase(sl()));
  sl.registerLazySingleton(() => GetUnitDetailsUseCase(sl()));
  sl.registerLazySingleton<ProjectRepository>(
    () => ProjectRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<ProjectRemoteDataSource>(
    () => ProjectRemoteDataSourceImpl(apiClient: sl()),
  );

  // Features - Profile
  sl.registerFactory(() => ProfileCubit(getProfileUseCase: sl()));
  sl.registerLazySingleton(() => GetProfileUseCase(sl()));
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(apiClient: sl()),
  );

  // Features - Design Studio (Singleton to preserve context across flow)
  sl.registerLazySingleton(() => DesignContextCubit());

  // Core Data
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => const FlutterSecureStorage());

  // Network
  sl.registerLazySingleton(() => AuthInterceptor(secureStorage: sl()));
  sl.registerLazySingleton(() => ErrorInterceptor());
  sl.registerLazySingleton(() => LoggingInterceptor());
  
  sl.registerLazySingleton(
    () {
      final dio = Dio(
        BaseOptions(
          baseUrl: ApiEndpoints.baseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      );
      dio.interceptors.addAll([
        sl<AuthInterceptor>(),
        sl<ErrorInterceptor>(),
        if (kDebugMode) sl<LoggingInterceptor>(),
      ]);
      return dio;
    },
  );

  sl.registerLazySingleton(() => ApiClient(dio: sl()));

  // Locale
  sl.registerLazySingleton(() => LocaleCubit(sharedPreferences: sl()));

  // Theme
  sl.registerLazySingleton(() => ThemeCubit(sharedPreferences: sl()));

  // Features (Blocs, UseCases, Repos, DataSources)
  // ...
}
