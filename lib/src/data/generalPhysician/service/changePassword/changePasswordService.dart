import 'package:cardio_tech/src/core/config/api_constants.dart';
import 'package:cardio_tech/src/core/network/api_client.dart';
import 'package:cardio_tech/src/data/generalPhysician/models/changePassword/changePasswordModel.dart';

class ChangePasswordService {
  final ApiClient _apiClient = ApiClient();

  Future<ChangePasswordModel> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final response = await _apiClient.post(ApiConstants.changePassword, {
        "currentPassword": currentPassword,
        "newPassword": newPassword,
        "confirmPassword": confirmPassword,
      });

      return ChangePasswordModel.fromJson(response.data);
    } catch (e) {
      throw Exception("Failed to change password: $e");
    }
  }
}
