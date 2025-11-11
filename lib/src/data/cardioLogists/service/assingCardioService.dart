import 'package:cardio_tech/src/core/config/api_constants.dart';
import 'package:cardio_tech/src/core/network/api_client.dart';
import 'package:cardio_tech/src/data/cardioLogists/model/assignCardioModel.dart';

class AssignCardiologistService {
  final ApiClient _apiClient = ApiClient();

  Future<List<AssignCardiologistModel>> getCardiologistsByClinic(
    int clinicId,
  ) async {
    try {
      final String url = "${ApiConstants.forAssignAllCardio}/$clinicId";
      final response = await _apiClient.get(url);

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == 'SUCCESS' && data['data'] != null) {
          final List<dynamic> list = data['data'];
          return list.map((e) => AssignCardiologistModel.fromJson(e)).toList();
        }
      }
      return [];
    } catch (e) {
      print(" CardiologistService error: $e");
      return [];
    }
  }
}
