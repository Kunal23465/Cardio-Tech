import 'package:cardio_tech/src/core/config/api_constants.dart';
import 'package:cardio_tech/src/data/generalPhysician/models/New_order/order_priority.dart';
import 'package:flutter/material.dart';
import 'package:cardio_tech/src/core/network/api_client.dart';

class OrderPriorityProvider extends ChangeNotifier {
  List<OrderPriority> _priorities = [];
  bool _isLoading = false;

  String? _errorMessage;

  List<OrderPriority> get priorities => _priorities;
  bool get isLoading => _isLoading;

  //  Getter for error message
  String? get errorMessage => _errorMessage;

  Future<void> fetchOrderPriorities() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await ApiClient().get(ApiConstants.getAllOrderPriority);

      //  Validate data
      if (response.data != null && response.data['data'] != null) {
        final data = response.data['data'] as List;
        _priorities = data.map((e) => OrderPriority.fromJson(e)).toList();
      } else {
        _errorMessage = "Invalid data format received.";
      }
    } catch (e) {
      //Store error message for UI use
      _errorMessage = "Error fetching priorities: $e";
      debugPrint(_errorMessage);
    }

    _isLoading = false;
    notifyListeners();
  }
}
