import 'package:dio/dio.dart';
import '../error/exceptions.dart';

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
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(message: 'Unexpected error occurred: ${e.toString()}');
    }
  }

  dynamic _processResponse(Response response) {
    // Assuming JSON response. Can be customized if there's a standard wrapper
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
                errorMessages.addAll(List<String>.from(errors[key]));
              } else if (errors[key] is String) {
                errorMessages.add(errors[key]);
              }
            }
            if (errorMessages.isNotEmpty) {
              message = errorMessages.join('\n');
            } else if (responseData.containsKey('message')) {
              message = responseData['message'];
            }
          } else if (responseData.containsKey('message')) {
            message = responseData['message'];
          } else if (responseData.containsKey('error')) {
            message = responseData['error'];
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
}
