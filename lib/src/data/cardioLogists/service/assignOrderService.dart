import 'package:cardio_tech/src/core/config/api_constants.dart';
import 'package:cardio_tech/src/data/cardioLogists/model/assignOrderRequestModel.dart';
import 'package:cardio_tech/src/core/network/api_client.dart';
import 'package:dio/dio.dart';

class AssignOrderService {
  final ApiClient _apiClient = ApiClient();

  Future<AssignOrderResponse> assignOrderToCardiologist(
    AssignOrderRequestModel request,
  ) async {
    try {
      final Response response = await _apiClient.put(
        ApiConstants.assignOrderToCardio,
        request.toJson(),
      );

      if (response.statusCode == 200) {
        return AssignOrderResponse.fromJson(response.data);
      } else {
        throw Exception("Failed with status ${response.statusCode}");
      }
    } catch (e) {
      rethrow;
    }
  }
}
