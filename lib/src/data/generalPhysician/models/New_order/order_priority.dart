class OrderPriority {
  final int priorityId;
  final String priorityName;

  OrderPriority({required this.priorityId, required this.priorityName});

  factory OrderPriority.fromJson(Map<String, dynamic> json) {
    return OrderPriority(
      priorityId: json['priorityId'] is int
          ? json['priorityId']
          : int.parse(json['priorityId'].toString()),
      priorityName: json['priorityName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'priorityId': priorityId,
    'priorityName': priorityName,
  };
}
