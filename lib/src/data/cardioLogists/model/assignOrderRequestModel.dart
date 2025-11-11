class AssignOrderRequestModel {
  final int orderDetailsId;
  final int fromCardiologistId;
  final int toCardiologistId;
  final String reason;

  AssignOrderRequestModel({
    required this.orderDetailsId,
    required this.fromCardiologistId,
    required this.toCardiologistId,
    required this.reason,
  });

  Map<String, dynamic> toJson() {
    return {
      "orderDetailsId": orderDetailsId,
      "fromCardiologistId": fromCardiologistId,
      "toCardiologistId": toCardiologistId,
      "reason": reason,
    };
  }
}

class AssignOrderResponse {
  final int statusCode;
  final String status;
  final String message;

  AssignOrderResponse({
    required this.statusCode,
    required this.status,
    required this.message,
  });

  factory AssignOrderResponse.fromJson(Map<String, dynamic> json) {
    return AssignOrderResponse(
      statusCode: json["statusCode"],
      status: json["status"],
      message: json["message"],
    );
  }
}
