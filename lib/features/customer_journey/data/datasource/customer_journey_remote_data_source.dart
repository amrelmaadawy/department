import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/active_journey_model.dart';

abstract class CustomerJourneyRemoteDataSource {
  Future<List<ActiveJourneyModel>> getActiveJourneys();
}

class CustomerJourneyRemoteDataSourceImpl implements CustomerJourneyRemoteDataSource {
  final ApiClient apiClient;

  CustomerJourneyRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<ActiveJourneyModel>> getActiveJourneys() async {
    final response = await apiClient.get(ApiEndpoints.activeJourneys);

    if (response != null && response['active_journeys'] != null && response['active_journeys'] is List) {
      final list = response['active_journeys'] as List;
      return list.map((item) => ActiveJourneyModel.fromJson(Map<String, dynamic>.from(item as Map))).toList();
    } else if (response != null && response['data'] != null && response['data']['active_journeys'] != null) {
      final list = response['data']['active_journeys'] as List;
      return list.map((item) => ActiveJourneyModel.fromJson(Map<String, dynamic>.from(item as Map))).toList();
    }
    return [];
  }
}
