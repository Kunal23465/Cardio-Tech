import 'package:cardio_tech/src/core/config/api_constants.dart';
import 'package:cardio_tech/src/core/network/api_client.dart';
import 'package:cardio_tech/src/data/cardioLogists/model/home/statusCountCardioModel.dart';

class StatusCountCardioService {
  final ApiClient _apiClient = ApiClient();

  Future<StatusCountCardioModel?> getCardioStatusCount() async {
    try {
      final response = await _apiClient.get(ApiConstants.statusCountCardio);

      if (response.statusCode == 200 && response.data["status"] == "SUCCESS") {
        return StatusCountCardioModel.fromJson(response.data["data"]);
      }
    } catch (e) {
      print("Status Count Error: $e");
    }
    return null;
  }
}
