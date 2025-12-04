import 'package:cardio_tech/src/utils/showSessionExpiredDialog.dart';
import 'package:cardio_tech/src/utils/storage_helper.dart';
import 'package:cardio_tech/src/core/network/dio_client.dart';
import 'package:cardio_tech/src/core/config/api_constants.dart';
import 'package:dio/dio.dart';

class ApiInterceptor extends Interceptor {
  bool _isRefreshing = false;
  final List<Function()> _retryQueue = [];

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print("REQUEST: ${options.method} ${options.uri}");
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    final status = response.statusCode;
    final path = response.requestOptions.path;

    print("RESPONSE [$status]: ${response.data}");

    //  1. If refresh token failed → force logout
    if (path.contains("/auth/refresh-token") && status == 401) {
      await _forceLogout();
      handler.reject(
        DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: "Refresh token expired",
          type: DioExceptionType.badResponse,
        ),
      );
      return;
    }

    //  2. If normal API request returns 401/403 → try refresh
    if (status == 401 || status == 403) {
      await _handleUnauthorized(response, handler);
      return;
    }

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print("ERROR [${err.response?.statusCode}]: ${err.response?.data}");
    handler.next(err);
  }

  //  HANDLE 401 (ACCESS TOKEN EXPIRED)
  Future<void> _handleUnauthorized(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    final dio = DioClient().dio;
    final requestOptions = response.requestOptions;

    // Queue request for retry
    _retryQueue.add(() async {
      final newToken = DioClient().getAuthToken();
      requestOptions.headers["Authorization"] = "Bearer $newToken";

      final retryResponse = await dio.request(
        requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: Options(
          method: requestOptions.method,
          headers: requestOptions.headers,
        ),
      );

      handler.resolve(retryResponse);
    });

    // Only refresh once
    if (!_isRefreshing) {
      _isRefreshing = true;

      final newToken = await _refreshToken();

      _isRefreshing = false;

      // If refresh failed → return original error
      if (newToken == null) {
        _retryQueue.clear();
        handler.reject(
          DioException(
            requestOptions: requestOptions,
            response: response,
            type: DioExceptionType.badResponse,
          ),
        );
        return;
      }

      // Retry queued requests
      for (var retry in _retryQueue) {
        await retry();
      }
      _retryQueue.clear();
    }
  }

  //  REFRESH TOKEN
  Future<String?> _refreshToken() async {
    final refresh = await StorageHelper.getRefreshToken();
    if (refresh == null || refresh.isEmpty) return null;

    try {
      print("Refreshing token…");

      final dio = DioClient().dio;

      final response = await dio.post(
        ApiConstants.refreshToken,
        data: {"refreshToken": refresh},
        options: Options(headers: {"Authorization": null}),
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

        print("Token refreshed successfully!");
        return newAccess;
      }

      return null;
    } catch (e) {
      print("Refresh token failed: $e");
      return null;
    }
  }

  Future<void> _forceLogout() async {
    print("Session expired → Logging out");

    await StorageHelper.clearData();
    DioClient().clearAuthToken();

    showSessionExpiredDialog();

    // if (appNavigatorKey.currentState != null) {
    //   appNavigatorKey.currentState!.pushNamedAndRemoveUntil(
    //     "/login",
    //     (route) => false,
    //   );
    // }
  }
}
