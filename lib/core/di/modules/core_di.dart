import 'package:get_it/get_it.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:apartment/core/network/network_info.dart';
import 'package:apartment/core/network/dio_factory.dart';

import 'package:apartment/core/network/api_client.dart';
import 'package:apartment/core/network/api_endpoints.dart';
import 'package:apartment/core/network/interceptors/auth_interceptor.dart';
import 'package:apartment/core/network/interceptors/error_interceptor.dart';
import 'package:apartment/core/network/interceptors/secure_logging_interceptor.dart';
import 'package:apartment/core/localization/cubit/locale_cubit.dart';
import 'package:apartment/core/theme/cubit/theme_cubit.dart';
import 'package:apartment/core/network/cubit/network_cubit.dart';
import 'package:apartment/core/services/share/share_service.dart';
import 'package:apartment/core/services/share/share_service_impl.dart';
import 'package:apartment/core/services/download/download_service.dart';
import 'package:apartment/core/services/security/token_rotation_service.dart';
import 'package:apartment/core/services/security/biometric_auth_service.dart';
import 'package:apartment/core/services/analytics/analytics_service.dart';
import 'package:apartment/core/services/pdf/pdf_generator_service.dart';

import 'package:apartment/features/home/presentation/cubit/home_cubit.dart';
import 'package:apartment/features/layout/presentation/cubit/layout_cubit.dart';
import 'package:apartment/features/design_studio/presentation/cubit/design_context_cubit.dart';
import 'package:apartment/features/projects/domain/usecases/get_customization_draft_use_case.dart';
import 'package:apartment/features/projects/domain/usecases/save_customization_draft_use_case.dart';
import 'package:apartment/features/projects/data/datasources/local/room_design_cache_service.dart';

Future<void> registerCoreDi(GetIt sl) async {
  // Core Data & Services
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => RoomDesignCacheService(sharedPreferences: sl()));
  sl.registerLazySingleton(() => const FlutterSecureStorage(
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
  ));
  sl.registerLazySingleton<IShareService>(() => ShareServiceImpl(dio: sl()));
  sl.registerLazySingleton<IDownloadService>(() => DownloadServiceImpl(dio: sl()));
  sl.registerLazySingleton(() => TokenRotationService(secureStorage: sl()));
  sl.registerLazySingleton(() => BiometricAuthService());
  sl.registerLazySingleton<AnalyticsService>(() => AppAnalyticsService());
  sl.registerLazySingleton<IPdfGeneratorService>(() => PdfGeneratorServiceImpl());

  // Network Monitoring
  sl.registerLazySingleton(() => Connectivity());
  sl.registerLazySingleton(() => InternetConnection());
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl(), sl()),
  );

  // Network Interceptors
  sl.registerLazySingleton(() => AuthInterceptor(secureStorage: sl(), tokenRotationService: sl()));
  sl.registerLazySingleton(() => ErrorInterceptor());
  sl.registerLazySingleton(() => SecureLoggingInterceptor());
  
  // Network Dio
  sl.registerLazySingleton(
    () {
      final dio = DioFactory.createDio(
        RequestType.fetch, 
        baseUrl: ApiEndpoints.baseUrl,
      );
      dio.interceptors.addAll([
        sl<AuthInterceptor>(),
        sl<ErrorInterceptor>(),
        if (kDebugMode) sl<SecureLoggingInterceptor>(),
      ]);
      return dio;
    },
  );

  // Network API Client
  sl.registerLazySingleton(() => ApiClient(dio: sl()));

  // Core Cubits (Locale, Theme, Network)
  sl.registerLazySingleton(() => LocaleCubit(sharedPreferences: sl()));
  sl.registerLazySingleton(() => ThemeCubit(sharedPreferences: sl()));
  sl.registerFactory(() => NetworkCubit(sl()));

  // Feature Cubits (Layout, Home, Design Studio)
  sl.registerFactory(() => LayoutCubit());
  sl.registerFactory(() => HomeCubit(getProjectsUseCase: sl()));
  sl.registerLazySingleton(() => DesignContextCubit(
    getDraftUseCase: sl.isRegistered<GetCustomizationDraftUseCase>() ? sl() : null,
    saveDraftUseCase: sl.isRegistered<SaveCustomizationDraftUseCase>() ? sl() : null,
    cacheService: sl.isRegistered<RoomDesignCacheService>() ? sl() : null,
  ));
}
