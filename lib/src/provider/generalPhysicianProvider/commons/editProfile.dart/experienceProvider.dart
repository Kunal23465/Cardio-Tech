import 'package:flutter/material.dart';
import 'package:cardio_tech/src/data/generalPhysician/models/editProfile/experienceModel.dart';
import 'package:cardio_tech/src/data/generalPhysician/service/experienceService/experienceService.dart';

class ExperienceProvider extends ChangeNotifier {
  final ExperienceService _service = ExperienceService();

  List<ExperienceModel> _experienceList = [];
  ExperienceModel? _selectedExperience;

  List<ExperienceModel> get experienceList => _experienceList;
  ExperienceModel? get selectedExperience => _selectedExperience;

  // Load experiences list
  Future<void> loadExperiences() async {
    try {
      _experienceList = await _service.getAllExperience();
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching experience: $e");
    }
  }

  // Set dropdown selected with full model
  void setSelectedExperience(ExperienceModel experience) {
    _selectedExperience = experience;
    notifyListeners();
  }

  // Set dropdown when editing profile
  void setInitialSelected(int id) {
    try {
      _selectedExperience = _experienceList.firstWhere(
        (e) => e.commonLookupValueDetailsId == id,
      );
      notifyListeners();
    } catch (e) {
      debugPrint("Initial experience not found");
    }
  }
}
