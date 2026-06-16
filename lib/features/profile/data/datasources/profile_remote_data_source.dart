import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile();
  Future<ProfileModel> updateProfile(dynamic data);
  Future<bool> toggleFavoriteDesign(int orderId, String imageUrl);
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

  @override
  Future<ProfileModel> updateProfile(dynamic data) async {
    final response = await apiClient.post(ApiEndpoints.profile, data: data);
    if (response != null && response['data'] != null) {
      if (response['data']['user'] != null) {
        return ProfileModel.fromJson(response['data']);
      }
      return ProfileModel.fromJson(response['data']);
    } else {
      throw Exception('Failed to update profile data');
    }
  }

  @override
  Future<bool> toggleFavoriteDesign(int orderId, String imageUrl) async {
    final response = await apiClient.post(
      ApiEndpoints.savedDesigns,
      data: {
        "finishing_order_id": orderId,
        "image_url": imageUrl,
      },
    );
    
    if (response != null && response['success'] == true && response['data'] != null) {
      return response['data']['saved'] ?? false;
    } else {
      throw Exception(response?['message'] ?? 'Failed to toggle favorite design');
    }
  }
}
