import 'package:dio/dio.dart';
import 'api_interceptor.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  factory DioClient() => _instance;

  late Dio dio;
  String? _authToken;

  DioClient._internal() {
    dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {"Content-Type": "application/json"},

        validateStatus: (status) {
          return status != null && status < 500;
        },
      ),
    );

    dio.interceptors.add(ApiInterceptor());
  }

  void setAuthToken(String token) {
    _authToken = token;
    dio.options.headers["Authorization"] = "Bearer $token";
    print("Auth token set globally: $token");
  }

  void clearAuthToken() {
    _authToken = null;
    dio.options.headers.remove("Authorization");
    print("Auth token cleared globally");
  }

  String? getAuthToken() => _authToken;

  Dio get client => dio;
}
