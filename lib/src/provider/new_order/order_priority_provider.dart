import 'package:cardio_tech/src/core/config/api_constants.dart';
import 'package:cardio_tech/src/data/models/New_order/order_priority.dart';
import 'package:flutter/material.dart';
import 'package:cardio_tech/src/core/network/api_client.dart';

class OrderPriorityProvider extends ChangeNotifier {
  List<OrderPriority> _priorities = [];
  bool _isLoading = false;

  List<OrderPriority> get priorities => _priorities;
  bool get isLoading => _isLoading;

  Future<void> fetchOrderPriorities() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiClient().get(ApiConstants.getAllOrderPriority);
      final data = response.data['data'] as List;

      _priorities = data.map((e) => OrderPriority.fromJson(e)).toList();
    } catch (e) {
      debugPrint("Error fetching order priorities: $e");
    }

    _isLoading = false;
    notifyListeners();
  }
}
