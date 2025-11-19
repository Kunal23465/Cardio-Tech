import 'package:cardio_tech/src/data/generalPhysician/service/editProfile/editProfileService.dart';
import 'package:flutter/material.dart';
import 'package:cardio_tech/src/data/generalPhysician/models/editProfile/editProfileModel.dart';

class EditProfileProvider extends ChangeNotifier {
  final EditProfileService _service = EditProfileService();

  bool isLoading = false;
  int? updatedUserDetailsId;

  Future<bool> updateProfile(EditProfileModel model) async {
    try {
      isLoading = true;
      notifyListeners();

      final userDetailsId = await _service.updateProfile(model);
      updatedUserDetailsId = userDetailsId;

      return true;
    } catch (e) {
      debugPrint("Edit Profile Error: $e");
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
