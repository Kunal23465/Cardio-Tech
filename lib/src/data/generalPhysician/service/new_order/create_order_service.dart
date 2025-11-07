import 'package:cardio_tech/src/core/config/api_constants.dart';
import 'package:cardio_tech/src/core/network/api_client.dart';
import 'package:cardio_tech/src/utils/storage_helper.dart';
import 'package:dio/dio.dart';

class CreateOrderService {
  final ApiClient _apiClient = ApiClient();

  Future<Response> createOrSubmitOrder(Map<String, dynamic> data) async {
    try {
      final token = await StorageHelper.getAccessToken();

      if (token != null && token.isNotEmpty) {
        _apiClient.setAuthToken(token);
      } else {
        print(" No token found ");
      }

      final response = await _apiClient.post(
        ApiConstants.saveOrUpdateOrder,
        data,
      );

      print(" Order submit response: ${response.data}");
      return response;
    } catch (e) {
      print(" Error submitting order: $e");
      rethrow;
    }
  }
}
