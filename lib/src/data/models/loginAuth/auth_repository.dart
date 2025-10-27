import 'package:cardio_tech/src/core/network/exceptions.dart';
import 'package:dio/dio.dart';

import 'auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/network/dio_client.dart';

class AuthRepository {
  final AuthService _authService = AuthService();

  // ---------------- LOGIN ----------------
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
        final username = data['username'];

        if (accessToken != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('accessToken', accessToken);
          await prefs.setString('refreshToken', refreshToken ?? '');
          await prefs.setString('username', username ?? '');

          DioClient().setAuthToken(accessToken);
          return true;
        }
      } else {
        throw ApiException(message ?? "Login failed");
      }
    }
    return false;
  }

  // ---------------- LOGOUT ----------------
  Future<bool> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken') ?? '';

    // Clear local storage and token upfront if no token exists
    if (token.isEmpty) {
      DioClient().clearAuthToken();
      await prefs.clear();
      return true; // Already logged out
    }

    DioClient().setAuthToken(token);

    try {
      final response = await _authService.logout();

      // Check response
      final status = response.data?['status'];
      final message = response.data?['message'];

      if (status == 'SUCCESS') {
        // Logout successful
        await prefs.clear();
        DioClient().clearAuthToken();
        return true;
      } else if (response.statusCode == 401) {
        // Token invalid or expired — treat as logged out
        print("Logout failed with 401, clearing local data anyway.");
        await prefs.clear();
        DioClient().clearAuthToken();
        return true;
      } else {
        throw ApiException(message ?? "Logout failed");
      }
    } catch (e) {
      // Catch Dio errors or network issues
      if (e is DioException && e.response?.statusCode == 401) {
        print("Logout DioException 401 — clearing local data anyway.");
        await prefs.clear();
        DioClient().clearAuthToken();
        return true;
      }

      print("Logout failed: $e");
      rethrow; // Rethrow other unexpected errors
    }
  }

  // ---------------- FORGOT PASSWORD ----------------
  Future<bool> forgotPassword(String emailOrMobile) async {
    final response = await _authService.forgotPassword(emailOrMobile);
    final status = response.data?['status'];
    final message = response.data?['message'];

    if (status == 'SUCCESS') {
      return true;
    } else {
      throw ApiException(message ?? "Failed to send OTP");
    }
  }

  // ---------------- VERIFY OTP ----------------
  Future<bool> verifyOtp(String emailOrMobile, String otp) async {
    final response = await _authService.verifyOtp(emailOrMobile, otp);
    final status = response.data?['status'];
    final message = response.data?['message'];

    if (status == 'SUCCESS') {
      return true;
    } else {
      throw ApiException(message ?? "OTP verification failed");
    }
  }

  // ---------------- RESET PASSWORD ----------------
  Future<bool> resetPassword(String emailOrMobile, String newPassword) async {
    final response = await _authService.resetPassword(
      emailOrMobile,
      newPassword,
    );
    final status = response.data?['status'];
    final message = response.data?['message'];

    if (status == 'SUCCESS') {
      return true;
    } else {
      throw ApiException(message ?? "Password reset failed");
    }
  }
}
