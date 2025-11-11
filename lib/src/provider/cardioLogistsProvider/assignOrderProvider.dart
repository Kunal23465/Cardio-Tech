import 'package:flutter/foundation.dart';
import 'package:cardio_tech/src/data/cardioLogists/model/assignOrderRequestModel.dart';
import 'package:cardio_tech/src/data/cardioLogists/service/assignOrderService.dart';

class AssignOrderProvider extends ChangeNotifier {
  final AssignOrderService _service = AssignOrderService();
  bool isLoading = false;

  Future<bool> assignOrder({
    required int orderDetailsId,
    required int fromCardiologistId,
    required int toCardiologistId,
    required String reason,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      final request = AssignOrderRequestModel(
        orderDetailsId: orderDetailsId,
        fromCardiologistId: fromCardiologistId,
        toCardiologistId: toCardiologistId,
        reason: reason,
      );

      final response = await _service.assignOrderToCardiologist(request);

      isLoading = false;
      notifyListeners();

      if (response.statusCode == 200 && response.status == "SUCCESS") {
        if (kDebugMode) {
          print(" Order reassigned successfully: ${response.message}");
        }
        return true;
      } else {
        if (kDebugMode) {
          print(" Assignment failed: ${response.message}");
        }
        return false;
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      if (kDebugMode) {
        print(" Error assigning order: $e");
      }
      return false;
    }
  }
}
