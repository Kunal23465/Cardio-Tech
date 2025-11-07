class GetOrderByIdModel {
  final int orderDetailsId;
  final String patientName;
  final String dateOfBirth;
  final int genderId;
  final String mobileNumber;
  final String email;
  final String insuranceIdNo;
  final String medicalRecordNumber;
  final String clinicalNote;
  final int priorityId;
  final int assignedCardiologistId;
  final String? ekgReport;
  final String? uploadInsuranceIDProof;
  final List<Map<String, dynamic>>? approvalLevels;

  GetOrderByIdModel({
    required this.orderDetailsId,
    required this.patientName,
    required this.dateOfBirth,
    required this.genderId,
    required this.mobileNumber,
    required this.email,
    required this.insuranceIdNo,
    required this.medicalRecordNumber,
    required this.clinicalNote,
    required this.priorityId,
    required this.assignedCardiologistId,
    this.ekgReport,
    this.uploadInsuranceIDProof,
    this.approvalLevels,
  });

  factory GetOrderByIdModel.fromJson(Map<String, dynamic> json) {
    return GetOrderByIdModel(
      orderDetailsId: json['orderDetailsId'] ?? 0,
      patientName: json['patientName'] ?? '',
      dateOfBirth: json['dateOfBirth'] ?? '',
      genderId: json['genderId'] ?? 0,
      mobileNumber: json['mobileNumber'] ?? '',
      email: json['email'] ?? '',
      insuranceIdNo: json['insuranceIdNo'] ?? '',
      medicalRecordNumber: json['medicalRecordNumber'] ?? '',
      clinicalNote: json['clinicalNote'] ?? '',
      priorityId: json['priorityId'] ?? 0,
      assignedCardiologistId: json['assignedCardiologistId'] ?? 0,
      ekgReport: json['ekgReport'], 
      uploadInsuranceIDProof: json['uploadInsuranceIDProof'], 
      approvalLevels: (json['approvalLevels'] as List?)
          ?.map((e) => Map<String, dynamic>.from(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderDetailsId': orderDetailsId,
      'patientName': patientName,
      'dateOfBirth': dateOfBirth,
      'genderId': genderId,
      'mobileNumber': mobileNumber,
      'email': email,
      'insuranceIdNo': insuranceIdNo,
      'medicalRecordNumber': medicalRecordNumber,
      'clinicalNote': clinicalNote,
      'priorityId': priorityId,
      'assignedCardiologistId': assignedCardiologistId,
      'ekgReport': ekgReport, 
      'uploadInsuranceIDProof': uploadInsuranceIDProof, 
      'approvalLevels': approvalLevels,
    };
  }
}
