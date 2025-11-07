class AllStatusModel {
  final String orderStatus;

  AllStatusModel({required this.orderStatus});
  factory AllStatusModel.fromJson(Map<String, dynamic> json) {
    return AllStatusModel(orderStatus: json['orderStatus'] ?? '');
  }
}
