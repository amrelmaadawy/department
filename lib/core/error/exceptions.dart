/// Exception thrown when the server returns an error response.
class ServerException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  const ServerException({
    required this.message,
    this.statusCode,
    this.data,
  });

  @override
  String toString() => 'ServerException(message: $message, statusCode: $statusCode)';
}

/// Exception thrown when there is no internet connection or a network error occurs.
class NetworkException implements Exception {
  final String message;
  const NetworkException({this.message = 'No internet connection'});
}

/// Exception thrown when authentication fails or token is invalid/expired.
class UnauthorizedException extends ServerException {
  const UnauthorizedException({super.message = 'Unauthorized access'});
}

/// Exception thrown for bad requests (e.g. invalid parameters)
class BadRequestException extends ServerException {
  const BadRequestException({required super.message});
}

/// Exception that wraps a [Failure]. Used to seamlessly pass Failures through the exception-throwing layers.
class FailureException implements Exception {
  final dynamic failure; // Uses dynamic to avoid import cycles, but expects a Failure
  const FailureException(this.failure);

  @override
  String toString() {
    try {
      return failure.message as String;
    } catch (_) {
      return failure.toString();
    }
  }
}
