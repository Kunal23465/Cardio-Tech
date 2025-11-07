import 'dart:io';
import 'package:dio/dio.dart';
import 'package:cardio_tech/src/core/config/api_constants.dart';
import 'package:cardio_tech/src/core/network/api_client.dart';
import 'package:cardio_tech/src/utils/storage_helper.dart';

class OrderAttachmentService {
  final ApiClient _apiClient = ApiClient();

  //  Upload attachments 
  Future<void> uploadAttachments({
    required int orderDetailsId,
    File? ekgReport,
    File? uploadInsuranceIDProof,
  }) async {
    try {
      // Get stored token
      final token = await StorageHelper.getAccessToken();
      if (token != null && token.isNotEmpty) {
        _apiClient.setAuthToken(token);
      }

      //  Prepare FormData for file upload
      final formData = FormData.fromMap({
        "orderDetailsId": orderDetailsId,
        if (ekgReport != null)
          "ekgReport": await MultipartFile.fromFile(
            ekgReport.path,
            filename: ekgReport.path.split('/').last,
          ),
        if (uploadInsuranceIDProof != null)
          "uploadInsuranceIDProof": await MultipartFile.fromFile(
            uploadInsuranceIDProof.path,
            filename: uploadInsuranceIDProof.path.split('/').last,
          ),
      });

      
      final response = await _apiClient.post(
        ApiConstants.uploadOrderAttachments,
        formData,
      );

      if (response.statusCode == 200) {
        print(" Attachments uploaded successfully for order $orderDetailsId");
      } else {
        print(" Upload failed: ${response.data}");
      }
    } catch (e) {
      print(" Error uploading attachments: $e");
      rethrow;
    }
  }
}
