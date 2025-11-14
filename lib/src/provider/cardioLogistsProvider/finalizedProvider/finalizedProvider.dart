import 'package:cardio_tech/src/data/cardioLogists/model/finalized/finalizedModel.dart';
import 'package:cardio_tech/src/data/cardioLogists/service/finalizedService/finalizedService.dart';
import 'package:flutter/material.dart';

class FinalizedOrderProvider extends ChangeNotifier {
  final FinalizedOrderService _service = FinalizedOrderService();
  List<FinalizedOrderModel> finalizedOrders = [];
  bool isLoading = false;

  Future<void> getFinalizedOrders({
    String? patientName,
    String? medicalRecordNumber,
    int? orderId,
  }) async {
    isLoading = true;
    notifyListeners();

    finalizedOrders = await _service.fetchFinalizedOrders(
      patientName: patientName,
      medicalRecordNumber: medicalRecordNumber,
      orderId: orderId,
    );

    isLoading = false;
    notifyListeners();
  }
}
