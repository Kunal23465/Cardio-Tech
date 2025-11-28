class StatusCountCardioModel {
  final int? finalizedOrders;
  final int? submittedOrders;
  final int? signOff;
  final int? highPriorityOrders;

  StatusCountCardioModel({
    this.finalizedOrders,
    this.submittedOrders,
    this.signOff,
    this.highPriorityOrders,
  });

  factory StatusCountCardioModel.fromJson(Map<String, dynamic> json) {
    return StatusCountCardioModel(
      finalizedOrders: json['finalizedOrders'] ?? 0,
      submittedOrders: json['submittedOrders'] ?? 0,
      signOff: json['signOff'] ?? 0,
      highPriorityOrders: json['highPriorityOrders'] ?? 0,
    );
  }
}
