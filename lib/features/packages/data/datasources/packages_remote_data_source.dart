import 'package:apartment/core/network/api_client.dart';
import 'package:apartment/core/network/api_endpoints.dart';
import 'package:apartment/core/error/exceptions.dart';
import '../models/package_model.dart';

abstract class PackagesRemoteDataSource {
  Future<List<PackageModel>> getPackages();
}

class PackagesRemoteDataSourceImpl implements PackagesRemoteDataSource {
  final ApiClient apiClient;

  PackagesRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<PackageModel>> getPackages() async {
    final response = await apiClient.get(ApiEndpoints.packages);
    if (response != null &&
        response['data'] != null &&
        response['data'] is List) {
      return (response['data'] as List)
          .map((item) => PackageModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    throw const ServerException(message: 'Failed to load packages');
  }
}
