class GenderModel {
  final int? id;
  final String? value;

  GenderModel({this.id, this.value});

  factory GenderModel.fromJson(Map<String, dynamic> json) {
    return GenderModel(
      id: json['commonLookupValueDetailsId'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() => {
        'commonLookupValueDetailsId': id,
        'value': value,
      };
}
