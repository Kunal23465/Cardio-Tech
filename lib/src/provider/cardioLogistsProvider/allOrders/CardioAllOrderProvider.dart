import 'package:cardio_tech/src/data/cardioLogists/model/allOrders/cardioAllOrderModel.dart';
import 'package:cardio_tech/src/data/cardioLogists/service/allOrder/CardioAllOrderService.dart';
import 'package:flutter/material.dart';

class CardioAllOrderProvider extends ChangeNotifier {
  final CardioAllOrderService _service = CardioAllOrderService();

  List<CardioAllOrderModel> cardioAllOrders = [];
  bool isLoading = false;

  Future<void> getallCardioOrders({
    String? patientName,
    String? medicalRecordNumber,
    int? orderId,
  }) async {
    isLoading = true;
    notifyListeners();

    cardioAllOrders = await _service.fetchCardioAllOrders(
      patientName: patientName,
      medicalRecordNumber: medicalRecordNumber,
      orderId: orderId,
    );

    isLoading = false;
    notifyListeners();
  }
}
