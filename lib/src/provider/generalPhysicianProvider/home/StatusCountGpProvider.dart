import 'package:cardio_tech/src/data/generalPhysician/models/home/statusCountGpModel.dart';
import 'package:cardio_tech/src/data/generalPhysician/service/home/StatusCountGpService.dart';
import 'package:flutter/material.dart';

class StatusCountGpProvider extends ChangeNotifier {
  final StatusCountGpService _service = StatusCountGpService();

  StatusCountGpModel? statusData;
  bool isLoading = false;

  Future<void> fetchStatusCounts() async {
    isLoading = true;
    notifyListeners();

    statusData = await _service.getStatusCount();

    isLoading = false;
    notifyListeners();
  }
}
