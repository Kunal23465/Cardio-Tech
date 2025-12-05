import 'package:cardio_tech/src/core/config/api_constants.dart';
import 'package:cardio_tech/src/core/network/api_client.dart';
import 'package:cardio_tech/src/data/common/model/clinicDetails/clinicDetailsModel.dart';

class ClinicDetailsService {
  final ApiClient _apiClient = ApiClient();

  Future<ClinicDetailsModel?> getClinicDetails(int userId) async {
    final response = await _apiClient.get(
      "${ApiConstants.clinicDetails}/$userId",
    );

    if (response.statusCode == 200 &&
        response.data != null &&
        response.data['status'] == "SUCCESS") {
      final data = response.data['data'];
      return ClinicDetailsModel.fromJson(data);
    } else {
      throw Exception('Failed to fetch clinic details');
    }
  }
}
