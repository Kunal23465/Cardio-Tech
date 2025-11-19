import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cardio_tech/src/data/generalPhysician/models/New_order/create_order_model.dart';
import 'package:cardio_tech/src/data/generalPhysician/repository/new_order/create_order_repo.dart';

class CreateOrderProvider extends ChangeNotifier {
  final CreateOrderRepository _repository = CreateOrderRepository();

  bool isLoading = false;
  bool isSuccess = false;
  String message = '';
  CreateOrderModel? newOrder;

  ///  Create order then upload attachments
  Future<int?> createOrSubmitOrder({
    required CreateOrderModel orderModel,
    required int createdById,
    required int updatedById,
    required String orderStatus,
    File? ekgReport,
    File? uploadInsuranceIDProof,
  }) async {
    isLoading = true;
    isSuccess = false;
    message = '';
    notifyListeners();

    try {
      final responseModel = await _repository.createOrSubmitOrder(
        orderModel.toJson(
          createdById: createdById,
          updatedById: updatedById,
          orderStatus: orderStatus,
        ),
      );

      newOrder = responseModel;

      if (responseModel.orderDetailsId != null &&
          (ekgReport != null || uploadInsuranceIDProof != null)) {
        final updatedOrder = await _repository.uploadAttachments(
          orderDetailsId: responseModel.orderDetailsId!,
          ekgReport: ekgReport,
          uploadInsuranceIDProof: uploadInsuranceIDProof,
        );

        newOrder = updatedOrder;
      }

      isSuccess = true;
      message =
          "Order ${orderStatus == 'IN_PROGRESS' ? 'saved as draft' : 'submitted'} successfully!";

      return responseModel.orderDetailsId; //  Return ID here
    } catch (e) {
      message = "Error occurred while saving order: $e";
      isSuccess = false;
      return null; //  Return null if error
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void resetState() {
    isLoading = false;
    isSuccess = false;
    message = '';
    newOrder = null;
    notifyListeners();
  }
}
