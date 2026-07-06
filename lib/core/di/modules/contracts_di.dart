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
import '../../../features/contracts/domain/usecases/get_contract_statuses_list_usecase.dart';
import '../../../features/contracts/domain/usecases/mark_contract_as_signed_usecase.dart';
import '../../../features/contracts/domain/usecases/get_contracts_usecase.dart';
import '../../../features/contracts/domain/usecases/get_contract_by_id_usecase.dart';
import '../../../features/contracts/data/datasources/contract_print_remote_datasource.dart';
import '../../../features/contracts/data/repositories/contract_print_repository_impl.dart';
import '../../../features/contracts/domain/repositories/contract_print_repository.dart';
import '../../../features/contracts/domain/usecases/get_bone_contract_print_data_usecase.dart';
import '../../../features/contracts/domain/usecases/get_finishing_contract_print_data_usecase.dart';
import '../../../features/contracts/domain/usecases/download_contract_pdf_usecase.dart';
import '../../../features/contracts/domain/usecases/save_finishing_order_ids_usecase.dart';
import '../../../features/contracts/domain/usecases/get_finishing_order_ids_usecase.dart';
import '../../../features/contracts/domain/usecases/generate_contract_pdf_use_case.dart';
import '../../../features/contracts/presentation/cubit/contract_print_cubit.dart';

final sl = GetIt.instance;

Future<void> initContractsModule() async {
  // Data Sources
  sl.registerLazySingleton<ContractRemoteDataSource>(
    () => ContractRemoteDataSourceImpl(dio: sl()),
  );
  sl.registerLazySingleton<ContractLocalDataSource>(
    () => ContractLocalDataSourceImpl(
      sharedPreferences: sl(),
      secureStorage: sl(),
    ),
  );
  sl.registerLazySingleton<ContractPrintRemoteDataSource>(
    () => ContractPrintRemoteDataSourceImpl(dio: sl()),
  );

  // Repositories
  sl.registerLazySingleton<ContractRepository>(
    () => ContractRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<ContractPrintRepository>(
    () => ContractPrintRepositoryImpl(remoteDataSource: sl()),
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
    () => GetContractStatusesListUseCase(sl()),
  );
  sl.registerLazySingleton(
    () => MarkContractAsSignedUseCase(sl()),
  );
  sl.registerLazySingleton(
    () => GetContractsUseCase(sl()),
  );
  sl.registerLazySingleton(
    () => GetContractByIdUseCase(sl()),
  );
  sl.registerLazySingleton(
    () => GetBoneContractPrintDataUseCase(repository: sl()),
  );
  sl.registerLazySingleton(
    () => GetFinishingContractPrintDataUseCase(repository: sl()),
  );
  sl.registerLazySingleton(
    () => DownloadContractPdfUseCase(repository: sl()),
  );
  sl.registerLazySingleton(
    () => SaveFinishingOrderIdsUseCase(sl()),
  );
  sl.registerLazySingleton(
    () => GetFinishingOrderIdsUseCase(sl()),
  );
  sl.registerLazySingleton(
    () => GenerateContractPdfUseCase(sl(), sl()),
  );

  // Cubits
  sl.registerFactory(
    () => ContractsCubit(
      createBoneContractUseCase: sl(),
      createFinishingContractUseCase: sl(),
      getApartmentFinishingOrdersUseCase: sl(),
      signContractUseCase: sl(),
      getContractSignatureStatusUseCase: sl(),
      getContractStatusesListUseCase: sl(),
      markContractAsSignedUseCase: sl(),
      getContractByIdUseCase: sl(),
      saveFinishingOrderIdsUseCase: sl(),
      getFinishingOrderIdsUseCase: sl(),
      generateContractPdfUseCase: sl(),
      sessionManager: sl(),
      biometricAuthService: sl(),
    ),
  );
  sl.registerFactory(
    () => ContractPrintCubit(
      getBoneContractPrintDataUseCase: sl(),
      getFinishingContractPrintDataUseCase: sl(),
      downloadContractPdfUseCase: sl(),
    ),
  );
}

