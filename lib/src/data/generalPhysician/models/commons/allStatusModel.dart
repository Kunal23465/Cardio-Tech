class GetAllGPStatusModel {
  final String value;
  final String? code;
  final String? description;

  GetAllGPStatusModel({required this.value, this.code, this.description});

  factory GetAllGPStatusModel.fromJson(Map<String, dynamic> json) {
    return GetAllGPStatusModel(
      value: json['value'] ?? '',
      code: json['code'],
      description: json['description'],
    );
  }
}
