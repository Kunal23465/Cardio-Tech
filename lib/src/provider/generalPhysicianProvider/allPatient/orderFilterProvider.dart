import 'package:flutter/foundation.dart';
import 'package:cardio_tech/src/data/generalPhysician/models/all_patient/OrderFilterModel.dart';
import 'package:cardio_tech/src/data/generalPhysician/service/all_patient/OrderFilterModelService.dart';

class OrderFilterProvider extends ChangeNotifier {
  final OrderFilterService _service = OrderFilterService();

  bool isLoading = false;
  String? errorMessage;
  List<OrderFilterModel> allOrders = [];
  List<OrderFilterModel> filteredOrders = [];

  Future<void> fetchFilteredOrders({
    String? patientName,
    String? dateOfBirth,
    String? mobileNumber,
    String? medicalRecordNumber,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      allOrders = await _service.fetchFilteredOrders(
        patientName: patientName,
        dateOfBirth: dateOfBirth,
        mobileNumber: mobileNumber,
        medicalRecordNumber: medicalRecordNumber,
      );
      filteredOrders = List.from(allOrders);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // for filter
  void applyFilters({
    String? searchText,
    String? selectedStatus,
    String? selectedPriority,
  }) {
    filteredOrders = allOrders.where((order) {
     
      final matchName = searchText == null || searchText.isEmpty
          ? true
          : order.patientName.toLowerCase().contains(searchText.toLowerCase());

      final matchStatus =
          (selectedStatus == null ||
              selectedStatus == "All Status" ||
              order.orderStatus == null)
          ? true
          : order.orderStatus!.toLowerCase().trim() ==
                selectedStatus.toLowerCase().trim().replaceAll(" ", "_");

      final matchPriority =
          (selectedPriority == null ||
              selectedPriority == "All Priority" ||
              order.priorityName == null)
          ? true
          : order.priorityName!.toLowerCase().trim() ==
                selectedPriority.toLowerCase().trim();

      return matchName && matchStatus && matchPriority;
    }).toList();

    notifyListeners();
  }

  void clearFilters() {
    filteredOrders = List.from(allOrders);
    notifyListeners();
  }
}
