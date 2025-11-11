import 'package:cardio_tech/src/data/cardioLogists/model/assignCardioModel.dart';
import 'package:cardio_tech/src/data/cardioLogists/service/assingCardioService.dart';
import 'package:flutter/material.dart';

class AssignCardiologistProvider with ChangeNotifier {
  final AssignCardiologistService _service = AssignCardiologistService();

  List<AssignCardiologistModel> _cardiologists = [];
  bool _isLoading = false;

  List<AssignCardiologistModel> get cardiologists => _cardiologists;
  bool get isLoading => _isLoading;

  Future<void> fetchCardiologists(int clinicId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _service.getCardiologistsByClinic(clinicId);
      _cardiologists = result;
    } catch (e) {
      print(" Error fetching cardiologists: $e");
      _cardiologists = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  void clear() {
    _cardiologists = [];
    notifyListeners();
  }
}
