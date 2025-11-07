class GetAllCardioStatusModel {
  final String orderStatus;

  GetAllCardioStatusModel({required this.orderStatus});
  factory GetAllCardioStatusModel.fromJson(Map<String, dynamic> json) {
    return GetAllCardioStatusModel(orderStatus: json['orderStatus'] ?? '');
  }
}
