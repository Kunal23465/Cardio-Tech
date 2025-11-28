import 'package:cardio_tech/src/utils/storage_helper.dart';
import 'package:flutter/material.dart';
import 'package:cardio_tech/src/data/generalPhysician/models/all_patient/submitOrderDetailsModel.dart';
import 'package:cardio_tech/src/data/generalPhysician/service/all_patient/submitOrderDetailsService.dart';

class SubmitOrderDetailsProvider extends ChangeNotifier {
  final SubmitOrderDetailsService _service = SubmitOrderDetailsService();

  SubmitOrderDetailsModel? _submittedOrder;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isSuccess = false;

  SubmitOrderDetailsModel? get submittedOrder => _submittedOrder;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isSuccess => _isSuccess;

  /// Submits the order with logged-in user's ID automatically
  Future<void> submitOrderDetails({required int orderDetailsId}) async {
    _isLoading = true;
    _errorMessage = null;
    _isSuccess = false;
    notifyListeners();

    try {
      final closedById = await StorageHelper.getUserId();

      if (closedById == null) {
        _errorMessage = "User ID not found in local storage";
        _isLoading = false;
        notifyListeners();
        return;
      }

      // 🔹 Send API request
      _submittedOrder = await _service.submitOrderDetails(
        orderDetailsId: orderDetailsId,
        closedById: closedById,
      );

      _isSuccess = true;
    } catch (e) {
      _errorMessage = e.toString();
      _isSuccess = false;
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Resets provider state
  void reset() {
    _submittedOrder = null;
    _isLoading = false;
    _errorMessage = null;
    _isSuccess = false;
    notifyListeners();
  }
}
