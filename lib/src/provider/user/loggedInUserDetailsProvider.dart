import 'package:flutter/material.dart';
import 'package:cardio_tech/src/data/loginAuth/loggedInUserDetailsService.dart';
import 'package:cardio_tech/src/data/loginAuth/model/loggedInUserDetailsModel.dart';

class LoggedInUserDetailsProvider extends ChangeNotifier {
  final LoggedInUserDetailsService _service = LoggedInUserDetailsService();

  Loggedinuserdetailsmodel? _userDetails;
  bool _isLoading = false;
  String? _errorMessage;

  Loggedinuserdetailsmodel? get userDetails => _userDetails;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchLoggedInUserDetails({required int userId}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final data = await _service.getLoggedInUserDetails(userId: userId);

      if (data != null) {
        _userDetails = data;
      } else {
        _errorMessage = "No user details found.";
      }
    } catch (e) {
      _errorMessage = "Failed to fetch user details: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// ✅ Reset provider state
  void reset() {
    _userDetails = null;
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }
}
