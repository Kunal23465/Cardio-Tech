import 'package:cardio_tech/src/utils/showSessionExpiredDialog.dart';
import 'package:cardio_tech/src/utils/storage_helper.dart';
import 'package:cardio_tech/src/routes/navigation_service.dart';
import 'package:cardio_tech/src/core/network/dio_client.dart';
import 'package:cardio_tech/src/core/config/api_constants.dart';
import 'package:dio/dio.dart';

class ApiInterceptor extends Interceptor {
  bool _isRefreshing = false;
  List<Function()> _retryQueue = [];

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print("REQUEST: ${options.method} ${options.uri}");
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(" RESPONSE [${response.statusCode}]: ${response.data}");
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final status = err.response?.statusCode;
    final reqPath = err.requestOptions.path;

    print("ERROR [$status]: ${err.response?.data}");

    final isRefreshCall = reqPath.contains("/auth/refresh-token");

    // ✅ Case 1: Refresh token invalid → logout
    if (isRefreshCall && status == 401) {
      await StorageHelper.clearData();
      DioClient().clearAuthToken();

      // Show friendly popup
      showSessionExpiredDialog();

      handler.next(err);
      return;
    }

    // ------------------------------------
    // ✅ Case 2: Normal API returned 401 → Try refreshing
    // ------------------------------------
    if (status == 401 || status == 403) {
      final dio = DioClient().dio;
      final requestOptions = err.requestOptions;

      // Queue failed request for retry
      _retryQueue.add(() async {
        final newToken = DioClient().getAuthToken();
        requestOptions.headers["Authorization"] = "Bearer $newToken";

        final response = await dio.request(
          requestOptions.path,
          data: requestOptions.data,
          queryParameters: requestOptions.queryParameters,
          options: Options(
            method: requestOptions.method,
            headers: requestOptions.headers,
          ),
        );

        handler.resolve(response);
      });

      // Refresh only once
      if (!_isRefreshing) {
        _isRefreshing = true;

        final newToken = await _refreshToken();

        _isRefreshing = false;

        // ❌ Do NOT logout if refresh failed due to server/network
        // ❌ Only error out request, keep user logged in
        if (newToken == null) {
          _retryQueue.clear();
          handler.next(err); // Not logout
          return;
        }

        // Process retry queue
        for (var retry in _retryQueue) {
          await retry();
        }
        _retryQueue.clear();
      }

      return;
    }

    handler.next(err);
  }

  /// Refresh Token API
  Future<String?> _refreshToken() async {
    final refresh = await StorageHelper.getRefreshToken();
    if (refresh == null || refresh.isEmpty) return null;

    try {
      print("Refreshing token...");

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
      print("Refresh token failed due to error: $e");
      return null;
    }
  }

  /// Force logout
  void _forceLogout(ErrorInterceptorHandler handler) async {
    print("Session expired → Logging out");

    await StorageHelper.clearData();
    DioClient().clearAuthToken();

    if (appNavigatorKey.currentState != null) {
      appNavigatorKey.currentState!.pushNamedAndRemoveUntil(
        "/login",
        (route) => false,
      );
    }

    handler.next(
      DioException(
        requestOptions: RequestOptions(path: "/logout"),
        error: "Session expired",
      ),
    );
  }
}
