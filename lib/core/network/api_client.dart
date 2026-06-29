import 'package:dio/dio.dart';
import '../error/exceptions.dart';
import '../error/failures.dart';

class ApiClient {
  final Dio _dio;

  ApiClient({required Dio dio}) : _dio = dio;

  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _processResponse(response);
    } on DioException catch (e) {
      if (e.error is Failure) {
        throw FailureException(e.error as Failure);
      }
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(message: 'Unexpected error occurred: ${e.toString()}');
    }
  }

  Future<dynamic> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _processResponse(response);
    } on DioException catch (e) {
      if (e.error is Failure) {
        throw FailureException(e.error as Failure);
      }
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(message: 'Unexpected error occurred: ${e.toString()}');
    }
  }

  Future<dynamic> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _processResponse(response);
    } on DioException catch (e) {
      if (e.error is Failure) {
        throw FailureException(e.error as Failure);
      }
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(message: 'Unexpected error occurred: ${e.toString()}');
    }
  }

  Future<dynamic> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _processResponse(response);
    } on DioException catch (e) {
      if (e.error is Failure) {
        throw FailureException(e.error as Failure);
      }
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(message: 'Unexpected error occurred: ${e.toString()}');
    }
  }

  dynamic _processResponse(Response response) {
    // Assuming JSON response. Can be customized if there's a standard wrapper
    if (response.data is Map<String, dynamic>) {
      final data = response.data as Map<String, dynamic>;
      if (data['success'] == false) {
        throw ServerException(
          message: data['message'] is String ? data['message'] : (data['message']?.toString() ?? 'حدث خطأ غير معروف'),
          data: data,
        );
      }
    }
    return response.data;
  }

  Exception _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return const NetworkException(message: 'Connection timeout. Please check your internet connection.');
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final responseData = error.response?.data;
        
        String message = 'Server Error';
        if (responseData is Map<String, dynamic>) {
          if (responseData.containsKey('errors') && responseData['errors'] is Map) {
            final Map<String, dynamic> errors = responseData['errors'];
            final List<String> errorMessages = [];
            for (var key in errors.keys) {
              if (errors[key] is List) {
                for (var msg in List<String>.from(errors[key])) {
                  errorMessages.add(_translateErrorMessage(msg));
                }
              } else if (errors[key] is String) {
                errorMessages.add(_translateErrorMessage(errors[key] as String));
              }
            }
            if (errorMessages.isNotEmpty) {
              message = errorMessages.join('\n');
            } else if (responseData.containsKey('message')) {
              message = _translateErrorMessage(responseData['message'] is String ? responseData['message'] : responseData['message'].toString());
            }
          } else if (responseData.containsKey('message')) {
            message = _translateErrorMessage(responseData['message'] is String ? responseData['message'] : responseData['message'].toString());
          } else if (responseData.containsKey('error')) {
            message = _translateErrorMessage(responseData['error'] is String ? responseData['error'] : responseData['error'].toString());
          }
        }

        if (statusCode == 401) {
          return UnauthorizedException(message: message);
        } else if (statusCode == 400) {
          return BadRequestException(message: message);
        }
        return ServerException(message: message, statusCode: statusCode, data: responseData);
      case DioExceptionType.cancel:
        return const ServerException(message: 'Request was cancelled');
      case DioExceptionType.unknown:
      default:
        return const NetworkException(message: 'Unknown network error occurred');
    }
  }

  String _translateErrorMessage(String msg) {
    String lowerMsg = msg.toLowerCase();
    
    // Check for the specific backend error regarding missing materials in selection
    if (lowerMsg.contains('selecation') || lowerMsg.contains('selection')) {
      if (lowerMsg.contains('material_ids')) {
        return 'يرجى التأكد من اختيار جميع الخامات المطلوبة للغرفة قبل المتابعة.';
      }
    }
    
    // Additional common fallbacks
    if (lowerMsg.contains('material_ids')) {
      return 'يرجى اختيار الخامات بشكل صحيح.';
    }

    return msg;
  }
}
