import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/customization_draft_model.dart';

abstract class CustomizationDraftRemoteDataSource {
  Future<CustomizationDraftModel> getCustomizationDraft(int apartmentId);
  Future<CustomizationDraftModel> saveCustomizationDraft(int apartmentId, Map<String, dynamic> draftData);
}

class CustomizationDraftRemoteDataSourceImpl implements CustomizationDraftRemoteDataSource {
  final ApiClient apiClient;

  CustomizationDraftRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<CustomizationDraftModel> getCustomizationDraft(int apartmentId) async {
    final response = await apiClient.get(ApiEndpoints.customizationDraft(apartmentId));
    if (response != null && (response['status'] == 'success' || response['data'] != null)) {
      return CustomizationDraftModel.fromJson(response);
    }
    throw const ServerException(message: 'Failed to retrieve customization draft');
  }

  @override
  Future<CustomizationDraftModel> saveCustomizationDraft(int apartmentId, Map<String, dynamic> draftData) async {
    final response = await apiClient.patch(
      ApiEndpoints.customizationDraft(apartmentId),
      data: {
        'draft_data': draftData,
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      },
    );
    if (response != null && (response['status'] == 'success' || response['data'] != null)) {
      return CustomizationDraftModel.fromJson(response);
    }
    throw const ServerException(message: 'Failed to save customization draft');
  }
}
