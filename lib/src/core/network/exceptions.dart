import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  factory ApiException.fromDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return ApiException("Connection timeout");
      case DioExceptionType.receiveTimeout:
        return ApiException("Receive timeout");
      case DioExceptionType.badResponse:
        {
          final data = error.response?.data;
          if (data != null) {
            //  if backend added 'status' and 'message'
            if (data is Map<String, dynamic> && data.containsKey('message')) {
              return ApiException(data['message']);
            } else {
              return ApiException("Bad response from server");
            }
          }
          return ApiException("Bad response from server");
        }
      case DioExceptionType.unknown:
        return ApiException("No Internet connection");
      default:
        return ApiException("Unexpected error");
    }
  }

  @override
  String toString() => message;
}
