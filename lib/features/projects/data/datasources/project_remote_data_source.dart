import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/project_model.dart';

abstract class ProjectRemoteDataSource {
  Future<List<ProjectModel>> getProjects();
  Future<ProjectModel> getProjectDetails(int id);
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
}
