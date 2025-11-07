import 'package:cardio_tech/src/data/cardioLogists/service/orderStatusService.dart';
import 'package:flutter/material.dart';

class OrderStatusProvider extends ChangeNotifier {
  final OrderStatusService _service = OrderStatusService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _message = '';
  String get message => _message;

  Future<bool> updateStatusToInReview({
    required int orderDetailsId,
    required int cardioPocId,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final res = await _service.changeStatusToInReview(
        orderDetailsId: orderDetailsId,
        cardioPocId: cardioPocId,
      );

      _message = res["message"] ?? "Status update complete";

      if (res["statusCode"] == 200 && res["data"] == true) {
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _message = "Error: ${e.toString()}";
      notifyListeners();
      return false;
    }
  }
}
