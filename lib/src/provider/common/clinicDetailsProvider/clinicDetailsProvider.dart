import 'package:flutter/material.dart';
import 'package:cardio_tech/src/data/common/service/clinicDetailsService/clinicDetailsService.dart';
import 'package:cardio_tech/src/data/common/model/clinicDetails/clinicDetailsModel.dart';

class ClinicDetailsProvider extends ChangeNotifier {
  final ClinicDetailsService _service = ClinicDetailsService();

  ClinicDetailsModel? clinicDetails;
  bool isLoading = false;

  Future<void> fetchClinicDetails(int userId) async {
    try {
      isLoading = true;
      notifyListeners();

      clinicDetails = await _service.getClinicDetails(userId);

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
      print("Error fetching clinic details: $e");
    }
  }
}
