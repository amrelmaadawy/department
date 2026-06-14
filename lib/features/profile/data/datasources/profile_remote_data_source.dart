import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiClient apiClient;

  ProfileRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<ProfileModel> getProfile() async {
    final response = await apiClient.get(ApiEndpoints.profile);
    
    // The response has the structure: { "success": true, "message": "...", "data": { ... } }
    if (response != null && response['data'] != null) {
      return ProfileModel.fromJson(response['data']);
    } else {
      throw Exception('Failed to load profile data');
    }
  }
}
