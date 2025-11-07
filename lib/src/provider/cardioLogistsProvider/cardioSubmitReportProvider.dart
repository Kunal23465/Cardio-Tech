import 'dart:typed_data';
import 'package:cardio_tech/src/data/cardioLogists/model/cardioSubmitReportService.dart';
import 'package:flutter/material.dart';

class CardioSumbitReportProvider extends ChangeNotifier {
  final CardioSubmitReportService _service = CardioSubmitReportService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<Map<String, dynamic>> submitReport({
    required int orderId,
    required int approvalLevel,
    required int approverPocId,
    required String action,
    required Uint8List attachmentBytes,
  }) async {
    _isLoading = true;
    notifyListeners();

    final result = await _service.submitCardioReport(
      orderId: orderId,
      approvalLevel: approvalLevel,
      approverPocId: approverPocId,
      action: action,
      attachmentBytes: attachmentBytes,
    );

    _isLoading = false;
    notifyListeners();
    return result;
  }
}
