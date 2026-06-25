import 'package:get_it/get_it.dart';

import '../../../features/contracts/data/datasources/contract_remote_datasource.dart';
import '../../../features/contracts/data/repositories/contract_repository_impl.dart';
import '../../../features/contracts/domain/repositories/contract_repository.dart';
import '../../../features/contracts/domain/usecases/create_bone_contract_usecase.dart';
import '../../../features/contracts/domain/usecases/create_finishing_contract_usecase.dart';
import '../../../features/contracts/domain/usecases/sign_contract_usecase.dart';
import '../../../features/contracts/domain/usecases/get_apartment_finishing_orders_use_case.dart';
import '../../../features/contracts/presentation/cubit/contracts_cubit.dart';

import '../../../features/contracts/data/datasources/contract_local_datasource.dart';
import '../../../features/contracts/domain/usecases/get_contract_signature_status_usecase.dart';
import '../../../features/contracts/domain/usecases/mark_contract_as_signed_usecase.dart';

final sl = GetIt.instance;

Future<void> initContractsModule() async {
  // Data Sources
  sl.registerLazySingleton<ContractRemoteDataSource>(
    () => ContractRemoteDataSourceImpl(dio: sl()),
  );
  sl.registerLazySingleton<ContractLocalDataSource>(
    () => ContractLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // Repositories
  sl.registerLazySingleton<ContractRepository>(
    () => ContractRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(
    () => CreateBoneContractUseCase(sl()),
  );
  sl.registerLazySingleton(
    () => CreateFinishingContractUseCase(sl()),
  );
  sl.registerLazySingleton(
    () => SignContractUseCase(sl()),
  );
  sl.registerLazySingleton(
    () => GetApartmentFinishingOrdersUseCase(sl()),
  );
  sl.registerLazySingleton(
    () => GetContractSignatureStatusUseCase(sl()),
  );
  sl.registerLazySingleton(
    () => MarkContractAsSignedUseCase(sl()),
  );

  // Cubits
  sl.registerFactory(
    () => ContractsCubit(
      createBoneContractUseCase: sl(),
      createFinishingContractUseCase: sl(),
      getApartmentFinishingOrdersUseCase: sl(),
      signContractUseCase: sl(),
      getContractSignatureStatusUseCase: sl(),
      markContractAsSignedUseCase: sl(),
    ),
  );
}
