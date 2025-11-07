import 'package:cardio_tech/src/data/cardioLogists/model/getAllStatusModel.dart';
import 'package:cardio_tech/src/data/cardioLogists/service/getAllStatusService.dart';
import 'package:flutter/material.dart';

class GetAllCardioStatusProvider extends ChangeNotifier {
  final GetAllCardioStatusService _service = GetAllCardioStatusService();

  bool isLoading = false;
  String? errorMessage;
  List<GetAllCardioStatusModel> statuses = [];

  Future<void> getAllCardioStatus() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      statuses = await _service.getAllCardioStatus();
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }
}
