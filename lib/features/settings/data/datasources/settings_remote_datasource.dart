import 'package:apartment/core/network/api_client.dart';
import 'package:apartment/core/network/api_endpoints.dart';
import '../models/settings_model.dart';
import 'package:dio/dio.dart';

abstract class SettingsRemoteDataSource {
  Future<SettingsModel> getGeneralSettings({CancelToken? cancelToken});
}

class SettingsRemoteDataSourceImpl implements SettingsRemoteDataSource {
  final ApiClient apiClient;

  SettingsRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<SettingsModel> getGeneralSettings({CancelToken? cancelToken}) async {
    final response = await apiClient.get(
      ApiEndpoints.generalSettings, // Need to add this to ApiEndpoints
      cancelToken: cancelToken,
    );

    return SettingsModel.fromJson(response['data']);
  }
}
