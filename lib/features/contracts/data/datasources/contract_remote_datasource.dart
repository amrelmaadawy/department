import 'package:dio/dio.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/contract_model.dart';
import '../models/apartment_finishing_order_model.dart';

abstract class ContractRemoteDataSource {
  Future<ContractModel> createBoneContract(int apartmentId, int customerId);
  Future<ContractModel> createFinishingContract(List<int> finishingOrderIds);
  Future<ContractModel> signContract(int contractId, String signatureBase64);
  Future<List<ApartmentFinishingOrderRoomModel>> getApartmentFinishingOrders(int apartmentId);
  Future<List<ContractModel>> getContracts();
  Future<ContractModel> getContractById(int id);
}

class ContractRemoteDataSourceImpl implements ContractRemoteDataSource {
  final Dio dio;

  ContractRemoteDataSourceImpl({required this.dio});

  @override
  Future<ContractModel> createBoneContract(int apartmentId, int customerId) async {
    final response = await dio.post(
      '${ApiEndpoints.baseUrl}/contracts/bone',
      data: {
        'apartment_id': apartmentId,
        'customer_id': customerId,
      },
    );

    if (response.data['success'] == true && response.data['data'] != null) {
      return ContractModel.fromJson(response.data['data']);
    } else {
      throw Exception(response.data['message'] ?? 'Failed to create contract');
    }
  }

  @override
  Future<ContractModel> createFinishingContract(List<int> finishingOrderIds) async {
    final response = await dio.post(
      '${ApiEndpoints.baseUrl}/contracts/finishing',
      data: {
        'finishing_order_ids': finishingOrderIds,
      },
    );

    if (response.data['success'] == true && response.data['data'] != null) {
      return ContractModel.fromJson(response.data['data']);
    } else {
      throw Exception(response.data['message'] ?? 'Failed to create finishing contract');
    }
  }

  @override
  Future<ContractModel> signContract(int contractId, String signatureBase64) async {
    final response = await dio.post(
      '${ApiEndpoints.baseUrl}/contracts/$contractId/sign',
      data: {
        'signature_base64': signatureBase64,
      },
    );

    if (response.data['success'] == true && response.data['data'] != null) {
      return ContractModel.fromJson(response.data['data']);
    } else {
      throw Exception(response.data['message'] ?? 'Failed to sign contract');
    }
  }

  @override
  Future<List<ApartmentFinishingOrderRoomModel>> getApartmentFinishingOrders(int apartmentId) async {
    final url = '${ApiEndpoints.baseUrl}/apartments/$apartmentId/finishing-orders';
    final response = await dio.get(url);

    if (response.data['success'] == true && response.data['data'] != null) {
      final List<dynamic> data = response.data['data'];
      return data.map((e) => ApartmentFinishingOrderRoomModel.fromJson(e as Map<String, dynamic>)).toList();
    } else {
      throw Exception(response.data['message'] ?? 'Failed to fetch finishing orders');
    }
  }

  @override
  Future<List<ContractModel>> getContracts() async {
    try {
      final response = await dio.get('${ApiEndpoints.baseUrl}/contracts');

      if (response.statusCode == 200 && response.data != null && response.data['data'] != null) {
        final List<dynamic> data = response.data['data'];
        return data.map((e) => ContractModel.fromJson(e as Map<String, dynamic>)).toList();
      } else {
        throw Exception(response.data?['message'] ?? 'Failed to fetch contracts');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ContractModel> getContractById(int id) async {
    final response = await dio.get('${ApiEndpoints.baseUrl}/contracts/$id');

    if (response.statusCode == 200 && response.data?['data'] != null) {
      return ContractModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } else {
      throw Exception(response.data?['message'] ?? 'Failed to fetch contract details');
    }
  }
}
