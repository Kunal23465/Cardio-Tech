import 'package:cardio_tech/src/core/config/api_constants.dart';
import 'package:cardio_tech/src/core/network/api_client.dart';
import 'package:cardio_tech/src/data/generalPhysician/models/notifications/notificationModel.dart';

class NotificationService {
  final ApiClient _apiClient = ApiClient();

  Future<List<NotificationModel>> getNotificationDetails({
    required int userId,
  }) async {
    try {
      final String url = "${ApiConstants.notificationDetails}/$userId";
      final response = await _apiClient.get(url);

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> dataList = response.data['data'] ?? [];
        return dataList
            .map((json) => NotificationModel.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to fetch notifications');
      }
    } catch (e) {
      print("Error fetching notifications: $e");
      rethrow;
    }
  }
}
