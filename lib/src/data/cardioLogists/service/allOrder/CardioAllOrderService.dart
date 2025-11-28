import 'package:cardio_tech/src/core/config/api_constants.dart';
import 'package:cardio_tech/src/core/network/api_client.dart';
import 'package:cardio_tech/src/data/cardioLogists/model/allOrders/cardioAllOrderModel.dart';
import 'package:dio/dio.dart';

class CardioAllOrderService {
  final ApiClient _apiClient = ApiClient();

  Future<List<CardioAllOrderModel>> fetchCardioAllOrders({
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
        ApiConstants.cardioAllOrder,
        body,
      );

      if (response.statusCode == 200 &&
          response.data['status'] == 'SUCCESS' &&
          response.data['data'] != null) {
        final List dataList = response.data['data'];
        return dataList.map((e) => CardioAllOrderModel.fromJson(e)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print("Error fetching finalized orders: $e");
      return [];
    }
  }
}
