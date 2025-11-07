import 'package:cardio_tech/src/data/generalPhysician/models/New_order/gender_model.dart';
import 'package:cardio_tech/src/data/generalPhysician/service/new_order/gender_service.dart';

class GenderRepository {
  final GenderService _service = GenderService();

  Future<List<GenderModel>> fetchGender() async {
    try {
      return await _service.getGender();
    } catch (e) {
      print("Error fetching gender list: $e");
      return [];
    }
  }
}
