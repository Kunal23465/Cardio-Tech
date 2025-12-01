import 'package:cardio_tech/src/core/config/api_constants.dart';
import 'package:cardio_tech/src/core/network/api_client.dart';
import 'package:cardio_tech/src/data/generalPhysician/models/notifications/notificationModel.dart';

class NotificationService {
  final ApiClient _apiClient = ApiClient();

  Future<Map<String, dynamic>> getNotificationDetails({
    required int userId,
  }) async {
    try {
      final String url = "${ApiConstants.notificationDetails}/$userId";
      final response = await _apiClient.get(url);

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data['data'];

        final int unreadCount = data['totalUnreadCount'] ?? 0;
        final List<dynamic> list = data['notifications'] ?? [];

        final notifications = list
            .map((json) => NotificationModel.fromJson(json))
            .toList();

        return {"unreadCount": unreadCount, "notifications": notifications};
      } else {
        throw Exception('Failed to fetch notifications');
      }
    } catch (e) {
      print("Error fetching notifications: $e");
      rethrow;
    }
  }
}
