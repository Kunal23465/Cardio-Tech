class StatusCountGpModel {
  final int routineOrders;
  final int inReview;
  final int submitted;
  final int inProgress;
  final int acknowledged;
  final int finalizedOrders;
  final int highPriorityOrders;
  final int totalOrdersCreated;

  StatusCountGpModel({
    required this.routineOrders,
    required this.inReview,
    required this.submitted,
    required this.inProgress,
    required this.acknowledged,
    required this.finalizedOrders,
    required this.highPriorityOrders,
    required this.totalOrdersCreated,
  });

  factory StatusCountGpModel.fromJson(Map<String, dynamic> json) {
    return StatusCountGpModel(
      routineOrders: json['routineOrders'] ?? 0,
      inReview: json['inReview'] ?? 0,
      submitted: json['submitted'] ?? 0,
      inProgress: json['inProgress'] ?? 0,
      acknowledged: json['acknowledged'] ?? 0,
      finalizedOrders: json['finalizedOrders'] ?? 0,
      highPriorityOrders: json['highPriorityOrders'] ?? 0,
      totalOrdersCreated: json['totalOrdersCreated'] ?? 0,
    );
  }
}
