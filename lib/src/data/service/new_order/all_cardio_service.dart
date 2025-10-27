import 'package:cardio_tech/src/data/models/New_order/all_cardio_model.dart';
import '../../../core/network/api_client.dart';
import '../../../core/config/api_constants.dart';

class CardiologistService {
  final ApiClient _apiClient = ApiClient();

  Future<List<Cardiologist>> getAllCardiologists() async {
    final response = await _apiClient.get(ApiConstants.getAllCardiologists);

    if (response.statusCode == 200 && response.data != null) {
      final data = response.data['data'] as List<dynamic>;
      return data.map((e) => Cardiologist.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch cardiologists');
    }
  }
}
