import 'package:apartment/features/home/data/models/room_details_model.dart';
import '../../../../core/error/exceptions.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../home/data/models/project_unit_model.dart';
import '../models/project_model.dart';
import '../models/finishing_order_model.dart';
import 'package:apartment/features/projects/data/models/finishing_order_request_model.dart';
import 'package:apartment/features/projects/data/models/ai_renders_model.dart';
import 'package:apartment/features/projects/data/models/save_design_request_model.dart';
import 'package:apartment/features/projects/data/models/saved_design_model.dart';
import 'package:apartment/features/projects/data/models/customer_render_model.dart';

import '../../../../core/network/app_cancel_token.dart';

abstract class ProjectRemoteDataSource {
  Future<List<ProjectModel>> getProjects({AppCancelToken? cancelToken});
  Future<ProjectModel> getProjectDetails(int id);
  Future<List<ProjectUnitModel>> getProjectUnits(int id);
  Future<ProjectUnitModel> getUnitDetails(int id);
  Future<RoomDetailsModel> getRoomDetails(int id);
  Future<FinishingOrderModel> submitFinishingOrder(FinishingOrderRequestModel request);
  Future<AiRendersModel> getAiRenders(int orderId);
  Future<SavedDesignModel> saveDesign(SaveDesignRequestModel request);
  Future<List<String>> getPresetNotes();
  Future<List<RoomCustomerRendersModel>> getCustomerRenders(int apartmentId);
}

class ProjectRemoteDataSourceImpl implements ProjectRemoteDataSource {
  final ApiClient apiClient;

  ProjectRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<ProjectModel>> getProjects({AppCancelToken? cancelToken}) async {
    final response = await apiClient.get(
      ApiEndpoints.projects,
      cancelToken: cancelToken?.token,
    );
    
    if (response != null && response['data'] != null && response['data'] is List) {
      return (response['data'] as List)
          .map((item) => ProjectModel.fromJson(item))
          .toList();
    } else {
      throw ServerException(message: 'Failed to load projects');
    }
  }

  @override
  Future<ProjectModel> getProjectDetails(int id) async {
    final response = await apiClient.get('${ApiEndpoints.projects}/$id');
    
    if (response != null && response['data'] != null) {
      return ProjectModel.fromJson(response['data']);
    } else {
      throw ServerException(message: 'Failed to load project details');
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
      throw ServerException(message: 'Failed to load project units');
    }
  }

  @override
  Future<ProjectUnitModel> getUnitDetails(int id) async {
    final response = await apiClient.get('${ApiEndpoints.apartments}/$id');
    
    if (response != null && response['data'] != null && response['data']['apartment'] != null) {
      return ProjectUnitModel.fromJson(response['data']['apartment']);
    } else {
      throw ServerException(message: 'Failed to load unit details');
    }
  }

  @override
  Future<RoomDetailsModel> getRoomDetails(int id) async {
    final response = await apiClient.get('${ApiEndpoints.rooms}/$id');
    
    if (response != null && response['data'] != null) {
      return RoomDetailsModel.fromJson(response['data']);
    } else {
      throw ServerException(message: 'Failed to load room details');
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
      throw ServerException(message: 'Failed to submit finishing order');
    }
  }

  @override
  Future<AiRendersModel> getAiRenders(int orderId) async {
    final response = await apiClient.get(ApiEndpoints.getAiRenders(orderId));

    if (response != null && response['data'] != null) {
      return AiRendersModel.fromJson(response['data']);
    } else {
      throw ServerException(message: 'Failed to load AI renders');
    }
  }

  @override
  Future<SavedDesignModel> saveDesign(SaveDesignRequestModel request) async {
    final response = await apiClient.post(
      ApiEndpoints.savedDesigns,
      data: request.toJson(),
    );

    if (response != null && response['data'] != null && response['data']['saved_design'] != null) {
      return SavedDesignModel.fromJson(response['data']['saved_design']);
    } else {
      throw ServerException(message: 'Failed to save design');
    }
  }

  @override
  Future<List<String>> getPresetNotes() async {
    final response = await apiClient.get(ApiEndpoints.presetNotes);
    
    if (response != null && response['data'] != null && response['data']['preset_notes'] != null) {
      return List<String>.from(response['data']['preset_notes']);
    } else {
      throw ServerException(message: 'Failed to load preset notes');
    }
  }

  @override
  Future<List<RoomCustomerRendersModel>> getCustomerRenders(int apartmentId) async {
    final response = await apiClient.get(ApiEndpoints.customerRenders(apartmentId));

    if (response != null && response['data'] != null && response['data'] is List) {
      return (response['data'] as List)
          .map((item) => RoomCustomerRendersModel.fromJson(item))
          .toList();
    } else {
      throw ServerException(message: 'Failed to load customer renders');
    }
  }
}
