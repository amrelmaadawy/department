import 'package:get_it/get_it.dart';
import '../../../../features/customer_journey/data/datasource/customer_journey_remote_data_source.dart';
import '../../../../features/customer_journey/data/repositories/customer_journey_repository_impl.dart';
import '../../../../features/customer_journey/domain/repositories/customer_journey_repository.dart';
import '../../../../features/customer_journey/domain/usecases/get_active_journeys_usecase.dart';
import '../../network/api_client.dart';
import '../../network/network_info.dart';

void initCustomerJourneyDI(GetIt sl) {
  // Data sources
  sl.registerLazySingleton<CustomerJourneyRemoteDataSource>(
    () => CustomerJourneyRemoteDataSourceImpl(sl<ApiClient>()),
  );

  // Repositories
  sl.registerLazySingleton<CustomerJourneyRepository>(
    () => CustomerJourneyRepositoryImpl(
      remoteDataSource: sl<CustomerJourneyRemoteDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // Use cases
  sl.registerLazySingleton<GetActiveJourneysUseCase>(
    () => GetActiveJourneysUseCase(sl<CustomerJourneyRepository>()),
  );
}
