import 'package:get_it/get_it.dart';
import 'package:apartment/features/packages/data/datasources/packages_remote_data_source.dart';
import 'package:apartment/features/packages/data/repositories/packages_repository_impl.dart';
import 'package:apartment/features/packages/domain/repositories/packages_repository.dart';
import 'package:apartment/features/packages/domain/usecases/get_packages_usecase.dart';
import 'package:apartment/features/packages/presentation/cubit/packages_cubit.dart';
import 'package:apartment/core/network/api_client.dart';

Future<void> registerPackagesDi(GetIt sl) async {
  // DataSource
  sl.registerLazySingleton<PackagesRemoteDataSource>(
    () => PackagesRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
  );

  // Repository
  sl.registerLazySingleton<PackagesRepository>(
    () => PackagesRepositoryImpl(remoteDataSource: sl()),
  );

  // UseCase
  sl.registerLazySingleton(() => GetPackagesUseCase(sl()));

  // Cubit — Factory so each screen gets a fresh instance
  sl.registerFactory(() => PackagesCubit(getPackagesUseCase: sl()));
}
