class GetAllCardioStatusModel {
  final String value;
  final String? code;
  final String? description;

  GetAllCardioStatusModel({required this.value, this.code, this.description});

  factory GetAllCardioStatusModel.fromJson(Map<String, dynamic> json) {
    return GetAllCardioStatusModel(
      value: json['value'] ?? '',
      code: json['code'],
      description: json['description'],
    );
  }
}
