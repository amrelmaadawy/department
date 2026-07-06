import '../../../../core/network/api_client.dart';
import '../models/active_journey_model.dart';

abstract class CustomerJourneyRemoteDataSource {
  Future<List<ActiveJourneyModel>> getActiveJourneys();
}

class CustomerJourneyRemoteDataSourceImpl implements CustomerJourneyRemoteDataSource {
  final ApiClient apiClient;

  CustomerJourneyRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<ActiveJourneyModel>> getActiveJourneys() async {
    // TODO: The backend does not have an active journeys endpoint yet.
    // Returning an empty list to prevent 404 errors.
    return [];
  }
}
