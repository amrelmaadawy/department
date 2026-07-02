import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/contract_print_model.dart';

abstract class ContractPrintRemoteDataSource {
  Future<ContractPrintModel> getBoneContractPrintData(int apartmentId);
  Future<ContractPrintModel> getFinishingContractPrintData(int apartmentId);
  Future<Uint8List> downloadPdfBytes(String pdfUrl);
}

class ContractPrintRemoteDataSourceImpl implements ContractPrintRemoteDataSource {
  final Dio dio;

  ContractPrintRemoteDataSourceImpl({required this.dio});

  @override
  Future<ContractPrintModel> getBoneContractPrintData(int apartmentId) async {
    final response = await dio.get('${ApiEndpoints.baseUrl}/apartments/$apartmentId/bone-contract/print');
    if (response.data['success'] == true) {
      return ContractPrintModel.fromJson(response.data as Map<String, dynamic>);
    }
    throw Exception(response.data['message'] ?? 'عقد العظم غير موجود أو لا تملك صلاحية الوصول إليه');
  }

  @override
  Future<ContractPrintModel> getFinishingContractPrintData(int apartmentId) async {
    final response = await dio.get('${ApiEndpoints.baseUrl}/apartments/$apartmentId/finishing-contract/print');
    if (response.data['success'] == true) {
      return ContractPrintModel.fromJson(response.data as Map<String, dynamic>);
    }
    throw Exception(response.data['message'] ?? 'عقد التشطيب غير موجود أو لا تملك صلاحية الوصول إليه');
  }

  @override
  Future<Uint8List> downloadPdfBytes(String pdfUrl) async {
    // الـ pdf_url يستخدم توثيق الـ Signature في الرابط نفسه
    // لذلك يجب استخدام Dio جديد بدون أي Interceptors لتجنب التعارض مع الـ Bearer Token
    final cleanDio = Dio(BaseOptions(
      receiveTimeout: const Duration(seconds: 60),
      sendTimeout: const Duration(seconds: 30),
      headers: {'Accept': 'application/pdf, */*'},
    ));

    final response = await cleanDio.get(
      pdfUrl,
      options: Options(responseType: ResponseType.bytes),
    );

    final bytes = Uint8List.fromList(response.data as List<int>);

    if (bytes.length < 4) {
      throw Exception('ملف العقد المستلم فارغ أو تالف');
    }

    final checkLen = bytes.length < 100 ? bytes.length : 100;
    final headerStr = String.fromCharCodes(bytes.take(checkLen));
    if (!headerStr.contains('%PDF')) {
      try {
        final decoded = utf8.decode(bytes);
        if (decoded.trim().startsWith('{')) {
          final jsonMap = json.decode(decoded);
          if (jsonMap['message'] != null) {
            throw Exception(jsonMap['message'].toString());
          }
        }
      } catch (e) {
        if (e.toString().contains('Exception: ')) rethrow;
      }
      throw Exception('تعذر تحميل العقد: الملف المستلم من الخادم ليس بصيغة PDF صحيحة');
    }

    return bytes;
  }
}
