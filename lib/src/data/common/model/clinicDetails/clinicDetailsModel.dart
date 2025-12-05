class ClinicDetailsModel {
  final String clinicName;
  final String aboutClinic;
  final int clinicId;
  final String licenseNo;
  final String address;
  final String phone;
  final String email;

  ClinicDetailsModel({
    required this.clinicName,
    required this.aboutClinic,
    required this.clinicId,
    required this.licenseNo,
    required this.address,
    required this.phone,
    required this.email,
  });

  factory ClinicDetailsModel.fromJson(Map<String, dynamic> json) {
    return ClinicDetailsModel(
      clinicName: json['clinicName'] ?? "",
      aboutClinic: json['aboutClinic'] ?? "",
      clinicId: json['clinicId'] ?? 0,
      licenseNo: json['licenseNo'] ?? "",
      address: json['address'] ?? "",
      phone: json['phone']?.toString() ?? "",
      email: json['email'] ?? "",
    );
  }
}
