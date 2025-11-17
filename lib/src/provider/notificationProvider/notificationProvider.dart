import 'package:cardio_tech/src/data/generalPhysician/service/notifications/notificationService.dart';
import 'package:flutter/material.dart';
import 'package:cardio_tech/src/data/generalPhysician/models/notifications/notificationModel.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationService _service = NotificationService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<NotificationModel> _notifications = [];
  List<NotificationModel> get notifications => _notifications;

  Future<void> fetchNotifications({required int userId}) async {
    _isLoading = true;
    notifyListeners();

    try {
      _notifications = await _service.getNotificationDetails(userId: userId);
    } catch (e) {
      _notifications = [];
      print("Error fetching notifications in provider: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearNotifications() {
    _notifications = [];
    notifyListeners();
  }
}
