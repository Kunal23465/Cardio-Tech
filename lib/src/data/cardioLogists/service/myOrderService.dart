import 'package:cardio_tech/src/core/network/api_client.dart';
import 'package:cardio_tech/src/core/config/api_constants.dart';
import 'package:cardio_tech/src/data/cardioLogists/model/myOrderModel.dart';

class MyOrderService {
  final ApiClient _apiClient = ApiClient();

  /// 🔹 Fetch all orders (POST)
  Future<List<MyOrderModel>> fetchAllOrders() async {
    final response = await _apiClient.post(ApiConstants.getAllSearchOrder, {});

    if (response.statusCode == 200 && response.data != null) {
      final dataList = response.data['data'] as List;
      return dataList.map((e) => MyOrderModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch orders');
    }
  }

  Future<List<MyOrderModel>> searchOrders(String query) async {
    // Decide what to send based on query type
    Map<String, dynamic> requestBody = {};

    if (int.tryParse(query) != null) {
      // If user typed a number, treat it as an orderId
      requestBody["orderId"] = int.parse(query);
    } else {
      // Otherwise, treat it as a patient name
      requestBody["patientName"] = query;
    }

    final response = await _apiClient.post(
      ApiConstants.getAllSearchOrder,
      requestBody,
    );

    if (response.statusCode == 200 && response.data != null) {
      final dataList = response.data['data'] as List;
      return dataList.map((e) => MyOrderModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to search orders');
    }
  }
}
