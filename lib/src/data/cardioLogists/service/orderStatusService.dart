import 'package:cardio_tech/src/core/config/api_constants.dart';
import 'package:cardio_tech/src/core/network/api_client.dart';

class OrderStatusService {
  final ApiClient _apiClient = ApiClient();

  Future<Map<String, dynamic>> changeStatusToInReview({
    required int orderDetailsId,
    required int cardioPocId,
  }) async {
    final body = {"orderDetailsId": orderDetailsId, "cardioPocId": cardioPocId};

    final response = await _apiClient.post(ApiConstants.changeStatus, body);

    if (response.statusCode == 200 && response.data != null) {
      return response.data;
    } else {
      throw Exception("Failed to change status");
    }
  }
}
