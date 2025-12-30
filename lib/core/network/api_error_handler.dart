import 'package:axel/core/error/failure.dart';
import 'package:dio/dio.dart';

Failure handleDioError(DioException e) {
  switch (e.type) {
    //  Timeouts
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return const ServerFailure("Connection timeout. Please try again later.");

    //  No internet / connection issue
    case DioExceptionType.connectionError:
      return const ServerFailure(
        "No internet connection. Please check your network.",
      );

    // Request cancelled
    case DioExceptionType.cancel:
      return ClientFailure(
        "Request was cancelled.",
        statusCode: e.response!.statusCode!,
      );

    //  Server responded with a status code
    case DioExceptionType.badResponse:
      return _handleBadResponse(e.response);

    // Anything unexpected
    case DioExceptionType.unknown:
    default:
      return const UnknownFailure("Unexpected error occurred.");
  }
}

Failure _handleBadResponse(Response? response) {
  final statusCode = response?.statusCode;

  if (statusCode == null) {
    return const UnknownFailure("Unexpected server response.");
  }

  if (statusCode >= 500) {
    return const ServerFailure("Server error. Please try again later.");
  }

  if (statusCode == 401 || statusCode == 403) {
    return ClientFailure("Unauthorized access.", statusCode: statusCode);
  }

  if (statusCode == 404) {
    return ClientFailure("Resource not found.", statusCode: statusCode);
  }

  if (statusCode >= 400) {
    return ClientFailure(
      response?.data?['message'] ?? "Bad request.",
      statusCode: statusCode,
    );
  }

  return const UnknownFailure("Something went wrong.");
}
