import 'package:dio/dio.dart';
import 'dio_client.dart';

class ApiClient {
  final Dio _dio = DioClient().dio;

  Future<Response> post(String url, Map<String, dynamic> data) async {
    return await _dio.post(url, data: data);
  }

  Future<Response> get(String url) async {
    return await _dio.get(url);
  }
}
