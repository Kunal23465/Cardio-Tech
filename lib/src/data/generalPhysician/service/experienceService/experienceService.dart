import 'package:cardio_tech/src/core/config/api_constants.dart';
import 'package:cardio_tech/src/core/network/api_client.dart';
import 'package:cardio_tech/src/data/generalPhysician/models/editProfile/experienceModel.dart';

class ExperienceService {
  final ApiClient _apiClient = ApiClient();

  Future<List<ExperienceModel>> getAllExperience() async {
    final response = await _apiClient.get(ApiConstants.getAllExperience);

    if (response.statusCode == 200 && response.data != null) {
      final data = response.data['data'] as List<dynamic>;
      return data.map((e) => ExperienceModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch gender list');
    }
  }
}
