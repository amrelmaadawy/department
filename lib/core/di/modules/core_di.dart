import 'package:get_it/get_it.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';

import 'package:apartment/core/network/api_client.dart';
import 'package:apartment/core/network/api_endpoints.dart';
import 'package:apartment/core/network/interceptors/auth_interceptor.dart';
import 'package:apartment/core/network/interceptors/error_interceptor.dart';
import 'package:apartment/core/network/interceptors/logging_interceptor.dart';
import 'package:apartment/core/localization/cubit/locale_cubit.dart';
import 'package:apartment/core/theme/cubit/theme_cubit.dart';
import 'package:apartment/core/services/share/share_service.dart';
import 'package:apartment/core/services/share/share_service_impl.dart';
import 'package:apartment/core/services/download/download_service.dart';

import 'package:apartment/features/home/presentation/cubit/home_cubit.dart';
import 'package:apartment/features/layout/presentation/cubit/layout_cubit.dart';
import 'package:apartment/features/design_studio/presentation/cubit/design_context_cubit.dart';
import 'package:apartment/features/projects/data/datasources/local/room_design_cache_service.dart';

Future<void> registerCoreDi(GetIt sl) async {
  // Features - Layout & Home & Design Studio
  sl.registerFactory(() => LayoutCubit());
  sl.registerFactory(() => HomeCubit(getProjectsUseCase: sl()));
  sl.registerLazySingleton(() => DesignContextCubit());

  // Core Data & Services
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => RoomDesignCacheService(sharedPreferences: sl()));
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  sl.registerLazySingleton<IShareService>(() => ShareServiceImpl(dio: sl()));
  sl.registerLazySingleton<IDownloadService>(() => DownloadServiceImpl(dio: sl()));

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

  // Locale & Theme
  sl.registerLazySingleton(() => LocaleCubit(sharedPreferences: sl()));
  sl.registerLazySingleton(() => ThemeCubit(sharedPreferences: sl()));
}
