class NotificationModel {
  final int approvalNotificationsDetailsId;
  final String message;
  final String status;
  final String createdAt;
  final String? updatedAt;

  NotificationModel({
    required this.approvalNotificationsDetailsId,
    required this.message,
    required this.status,
    required this.createdAt,
    this.updatedAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      approvalNotificationsDetailsId:
          json['approvalNotificationsDetailsId'] ?? 0,
      message: json['message'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'approvalNotificationsDetailsId': approvalNotificationsDetailsId,
      'message': message,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
