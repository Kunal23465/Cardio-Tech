import 'package:intl/intl.dart';

/// ✅ Response model — used when getting data from API
class SubmitOrderDetailsModel {
  final int orderDetailsId;
  final int? clinicDetailsId;
  final String? patientName;
  final String? dateOfBirth;
  final String? mobileNumber;
  final String? email;
  final String? uploadInsuranceIDProof;
  final String? insuranceIdNo;
  final int? genderId;
  final String? genderValue;
  final String? medicalRecordNumber;
  final String? clinicalNote;
  final int? priorityId;
  final String? priorityName;
  final int? assignedCardiologistId;
  final String? assignedCardiologistName;
  final String? ekgReport;
  final String? orderStatus;
  final int? createdById;
  final String? createdAt;
  final String? updatedAt;
  final int? age;
  final List<ApprovalLevel>? approvalLevels;

  SubmitOrderDetailsModel({
    required this.orderDetailsId,
    this.clinicDetailsId,
    this.patientName,
    this.dateOfBirth,
    this.mobileNumber,
    this.email,
    this.uploadInsuranceIDProof,
    this.insuranceIdNo,
    this.genderId,
    this.genderValue,
    this.medicalRecordNumber,
    this.clinicalNote,
    this.priorityId,
    this.priorityName,
    this.assignedCardiologistId,
    this.assignedCardiologistName,
    this.ekgReport,
    this.orderStatus,
    this.createdById,
    this.createdAt,
    this.updatedAt,
    this.age,
    this.approvalLevels,
  });

  factory SubmitOrderDetailsModel.fromJson(Map<String, dynamic> json) {
    return SubmitOrderDetailsModel(
      orderDetailsId: json['orderDetailsId'] ?? 0,
      clinicDetailsId: json['clinicDetailsId'],
      patientName: json['patientName'] ?? '',
      dateOfBirth: json['dateOfBirth'] ?? '',
      mobileNumber: json['mobileNumber'] ?? '',
      email: json['email'],
      uploadInsuranceIDProof: json['uploadInsuranceIDProof'],
      insuranceIdNo: json['insuranceIdNo'],
      genderId: json['genderId'],
      genderValue: json['genderValue'],
      medicalRecordNumber: json['medicalRecordNumber'],
      clinicalNote: json['clinicalNote'],
      priorityId: json['priorityId'],
      priorityName: json['priorityName'],
      assignedCardiologistId: json['assignedCardiologistId'],
      assignedCardiologistName: json['assignedCardiologistName'],
      ekgReport: json['ekgReport'],
      orderStatus: json['orderStatus'],
      createdById: json['createdById'],
      createdAt: _formatApiDate(json['createdAt']),
      updatedAt: _formatApiDate(json['updatedAt']),
      age: json['age'],
      approvalLevels: (json['approvalLevels'] as List?)
          ?.map((e) => ApprovalLevel.fromJson(e))
          .toList(),
    );
  }

  static String? _formatApiDate(String? apiDate) {
    if (apiDate == null || apiDate.isEmpty) return null;
    try {
      final date = DateTime.parse(apiDate);
      return DateFormat('dd MMM yyyy').format(date);
    } catch (e) {
      return apiDate;
    }
  }
}

class SubmitOrderDetailsRequestModel {
  final int orderDetailsId;
  final int closedById;

  SubmitOrderDetailsRequestModel({
    required this.orderDetailsId,
    required this.closedById,
  });

  Map<String, dynamic> toJson() {
    return {'orderDetailsId': orderDetailsId, 'closedById': closedById};
  }
}

class ApprovalLevel {
  final int? approverUserId;
  final int? approvalLevel;
  final int? approverPocId;

  ApprovalLevel({this.approverUserId, this.approvalLevel, this.approverPocId});

  factory ApprovalLevel.fromJson(Map<String, dynamic> json) {
    return ApprovalLevel(
      approverUserId: json['approverUserId'],
      approvalLevel: json['approvalLevel'],
      approverPocId: json['approverPocId'],
    );
  }
}
