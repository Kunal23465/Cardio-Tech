import 'package:flutter/material.dart';
import 'package:cardio_tech/src/data/generalPhysician/service/all_patient/downloadEkgReportService.dart';

class DownloadEkgReportProvider extends ChangeNotifier {
  final DownloadEkgReportService _service = DownloadEkgReportService();

  bool _isLoading = false;
  bool _isSuccess = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  bool get isSuccess => _isSuccess;
  String? get errorMessage => _errorMessage;

  /// Starts the EKG report download
  Future<void> downloadEkgReport(String fileUrl) async {
    _isLoading = true;
    _isSuccess = false;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await _service.downloadEkgReport(fileUrl);

      if (success) {
        _isSuccess = true;
      } else {
        _errorMessage = "Download failed. Please try again.";
      }
    } catch (e) {
      _errorMessage = "Error: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Resets the state (useful after showing SnackBars)
  void reset() {
    _isLoading = false;
    _isSuccess = false;
    _errorMessage = null;
    notifyListeners();
  }
}
