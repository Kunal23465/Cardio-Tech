// lib/src/data/repository/new_order/create_order_repo.dart
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:cardio_tech/src/core/network/api_client.dart';
import 'package:cardio_tech/src/core/config/api_constants.dart';
import 'package:cardio_tech/src/data/generalPhysician/models/New_order/create_order_model.dart';

class CreateOrderRepository {
  final ApiClient _apiClient = ApiClient();

  Future<CreateOrderModel> createOrSubmitOrder(
    Map<String, dynamic> orderData,
  ) async {
    final response = await _apiClient.post(
      ApiConstants.saveOrUpdateOrder,
      orderData,
    );

    // print(" Response: ${response.data}");

    if (response.data == null) {
      throw Exception("Empty response from server");
    }

    final statusCode = response.data['statusCode'];
    final message = response.data['message'];
    final data = response.data['data'];

    if (statusCode != 200) {
      if (data is String && data.isNotEmpty) {
        throw Exception(data);
      } else {
        throw Exception(message ?? "Order submission failed");
      }
    }

    if (data is Map<String, dynamic>) {
      return CreateOrderModel.fromJson(data);
    } else {
      throw Exception("Invalid response format from server");
    }
  }

  Future<CreateOrderModel> uploadAttachments({
    required int orderDetailsId,
    File? ekgReport,
    File? uploadInsuranceIDProof,
  }) async {
    final formData = FormData.fromMap({
      'orderDetailsId': orderDetailsId,
      if (ekgReport != null)
        'ekgReport': await MultipartFile.fromFile(
          ekgReport.path,
          filename: ekgReport.path.split('/').last,
        ),
      if (uploadInsuranceIDProof != null)
        'uploadInsuranceIDProof': await MultipartFile.fromFile(
          uploadInsuranceIDProof.path,
          filename: uploadInsuranceIDProof.path.split('/').last,
        ),
    });

    final response = await _apiClient.post(
      ApiConstants.uploadOrderAttachments,
      formData,
    );

    if (response.statusCode == 200 && response.data['data'] != null) {
      final data = response.data['data'];
      if (data is Map<String, dynamic>) {
        return CreateOrderModel.fromJson(data);
      } else {
        throw Exception("Unexpected attachment response format");
      }
    } else {
      throw Exception("Failed to upload attachments");
    }
  }
}
