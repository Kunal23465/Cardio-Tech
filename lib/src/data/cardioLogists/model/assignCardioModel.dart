class AssignCardiologistModel {
  final int pointsOfContactDetailsId;
  final String fullName;

  AssignCardiologistModel({
    required this.pointsOfContactDetailsId,
    required this.fullName,
  });

  factory AssignCardiologistModel.fromJson(Map<String, dynamic> json) {
    return AssignCardiologistModel(
      pointsOfContactDetailsId: json['pointsOfContactDetailsId'] ?? 0,
      fullName: json['fullName'] ?? '',
    );
  }
}
