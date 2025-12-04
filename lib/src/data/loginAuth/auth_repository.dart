import 'package:cardio_tech/src/core/network/exceptions.dart';
import 'package:cardio_tech/src/core/network/dio_client.dart';
import 'package:cardio_tech/src/data/loginAuth/auth_service.dart';
import 'package:cardio_tech/src/utils/storage_helper.dart';
import 'package:dio/dio.dart';

// class AuthRepository {
//   final AuthService _authService = AuthService();

//   Future<bool> login(String email, String password) async {
//     final response = await _authService.login(email, password);
//     print("Login API Response: ${response.data}");

//     if (response.statusCode == 200 && response.data != null) {
//       final status = response.data['status'];
//       final message = response.data['message'];
//       final data = response.data['data'];

//       if (status == 'SUCCESS' && data != null) {
//         final accessToken = data['accessToken'];
//         final refreshToken = data['refreshToken'];
//         final userId = data['userId'];
//         final pocId = data['pocId'];
//         final staffType = data['staffType'];

//         if (accessToken != null) {
//           await StorageHelper.saveLoginData(
//             userId: userId,
//             pocId: pocId,
//             accessToken: accessToken,
//             refreshToken: refreshToken ?? '',
//             staffType: staffType ?? '',
//           );

//           DioClient().setAuthToken(accessToken);
//           print(" Login data stored for $staffType");
//           return true;
//         }
//       } else {
//         throw ApiException(message ?? "Login failed");
//       }
//     }
//     return false;
//   }

//   Future<bool> logout() async {
//     try {
//       await StorageHelper.clearData();
//       DioClient().clearAuthToken();
//       print(" Logged out successfully");
//       return true;
//     } catch (e) {
//       print("Logout failed: $e");
//       return false;
//     }
//   }
// }
class AuthRepository {
  final AuthService _authService = AuthService();

  Future<bool> login(String email, String password) async {
    try {
      final response = await _authService.login(email, password);
      print("Login API Response: ${response.data}");

      final statusCode = response.statusCode;
      final status = response.data?['status'];
      final message = response.data?['message'];
      final data = response.data?['data'];

      if (statusCode == 401 || status == 'FAILED') {
        throw ApiException(message ?? "Invalid email or password");
      }

      if (statusCode == 200 &&
          status == 'SUCCESS' &&
          data != null &&
          data['accessToken'] != null) {
        final accessToken = data['accessToken'];
        final refreshToken = data['refreshToken'] ?? '';
        final userId = data['userId'];
        final pocId = data['pocId'];
        final staffType = data['staffType'] ?? '';

        await StorageHelper.saveLoginData(
          userId: userId,
          pocId: pocId,
          accessToken: accessToken,
          refreshToken: refreshToken,
          staffType: staffType,
        );

        DioClient().setAuthToken(accessToken);
        print("Login data stored for $staffType");

        return true;
      }

      throw ApiException("Login failed. Try again.");
    } on DioException catch (e) {
      final msg = e.response?.data?["message"] ?? "Unexpected login error";
      throw ApiException(msg);
    }
  }

  Future<bool> logout() async {
    try {
      await StorageHelper.clearData();
      DioClient().clearAuthToken();
      print("Logged out successfully");
      return true;
    } catch (e) {
      print("Logout failed: $e");
      return false;
    }
  }
}
