import 'package:cardio_tech/src/core/config/api_constants.dart';
import 'package:cardio_tech/src/core/network/api_client.dart';
import 'package:cardio_tech/src/data/generalPhysician/models/New_order/gender_model.dart';

class GenderService {
  final ApiClient _apiClient = ApiClient();

  Future<List<GenderModel>> getGender() async {
    final response = await _apiClient.get(ApiConstants.getAllGender);

    if (response.statusCode == 200 && response.data != null) {
      final data = response.data['data'] as List<dynamic>;
      return data.map((e) => GenderModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch gender list');
    }
  }
}
