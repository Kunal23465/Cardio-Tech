class CreateOrderModel {
  final int? orderDetailsId;
  final String? patientName;
  final String? dateOfBirth;
  final int? genderId;
  final String? mobileNumber;
  final String? email;
  final String? insuranceIdNo;
  final String medicalRecordNumber;
  final String? clinicalNote;
  final int? priorityId;
  final int? assignedCardiologistId;
  final List<Map<String, dynamic>>? approvalLevels;
  final String? ekgReport;
  final String? uploadInsuranceIDProof;

  CreateOrderModel({
    this.orderDetailsId,
    this.patientName,
    this.dateOfBirth,
    this.genderId,
    this.mobileNumber,
    this.email,
    this.insuranceIdNo,
    required this.medicalRecordNumber,
    this.clinicalNote,
    this.priorityId,
    this.assignedCardiologistId,
    this.approvalLevels,
    this.ekgReport,
    this.uploadInsuranceIDProof,
  });

  Map<String, dynamic> toJson({
    required int createdById,
    required int updatedById,
    required String orderStatus,
  }) {
    return {
      "orderDetailsId": orderDetailsId ?? 0,
      "patientName": patientName ?? '',
      "dateOfBirth": dateOfBirth ?? '',
      "genderId": genderId ?? 0,
      "mobileNumber": mobileNumber ?? '',
      "email": email ?? '',
      "insuranceIdNo": insuranceIdNo ?? '',
      "medicalRecordNumber": medicalRecordNumber,
      "clinicalNote": clinicalNote ?? '',
      "priorityId": priorityId ?? 0,
      "assignedCardiologistId": assignedCardiologistId ?? 0,
      "orderStatus": orderStatus,
      "createdById": createdById,
      "updatedById": updatedById,
      "approvalLevels": approvalLevels ?? [],
    };
  }

  factory CreateOrderModel.fromJson(Map<String, dynamic> json) {
    return CreateOrderModel(
      orderDetailsId: json['orderDetailsId'],
      patientName: json['patientName'],
      dateOfBirth: json['dateOfBirth'],
      genderId: json['genderId'],
      mobileNumber: json['mobileNumber'],
      email: json['email'],
      insuranceIdNo: json['insuranceIdNo'],
      medicalRecordNumber: json['medicalRecordNumber'] ?? '',
      clinicalNote: json['clinicalNote'],
      priorityId: json['priorityId'],
      assignedCardiologistId: json['assignedCardiologistId'],
      approvalLevels: (json['approvalLevels'] as List?)
          ?.map((e) => Map<String, dynamic>.from(e))
          .toList(),
      ekgReport: json['ekgReport'],
      uploadInsuranceIDProof: json['uploadInsuranceIDProof'],
    );
  }
}
