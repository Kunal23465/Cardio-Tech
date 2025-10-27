import 'package:cardio_tech/src/core/config/api_constants.dart';
import 'package:cardio_tech/src/core/network/api_client.dart';
import 'package:dio/dio.dart';

class OrderPriorityService {
  final ApiClient _apiClient = ApiClient();

  Future<Response> getAllPriority() async {
    return await _apiClient.get(ApiConstants.getAllOrderPriority);
  }
}
