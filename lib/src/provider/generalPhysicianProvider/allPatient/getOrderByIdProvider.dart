import 'package:cardio_tech/src/data/generalPhysician/models/all_patient/getOrderByIdModel.dart';
import 'package:cardio_tech/src/data/generalPhysician/service/all_patient/getOrderByIdService.dart';
import 'package:flutter/material.dart';

class GetOrderByIdProvider extends ChangeNotifier {
  final GetOrderByIdService _service = GetOrderByIdService();

  GetOrderByIdModel? _order;
  bool _isLoading = false;
  String? _errorMessage;

  GetOrderByIdModel? get order => _order;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchOrderById(int orderId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _order = await _service.getOrderById(orderId);
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
