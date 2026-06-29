import 'package:dio/dio.dart';
import '../../error/failures.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final failure = _mapToFailure(err);
    handler.reject(DioException(
      requestOptions: err.requestOptions,
      error: failure,
      response: err.response,
      type: err.type,
      message: err.message,
    ));
  }

  Failure _mapToFailure(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return const TimeoutFailure();

      case DioExceptionType.connectionError:
        return const OfflineFailure();

      case DioExceptionType.badCertificate:
        return const SSLFailure();

      case DioExceptionType.cancel:
        return const RequestCancelledFailure();

      case DioExceptionType.badResponse:
        return _mapBadResponse(err.response);

      default:
        return const UnknownFailure();
    }
  }

  Failure _mapBadResponse(Response? response) {
    final statusCode = response?.statusCode;
    final responseData = response?.data;

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
          message = _translateErrorMessage(responseData['message'].toString());
        }
      } else if (responseData.containsKey('message')) {
        message = _translateErrorMessage(responseData['message'].toString());
      } else if (responseData.containsKey('error')) {
        message = _translateErrorMessage(responseData['error'].toString());
      }
    }

    switch (statusCode) {
      case 401:
        return UnauthorizedFailure(message);
      case 403:
        return ForbiddenFailure(message);
      case 404:
        return NotFoundFailure(message);
      case 408:
        return const TimeoutFailure();
      case 502:
      case 503:
      case 504:
        return const ServerUnreachableFailure();
      default:
        return ServerFailure(message, statusCode);
    }
  }

  String _translateErrorMessage(String msg) {
    String lowerMsg = msg.toLowerCase();
    
    if (lowerMsg.contains('selecation') || lowerMsg.contains('selection')) {
      if (lowerMsg.contains('material_ids')) {
        return 'يرجى التأكد من اختيار جميع الخامات المطلوبة للغرفة قبل المتابعة.';
      }
    }
    
    if (lowerMsg.contains('material_ids')) {
      return 'يرجى اختيار الخامات بشكل صحيح.';
    }

    return msg;
  }
}
