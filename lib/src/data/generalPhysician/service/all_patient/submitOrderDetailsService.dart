import 'package:cardio_tech/src/core/config/api_constants.dart';
import 'package:cardio_tech/src/core/network/api_client.dart';
import 'package:cardio_tech/src/data/generalPhysician/models/all_patient/submitOrderDetailsModel.dart';

class SubmitOrderDetailsService {
  final ApiClient _apiClient = ApiClient();

  Future<SubmitOrderDetailsModel?> submitOrderDetails({
    required int orderDetailsId,
    required int closedById,
  }) async {
    final request = SubmitOrderDetailsRequestModel(
      orderDetailsId: orderDetailsId,
      closedById: closedById,
    );

    final response = await _apiClient.put(
      ApiConstants.submitOrderDetails,
      request.toJson(),
    );

    if (response.statusCode == 200 && response.data != null) {
      final data = response.data['data'];
      return SubmitOrderDetailsModel.fromJson(data);
    } else {
      throw Exception('Failed to submit order details');
    }
  }
}
