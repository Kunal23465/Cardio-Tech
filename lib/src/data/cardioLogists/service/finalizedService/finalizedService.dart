import 'package:cardio_tech/src/core/config/api_constants.dart';
import 'package:cardio_tech/src/core/network/api_client.dart';
import 'package:cardio_tech/src/data/cardioLogists/model/finalized/finalizedModel.dart';
import 'package:dio/dio.dart';

class FinalizedOrderService {
  final ApiClient _apiClient = ApiClient();

  Future<List<FinalizedOrderModel>> fetchFinalizedOrders({
    String? patientName,
    String? medicalRecordNumber,
    int? orderId,
  }) async {
    final Map<String, dynamic> body = {};

    if (orderId != null) body['orderId'] = orderId;

    if (patientName != null && patientName.isNotEmpty) {
      body['patientName'] = patientName;
    }
    if (medicalRecordNumber != null && medicalRecordNumber.isNotEmpty) {
      body['medicalRecordNumber'] = medicalRecordNumber;
    }

    try {
      final Response response = await _apiClient.post(
        ApiConstants.finalizedOrder,
        body,
      );

      if (response.statusCode == 200 &&
          response.data['status'] == 'SUCCESS' &&
          response.data['data'] != null) {
        final List dataList = response.data['data'];
        return dataList.map((e) => FinalizedOrderModel.fromJson(e)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print("Error fetching finalized orders: $e");
      return [];
    }
  }
}
