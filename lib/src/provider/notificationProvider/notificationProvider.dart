import 'package:cardio_tech/src/data/generalPhysician/service/notifications/notificationService.dart';
import 'package:flutter/material.dart';
import 'package:cardio_tech/src/data/generalPhysician/models/notifications/notificationModel.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationService _service = NotificationService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  int _unreadCount = 0;
  int get unreadCount => _unreadCount;

  List<NotificationModel> _notifications = [];
  List<NotificationModel> get notifications => _notifications;

  Future<void> fetchNotifications({required int userId}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _service.getNotificationDetails(userId: userId);

      _unreadCount = result["unreadCount"];
      _notifications = result["notifications"];
    } catch (e) {
      print("Error fetching notifications in provider: $e");
      _unreadCount = 0;
      _notifications = [];
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
