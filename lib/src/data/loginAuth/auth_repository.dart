import 'package:cardio_tech/src/core/network/exceptions.dart';
import 'package:cardio_tech/src/core/network/dio_client.dart';
import 'package:cardio_tech/src/data/loginAuth/auth_service.dart';
import 'package:cardio_tech/src/utils/storage_helper.dart';

class AuthRepository {
  final AuthService _authService = AuthService();

  Future<bool> login(String email, String password) async {
    final response = await _authService.login(email, password);
    print("Login API Response: ${response.data}");

    if (response.statusCode == 200 && response.data != null) {
      final status = response.data['status'];
      final message = response.data['message'];
      final data = response.data['data'];

      if (status == 'SUCCESS' && data != null) {
        final accessToken = data['accessToken'];
        final refreshToken = data['refreshToken'];
        final userId = data['userId'];
        final staffType = data['staffType'];

        if (accessToken != null) {
          await StorageHelper.saveLoginData(
            userId: userId,
            accessToken: accessToken,
            refreshToken: refreshToken ?? '',
            staffType: staffType ?? '',
          );

          DioClient().setAuthToken(accessToken);
          print(" Login data stored for $staffType");
          return true;
        }
      } else {
        throw ApiException(message ?? "Login failed");
      }
    }
    return false;
  }

  Future<bool> logout() async {
    try {
      await StorageHelper.clearData();
      DioClient().clearAuthToken();
      print(" Logged out successfully");
      return true;
    } catch (e) {
      print("Logout failed: $e");
      return false;
    }
  }
}
