import 'package:intl/intl.dart';

class NotificationModel {
  final int approvalNotificationsDetailsId;
  final String message;
  final String status;
  final String? createdAt;
  final String? updatedAt;
  final int? orderDetailsId;

  NotificationModel({
    required this.approvalNotificationsDetailsId,
    required this.message,
    required this.status,
    required this.createdAt,
    this.updatedAt,
    this.orderDetailsId,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      approvalNotificationsDetailsId:
          json['approvalNotificationsDetailsId'] ?? 0,
      message: json['message'] ?? '',
      status: json['status'] ?? '',
      createdAt: _formatApiDate(json['createdAt'] ?? ''),
      updatedAt: json['updatedAt'],
      orderDetailsId: json['orderDetailsId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'approvalNotificationsDetailsId': approvalNotificationsDetailsId,
      'message': message,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'orderDetailsId': orderDetailsId,
    };
  }

  static String? _formatApiDate(String? apiDate) {
    if (apiDate == null || apiDate.isEmpty) return null;
    try {
      final date = DateTime.parse(apiDate);
      return DateFormat('dd MMM yyyy').format(date);
    } catch (e) {
      return apiDate;
    }
  }
}
