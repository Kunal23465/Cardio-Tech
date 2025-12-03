import 'package:cardio_tech/src/core/config/api_constants.dart';
import 'package:cardio_tech/src/core/network/dio_client.dart';
import 'package:cardio_tech/src/utils/showSessionExpiredDialog.dart';
import 'package:cardio_tech/src/utils/storage_helper.dart';
import 'package:dio/dio.dart';

class ApiInterceptor extends Interceptor {
  bool _isRefreshing = false;
  final List<Function()> _retryQueue = [];

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print(" REQUEST: ${options.method} ${options.uri}");
    print("Headers: ${options.headers}");
    print("Data: ${options.data}");
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(" RESPONSE [${response.statusCode}]: ${response.data}");
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    print(" ERROR [${err.response?.statusCode}] ${err.message}");

    final status = err.response?.statusCode;
    final message =
        err.response?.data?["message"]?.toString().toLowerCase() ?? "";
    final isRefreshCall = err.requestOptions.path.contains(
      "/auth/refresh-token",
    );

    //   If REFRESH API itself returns 401 → user MUST logout immediately

    if (isRefreshCall && status == 401) {
      print(" Refresh-token failed → Invalid or expired refresh token");
      return _forceLogout(handler, err);
    }

    //  2. Detect expired access token using server response
    // Backend sends:
    //   "message": "Given jwt token is expired !!"
    //   OR any 401 unauthorized
    final tokenExpired =
        status == 401 ||
        message.contains("jwt token is expired") ||
        message.contains("invalid token") ||
        message.contains("unauthorized") ||
        message.contains("invalid refresh token");

    if (tokenExpired) {
      final requestOptions = err.requestOptions;
      final dio = DioClient().dio;

      // Start refresh only once
      if (!_isRefreshing) {
        _isRefreshing = true;

        final newToken = await _refreshToken();
        _isRefreshing = false;

        if (newToken == null) {
          print(" Could not refresh token → force logout");
          return _forceLogout(handler, err);
        }

        // Retry all queued requests
        for (var retry in _retryQueue) retry();
        _retryQueue.clear();
      }

      // Queue current request
      _retryQueue.add(() async {
        final response = await _retryRequest(requestOptions, dio);
        handler.resolve(response);
      });

      return; // Important
    }

    handler.next(err);
  }

  // REFRESH TOKEN API
  Future<String?> _refreshToken() async {
    final refresh = await StorageHelper.getRefreshToken();
    if (refresh == null || refresh.isEmpty) return null;

    try {
      final dio = DioClient().dio;

      final response = await dio.post(
        ApiConstants.refreshToken,
        data: {"refreshToken": refresh},
        options: Options(headers: {"Authorization": null}), // important
      );

      if (response.statusCode == 200 && response.data["status"] == "SUCCESS") {
        final newAccess = response.data["data"]["accessToken"];
        final newRefresh = response.data["data"]["refreshToken"];

        await StorageHelper.saveLoginData(
          userId: await StorageHelper.getUserId() ?? 0,
          pocId: await StorageHelper.getPocId() ?? 0,
          accessToken: newAccess,
          refreshToken: newRefresh,
          staffType: await StorageHelper.getStaffType() ?? "",
        );

        DioClient().setAuthToken(newAccess);

        print(" Token refreshed successfully!");
        return newAccess;
      }

      return null;
    } catch (e) {
      print(" Refresh token failed: $e");
      return null;
    }
  }

  // RETRY ORIGINAL REQUEST
  Future<Response> _retryRequest(RequestOptions request, Dio dio) async {
    final newToken = DioClient().getAuthToken();
    request.headers["Authorization"] = "Bearer $newToken";

    return dio.request(
      request.path,
      data: request.data,
      queryParameters: request.queryParameters,
      options: Options(method: request.method, headers: request.headers),
    );
  }

  // FORCE LOGOUT
  void _forceLogout(ErrorInterceptorHandler handler, DioException err) async {
    print(" User session expired → Logging out");

    await StorageHelper.clearData();
    DioClient().clearAuthToken();

    showSessionExpiredDialog();
    handler.next(err);
  }
}
