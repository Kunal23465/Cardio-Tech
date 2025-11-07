import 'dart:typed_data';
import 'package:cardio_tech/src/core/config/api_constants.dart';
import 'package:cardio_tech/src/core/network/api_client.dart';
import 'package:dio/dio.dart';

class CardioSubmitReportService {
  final ApiClient _apiClient = ApiClient();

  Future<Map<String, dynamic>> submitCardioReport({
    required int orderId,
    required int approvalLevel,
    required int approverPocId,
    required String action,
    required Uint8List attachmentBytes,
  }) async {
    try {
      final formData = FormData.fromMap({
        'orderId': orderId,
        'approvalLevel': approvalLevel,
        'approverPocId': approverPocId,
        'action': action,
        'attachment': MultipartFile.fromBytes(
          attachmentBytes,
          filename: "report_${orderId}.png",
        ),
      });

      final response =
          await _apiClient.post(ApiConstants.submitReport, formData);

      if (response.statusCode == 200) {
        final data = response.data;
        if (data["status"] == "SUCCESS") {
          return {
            "success": true,
            "message": data["message"],
            "filePath": data["data"]?["filePath"],
          };
        }
      }

      return {"success": false, "message": "Unexpected server response"};
    } catch (e) {
      return {"success": false, "message": e.toString()};
    }
  }
}
