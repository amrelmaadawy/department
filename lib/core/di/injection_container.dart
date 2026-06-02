import 'package:apartment/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:apartment/features/home/presentation/cubit/home_cubit.dart';
import 'package:apartment/features/layout/presentation/cubit/layout_cubit.dart';
import 'package:get_it/get_it.dart';

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
  
  // Core Data
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  
  // Network
  sl.registerLazySingleton(() => Dio());

  // Features (Blocs, UseCases, Repos, DataSources)
  // ...
}
