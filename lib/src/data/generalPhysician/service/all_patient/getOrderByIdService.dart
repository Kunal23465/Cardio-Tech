import 'package:cardio_tech/src/core/network/api_client.dart';
import 'package:cardio_tech/src/core/config/api_constants.dart';
import 'package:cardio_tech/src/data/generalPhysician/models/all_patient/getOrderByIdModel.dart';

class GetOrderByIdService {
  final ApiClient _apiClient = ApiClient();

  Future<GetOrderByIdModel?> getOrderById(int orderId) async {
    final response = await _apiClient.get(
      "${ApiConstants.getOrderById}/$orderId",
    );

    if (response.statusCode == 200 && response.data != null) {
      final data = response.data['data'];
      return GetOrderByIdModel.fromJson(data);
    } else {
      throw Exception('Failed to fetch order by ID');
    }
  }
}
