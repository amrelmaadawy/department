import 'package:apartment/features/home/data/models/room_details_model.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../home/data/models/project_unit_model.dart';
import '../models/project_model.dart';
import '../models/finishing_order_model.dart';
import 'package:apartment/features/projects/data/models/finishing_order_request_model.dart';

abstract class ProjectRemoteDataSource {
  Future<List<ProjectModel>> getProjects();
  Future<ProjectModel> getProjectDetails(int id);
  Future<List<ProjectUnitModel>> getProjectUnits(int id);
  Future<ProjectUnitModel> getUnitDetails(int id);
  Future<RoomDetailsModel> getRoomDetails(int id);
  Future<FinishingOrderModel> submitFinishingOrder(FinishingOrderRequestModel request);
}

class ProjectRemoteDataSourceImpl implements ProjectRemoteDataSource {
  final ApiClient apiClient;

  ProjectRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<ProjectModel>> getProjects() async {
    final response = await apiClient.get(ApiEndpoints.projects);
    
    if (response != null && response['data'] != null && response['data'] is List) {
      return (response['data'] as List)
          .map((item) => ProjectModel.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to load projects');
    }
  }

  @override
  Future<ProjectModel> getProjectDetails(int id) async {
    final response = await apiClient.get('${ApiEndpoints.projects}/$id');
    
    if (response != null && response['data'] != null) {
      return ProjectModel.fromJson(response['data']);
    } else {
      throw Exception('Failed to load project details');
    }
  }

  @override
  Future<List<ProjectUnitModel>> getProjectUnits(int id) async {
    final response = await apiClient.get('${ApiEndpoints.projects}/$id/apartments');
    
    if (response != null && response['data'] != null && response['data'] is List) {
      return (response['data'] as List)
          .map((item) => ProjectUnitModel.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to load project units');
    }
  }

  @override
  Future<ProjectUnitModel> getUnitDetails(int id) async {
    final response = await apiClient.get('${ApiEndpoints.apartments}/$id');
    
    if (response != null && response['data'] != null && response['data']['apartment'] != null) {
      return ProjectUnitModel.fromJson(response['data']['apartment']);
    } else {
      throw Exception('Failed to load unit details');
    }
  }

  @override
  Future<RoomDetailsModel> getRoomDetails(int id) async {
    final response = await apiClient.get('${ApiEndpoints.rooms}/$id');
    
    if (response != null && response['data'] != null) {
      return RoomDetailsModel.fromJson(response['data']);
    } else {
      throw Exception('Failed to load room details');
    }
  }

  @override
  Future<FinishingOrderModel> submitFinishingOrder(FinishingOrderRequestModel request) async {
    final response = await apiClient.post(
      ApiEndpoints.finishingOrders,
      data: request.toJson(),
    );

    if (response != null && response['data'] != null) {
      return FinishingOrderModel.fromJson(response['data']);
    } else {
      throw Exception('Failed to submit finishing order');
    }
  }
}
