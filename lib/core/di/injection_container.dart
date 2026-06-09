import 'package:apartment/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:apartment/features/home/presentation/cubit/home_cubit.dart';
import 'package:apartment/features/layout/presentation/cubit/layout_cubit.dart';
import 'package:apartment/features/projects/presentation/cubit/projects_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:apartment/features/design_studio/presentation/cubit/design_context_cubit.dart';
import 'package:apartment/core/localization/cubit/locale_cubit.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Features - Auth
  sl.registerFactory(() => AuthCubit());

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
  sl.registerLazySingleton(() => Dio());

  // Locale
  sl.registerLazySingleton(() => LocaleCubit(sharedPreferences: sl()));

  // Features (Blocs, UseCases, Repos, DataSources)
  // ...
}
