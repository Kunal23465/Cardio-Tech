import 'package:dio/dio.dart';
import 'dio_client.dart';

class ApiClient {
  final Dio _dio = DioClient().dio;

  Future<Response> post(String url, dynamic data) async {
    return await _dio.post(
      url,
      data: data,
      options: Options(
        headers: {
          'Content-Type': data is FormData
              ? 'multipart/form-data'
              : 'application/json',
        },
      ),
    );
  }

  Future<Response> get(String url) async {
    return await _dio.get(url);
  }

  //  Helper for token setup
  void setAuthToken(String token) {
    DioClient().setAuthToken(token);
  }
}
