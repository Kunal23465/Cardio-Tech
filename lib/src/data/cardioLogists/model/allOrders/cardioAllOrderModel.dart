import 'package:intl/intl.dart';

class CardioAllOrderModel {
  final String priorityName;
  final String clinicName;
  final String mobileNumber;
  final String orderStatus;
  final String insuranceIdNo;
  final int priorityId;
  final int assignedCardiologistId;
  final String createdAt;
  final String? updatedAt;
  final String genderValue;
  final String? uploadInsuranceIDProof;
  final String clinicalNote;
  final String createdByGpName;
  final String email;
  final int orderDetailsId;
  final String patientName;
  final String? ekgReport;
  final int genderId;
  final String dateOfBirth;
  final int createdByGpId;
  final String? cardioNote;
  final String medicalRecordNumber;
  final String assignedCardiologistName;
  final int clinicDetailsId;
  final int age;

  CardioAllOrderModel({
    required this.priorityName,
    required this.clinicName,
    required this.mobileNumber,
    required this.orderStatus,
    required this.insuranceIdNo,
    required this.priorityId,
    required this.assignedCardiologistId,
    required this.createdAt,
    required this.updatedAt,
    required this.genderValue,
    required this.uploadInsuranceIDProof,
    required this.clinicalNote,
    required this.createdByGpName,
    required this.email,
    required this.orderDetailsId,
    required this.patientName,
    required this.ekgReport,
    required this.genderId,
    required this.dateOfBirth,
    required this.createdByGpId,
    required this.cardioNote,
    required this.medicalRecordNumber,
    required this.assignedCardiologistName,
    required this.clinicDetailsId,
    required this.age,
  });

  factory CardioAllOrderModel.fromJson(Map<String, dynamic> json) {
    return CardioAllOrderModel(
      priorityName: json['priorityName'] ?? '',
      clinicName: json['clinicName'] ?? '',
      mobileNumber: json['mobileNumber'] ?? '',
      orderStatus: json['orderStatus'] ?? '',
      insuranceIdNo: json['insuranceIdNo'] ?? '',
      priorityId: json['priorityId'] ?? 0,
      assignedCardiologistId: json['assignedCardiologistId'] ?? 0,
      createdAt: _formatApiDate(json['createdAt']),
      updatedAt: _formatApiDate(json['updatedAt']),
      genderValue: json['genderValue'] ?? '',
      uploadInsuranceIDProof: json['uploadInsuranceIDProof'],
      clinicalNote: json['clinicalNote'] ?? '',
      createdByGpName: json['createdByGpName'] ?? '',
      email: json['email'] ?? '',
      orderDetailsId: json['orderDetailsId'] ?? 0,
      patientName: json['patientName'] ?? '',
      ekgReport: json['ekgReport'],
      genderId: json['genderId'] ?? 0,
      dateOfBirth: json['dateOfBirth'] ?? '',
      createdByGpId: json['createdByGpId'] ?? 0,

      cardioNote: json['cardioNote'],
      medicalRecordNumber: json['medicalRecordNumber'] ?? '',
      assignedCardiologistName: json['assignedCardiologistName'] ?? '',
      clinicDetailsId: json['clinicDetailsId'] ?? 0,
      age: json['age'] ?? 0,
    );
  }

  static String _formatApiDate(String? apiDate) {
    if (apiDate == null || apiDate.isEmpty) return '';
    try {
      final date = DateTime.parse(apiDate);
      return DateFormat('dd MMM yyyy').format(date);
    } catch (e) {
      return apiDate;
    }
  }
}
