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
    String? clinicNoteFromCardio,
  }) async {
    try {
      final Map<String, dynamic> formMap = {
        'orderId': orderId,
        'approvalLevel': approvalLevel,
        'approverPocId': approverPocId,
        'action': action,
        'attachment': MultipartFile.fromBytes(
          attachmentBytes,
          filename: "report_$orderId.png",
        ),
      };

      // Optional field
      if (clinicNoteFromCardio != null && clinicNoteFromCardio.isNotEmpty) {
        formMap['clinicNoteFromCardio'] = clinicNoteFromCardio;
      }

      // DEBUG: print normal fields
      formMap.forEach((key, value) {
        if (value is! MultipartFile) {
          print("Field: $key = $value");
        }
      });

      // DEBUG: print file info
      final attachment = formMap['attachment'] as MultipartFile;
      print("File: ${attachment.filename}, size: ${attachment.length}");

      final formData = FormData.fromMap(formMap);

      final response = await _apiClient.post(
        ApiConstants.submitReport,
        formData,
      );

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
