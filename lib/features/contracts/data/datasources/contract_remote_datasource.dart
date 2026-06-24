import 'package:dio/dio.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/contract_model.dart';

abstract class ContractRemoteDataSource {
  Future<ContractModel> createBoneContract(int apartmentId, int customerId);
  Future<ContractModel> signContract(int contractId, String signatureBase64);
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
}
