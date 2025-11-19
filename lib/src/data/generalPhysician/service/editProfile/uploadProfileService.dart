import 'dart:io';
import 'package:cardio_tech/src/data/generalPhysician/models/editProfile/updateProfile.dart';
import 'package:dio/dio.dart';
import 'package:cardio_tech/src/core/config/api_constants.dart';
import 'package:cardio_tech/src/core/network/api_client.dart';

class UploadProfileService {
  final ApiClient _apiClient = ApiClient();

  Future<UploadProfileResponse> uploadProfilePic({
    required String userDetailsId,
    required File file,
  }) async {
    FormData formData = FormData.fromMap({
      "userDetailsId": userDetailsId,
      "file": await MultipartFile.fromFile(file.path),
    });

    final response = await _apiClient.post(
      ApiConstants.uploadProfile,
      formData,
    );

    return UploadProfileResponse.fromJson(response.data);
  }
}
