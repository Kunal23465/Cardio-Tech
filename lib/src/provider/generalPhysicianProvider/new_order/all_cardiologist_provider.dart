import 'package:cardio_tech/src/data/generalPhysician/models/New_order/all_cardio_model.dart';
import 'package:cardio_tech/src/data/generalPhysician/repository/new_order/all_cardio_repo.dart';
import 'package:flutter/material.dart';

class CardiologistProvider extends ChangeNotifier {
  final CardiologistRepository _repository = CardiologistRepository();

  List<Cardiologist> _cardiologists = [];
  bool _isLoading = false;
  Cardiologist? _selected;

  List<Cardiologist> get cardiologists => _cardiologists;
  bool get isLoading => _isLoading;
  Cardiologist? get selected => _selected;

  // Fetch cardiologists list
  Future<void> fetchCardiologists() async {
    _isLoading = true;
    notifyListeners();

    try {
      _cardiologists = await _repository.fetchCardiologists();
    } catch (e) {
      print("Error fetching cardiologists: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectCardiologist(Cardiologist value) {
    _selected = value;
    notifyListeners();
  }
}
