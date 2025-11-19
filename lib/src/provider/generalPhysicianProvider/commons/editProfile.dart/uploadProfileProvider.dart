import 'dart:io';
import 'package:cardio_tech/src/data/generalPhysician/service/editProfile/uploadProfileService.dart';
import 'package:flutter/material.dart';

class UploadProfileProvider extends ChangeNotifier {
  final UploadProfileService _service = UploadProfileService();

  bool isLoading = false;
  String? uploadedImageUrl;

  Future<bool> uploadProfile({
    required String userId,
    required File file,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await _service.uploadProfilePic(
        userDetailsId: userId,
        file: file,
      );

      uploadedImageUrl = response.imageUrl;

      isLoading = false;
      notifyListeners();

      return response.statusCode == 200;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      debugPrint("Upload error: $e");
      return false;
    }
  }
}
