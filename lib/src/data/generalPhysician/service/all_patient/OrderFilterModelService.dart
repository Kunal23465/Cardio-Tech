import 'package:cardio_tech/src/core/config/api_constants.dart';
import 'package:cardio_tech/src/core/network/api_client.dart';
import 'package:cardio_tech/src/data/generalPhysician/models/all_patient/OrderFilterModel.dart';

class OrderFilterService {
  final ApiClient _apiClient = ApiClient();

  Future<List<OrderFilterModel>> fetchFilteredOrders({
    String? patientName,
    String? dateOfBirth,
    String? mobileNumber,
    String? medicalRecordNumber,
  }) async {
    final body = {
      "patientName": patientName ?? "",
      "dateOfBirth": dateOfBirth ?? "",
      "mobileNumber": mobileNumber ?? "",
      "medicalRecordNumber": medicalRecordNumber ?? "",
    };

    try {
      final response = await _apiClient.post(ApiConstants.filterOrders, body);
      final responseData = response.data;

      if (response.statusCode == 200 &&
          responseData['status'] == 'SUCCESS' &&
          responseData['data'] != null) {
        final List<dynamic> data = responseData['data'];
        return data.map((e) => OrderFilterModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to fetch orders: $e');
    }
  }
}
