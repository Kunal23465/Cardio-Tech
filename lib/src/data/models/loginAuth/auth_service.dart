import 'package:dio/dio.dart';
import '../../../core/config/api_constants.dart';
import '../../../core/network/api_client.dart';

class AuthService {
  final ApiClient _apiClient = ApiClient();

  Future<Response> login(String email, String password) async {
    final data = {"email": email, "password": password};
    return await _apiClient.post(ApiConstants.login, data);
  }

  Future<Response> logout() async {
    return await _apiClient.post(ApiConstants.logout, {});
  }

  Future<Response> forgotPassword(String emailOrMobile) async {
    final data = {"emailOrMobile": emailOrMobile};
    return await _apiClient.post(ApiConstants.forgotPassword, data);
  }

  Future<Response> verifyOtp(String emailOrMobile, String otp) async {
    final data = {"emailOrMobile": emailOrMobile, "otp": otp};
    return await _apiClient.post(ApiConstants.verifyOtp, data);
  }

  Future<Response> resetPassword(String emailOrMobile, String newPassword) async {
    final data = {"emailOrMobile": emailOrMobile, "newPassword": newPassword};
    return await _apiClient.post(ApiConstants.resetPassword, data);
  }
}
