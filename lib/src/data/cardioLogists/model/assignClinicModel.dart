class AssignClinicModel {
  final int clinicId;
  final String clinicName;
  final int businessId;
  final String businessName;

  AssignClinicModel({
    required this.clinicId,
    required this.clinicName,
    required this.businessId,
    required this.businessName,
  });

  factory AssignClinicModel.fromJson(Map<String, dynamic> json) {
    return AssignClinicModel(
      clinicId: json['clinicId'] ?? 0,
      clinicName: json['clinicName'] ?? '',
      businessId: json['businessId'] ?? 0,
      businessName: json['businessName'] ?? '',
    );
  }
}
