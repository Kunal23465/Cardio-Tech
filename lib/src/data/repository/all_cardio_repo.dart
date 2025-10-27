import 'package:cardio_tech/src/data/models/New_order/all_cardio_model.dart';
import 'package:cardio_tech/src/data/service/new_order/all_cardio_service.dart';

class CardiologistRepository {
  final CardiologistService _service = CardiologistService();

  Future<List<Cardiologist>> fetchCardiologists() async {
    try {
      return await _service.getAllCardiologists();
    } catch (e) {
      print("Error fetching cardiologists: $e");
      return [];
    }
  }
}
