class ExperienceModel {
  final int commonLookupValueDetailsId;
  final String value;

  ExperienceModel({
    required this.commonLookupValueDetailsId,
    required this.value,
  });

  factory ExperienceModel.fromJson(Map<String, dynamic> json) {
    return ExperienceModel(
      commonLookupValueDetailsId: json['commonLookupValueDetailsId'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() => {
    'commonLookupValueDetailsId': commonLookupValueDetailsId,
    'value': value,
  };
}
