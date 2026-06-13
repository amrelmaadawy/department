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
class UnauthorizedException implements Exception {
  final String message;
  const UnauthorizedException({this.message = 'Unauthorized access'});
}

/// Exception thrown for bad requests (e.g. invalid parameters)
class BadRequestException implements Exception {
  final String message;
  const BadRequestException({required this.message});
}
