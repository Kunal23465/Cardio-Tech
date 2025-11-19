import 'package:cardio_tech/src/data/generalPhysician/service/changePassword/changePasswordService.dart';
import 'package:flutter/material.dart';

class ChangePasswordProvider with ChangeNotifier {
  final ChangePasswordService _service = ChangePasswordService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _message;
  String? get message => _message;

  Future<bool> updatePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _service.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );

      _message = response.message;
      _isLoading = false;
      notifyListeners();

      return response.status == "SUCCESS";
    } catch (e) {
      _isLoading = false;
      _message = "Something went wrong!";
      notifyListeners();
      return false;
    }
  }
}
