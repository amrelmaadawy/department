import 'package:get_it/get_it.dart';

import '../../../features/contracts/data/datasources/contract_remote_datasource.dart';
import '../../../features/contracts/data/repositories/contract_repository_impl.dart';
import '../../../features/contracts/domain/repositories/contract_repository.dart';
import '../../../features/contracts/domain/usecases/create_bone_contract_usecase.dart';
import '../../../features/contracts/domain/usecases/sign_contract_usecase.dart';
import '../../../features/contracts/presentation/cubit/contracts_cubit.dart';

final sl = GetIt.instance;

Future<void> initContractsModule() async {
  // Data Sources
  sl.registerLazySingleton<ContractRemoteDataSource>(
    () => ContractRemoteDataSourceImpl(dio: sl()),
  );

  // Repositories
  sl.registerLazySingleton<ContractRepository>(
    () => ContractRepositoryImpl(remoteDataSource: sl()),
  );

  // Use Cases
  sl.registerLazySingleton(
    () => CreateBoneContractUseCase(sl()),
  );
  sl.registerLazySingleton(
    () => SignContractUseCase(sl()),
  );

  // Cubits
  sl.registerFactory(
    () => ContractsCubit(
      createBoneContractUseCase: sl(),
      signContractUseCase: sl(),
    ),
  );
}
