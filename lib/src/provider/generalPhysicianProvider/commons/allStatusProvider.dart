import 'package:flutter/material.dart';
import 'package:cardio_tech/src/data/generalPhysician/models/commons/allStatusModel.dart';
import 'package:cardio_tech/src/data/generalPhysician/service/commons/allStatusService.dart';

class AllStatusProvider extends ChangeNotifier {
  final AllStatusService _service = AllStatusService();

  bool isLoading = false;
  String? errorMessage;
  List<GetAllGPStatusModel> statuses = [];

  Future<void> getAllStatus() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      statuses = await _service.getAllStatus();
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }
}
