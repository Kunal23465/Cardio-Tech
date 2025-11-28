import 'package:cardio_tech/src/core/config/api_constants.dart';
import 'package:cardio_tech/src/core/network/api_client.dart';
import 'package:cardio_tech/src/data/generalPhysician/models/home/statusCountGpModel.dart';

class StatusCountGpService {
  final ApiClient _apiClient = ApiClient();

  Future<StatusCountGpModel?> getStatusCount() async {
    try {
      final response = await _apiClient.get(ApiConstants.statusCountGp);

      if (response.statusCode == 200 && response.data["status"] == "SUCCESS") {
        return StatusCountGpModel.fromJson(response.data["data"]);
      }
    } catch (e) {
      print("Status Count Error: $e");
    }
    return null;
  }
}
