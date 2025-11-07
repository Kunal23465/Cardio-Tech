import 'package:cardio_tech/src/data/generalPhysician/repository/new_order/gender_repo.dart';
import 'package:flutter/material.dart';
import 'package:cardio_tech/src/data/generalPhysician/models/New_order/gender_model.dart';

class GenderProvider extends ChangeNotifier {
  final GenderRepository _repository = GenderRepository();

  List<GenderModel> _genderList = [];
  bool _isLoading = false;

  List<GenderModel> get genderList => _genderList;
  bool get isLoading => _isLoading;

  Future<void> fetchGender() async {
    _isLoading = true;
    notifyListeners();

    try {
      _genderList = await _repository.fetchGender();
    } catch (e) {
      debugPrint("Error fetching gender: $e");
    }

    _isLoading = false;
    notifyListeners();
  }
}
