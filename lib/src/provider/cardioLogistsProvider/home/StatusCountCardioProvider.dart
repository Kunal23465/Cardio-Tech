import 'package:cardio_tech/src/data/cardioLogists/model/home/statusCountCardioModel.dart';
import 'package:cardio_tech/src/data/cardioLogists/service/home/StatusCountCardioService.dart';
import 'package:flutter/material.dart';

class StatusCountCardioProvider extends ChangeNotifier {
  final StatusCountCardioService _service = StatusCountCardioService();

  StatusCountCardioModel? cardioStatusData;
  bool isLoading = false;

  Future<void> fetchCardioStatusCounts() async {
    isLoading = true;
    notifyListeners();

    cardioStatusData = await _service.getCardioStatusCount();

    isLoading = false;
    notifyListeners();
  }
}
