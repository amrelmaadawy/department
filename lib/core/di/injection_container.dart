import 'package:apartment/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:apartment/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:apartment/features/auth/domain/repositories/auth_repository.dart';
import 'package:apartment/features/auth/domain/usecases/register_usecase.dart';
import 'package:apartment/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:apartment/features/home/presentation/cubit/home_cubit.dart';
import 'package:apartment/features/layout/presentation/cubit/layout_cubit.dart';
import 'package:apartment/features/projects/presentation/cubit/projects_cubit.dart';
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
  sl.registerFactory(() => AuthCubit(registerUseCase: sl()));
  
  // Use cases
  sl.registerLazySingleton(() => RegisterUseCase(sl()));

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
  sl.registerFactory(() => HomeCubit());

  // Features - Projects
  sl.registerFactory(() => ProjectsCubit());

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
