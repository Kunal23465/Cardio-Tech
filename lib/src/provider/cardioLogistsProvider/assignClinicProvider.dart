import 'package:cardio_tech/src/data/cardioLogists/service/assignClinicService.dart';
import 'package:flutter/material.dart';
import 'package:cardio_tech/src/data/cardioLogists/model/assignClinicModel.dart';

class AssignClinicProvider with ChangeNotifier {
  final AssignClinicService _assignClinicService = AssignClinicService();

  List<AssignClinicModel> _clinics = [];
  bool _isLoading = false;

  List<AssignClinicModel> get clinics => _clinics;
  bool get isLoading => _isLoading;

  Future<void> fetchClinics() async {
    _isLoading = true;
    notifyListeners();

    try {
      _clinics = await _assignClinicService.fetchAllAssignClinics();
    } catch (e) {
      debugPrint(" Error fetching clinics: $e");
      _clinics = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
