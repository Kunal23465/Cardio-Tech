import 'package:cardio_tech/src/data/cardioLogists/model/myOrderModel.dart';
import 'package:cardio_tech/src/data/cardioLogists/service/myOrderService.dart';
import 'package:flutter/material.dart';

class MyOrderProvider extends ChangeNotifier {
  final MyOrderService _service = MyOrderService();

  bool isLoading = false;
  List<MyOrderModel> _allOrders = [];
  List<MyOrderModel> _filteredOrders = [];

  List<MyOrderModel> get orders => _filteredOrders;

  Future<void> fetchAllOrders() async {
    isLoading = true;
    notifyListeners();

    try {
      final result = await _service.fetchAllOrders();
      _allOrders = result;
      _filteredOrders = List.from(result);
    } catch (e) {
      debugPrint('Error fetching all orders: $e');
      _allOrders = [];
      _filteredOrders = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ---- Search by patient name ----
  Future<void> searchOrders({required String patientName}) async {
    if (patientName.isEmpty) {
      _filteredOrders = List.from(_allOrders);
      notifyListeners();
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      final result = await _service.searchOrders(patientName);
      _filteredOrders = result;
    } catch (e) {
      debugPrint('Error searching orders: $e');
      _filteredOrders = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ---- Apply status filter ----
  void applyStatusFilter(String status) {
    if (status == "All Status") {
      _filteredOrders = List.from(_allOrders);
    } else {
      _filteredOrders = _allOrders
          .where(
            (o) => (o.orderStatus?.toLowerCase() ?? '') == status.toLowerCase(),
          )
          .toList();
    }
    notifyListeners();
  }

  // ---- Apply priority filter ----
  void applyPriorityFilter(String priority) {
    if (priority == "All Priority") {
      _filteredOrders = List.from(_allOrders);
    } else {
      _filteredOrders = _allOrders
          .where(
            (o) =>
                (o.priorityName?.toLowerCase() ?? '') == priority.toLowerCase(),
          )
          .toList();
    }
    notifyListeners();
  }

  // ---- Update single order status locally ----
  void updateOrderStatus(int orderId, String newStatus) {
    final index = _allOrders.indexWhere((o) => o.orderDetailsId == orderId);
    if (index != -1) {
      final updatedOrder = _allOrders[index].copyWith(orderStatus: newStatus);
      _allOrders[index] = updatedOrder;

      final filteredIndex = _filteredOrders.indexWhere(
        (o) => o.orderDetailsId == orderId,
      );
      if (filteredIndex != -1) {
        _filteredOrders[filteredIndex] = updatedOrder;
      }

      notifyListeners();
    }
  }

  // ---- Clear filters ----
  void clearOrders() {
    _filteredOrders = List.from(_allOrders);
    notifyListeners();
  }
}
