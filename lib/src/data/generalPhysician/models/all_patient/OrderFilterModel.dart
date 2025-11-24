import 'package:intl/intl.dart';

class OrderFilterModel {
  final int orderDetailsId;
  final String patientName;
  final String dateOfBirth;
  final String mobileNumber;
  final String? email;
  final String? insuranceIdNo;
  final String? genderValue;
  final String? medicalRecordNumber;
  final String? clinicalNote;
  final String? orderStatus;
  final String? createdAt;
  final String? priorityName;
  final String? assignedCardiologistName;
  final String? uploadInsuranceIDProof;
  final String? ekgReportName;
  final String? clinicName;

  OrderFilterModel({
    required this.orderDetailsId,
    required this.patientName,
    required this.dateOfBirth,
    required this.mobileNumber,
    this.email,
    this.insuranceIdNo,
    this.genderValue,
    this.medicalRecordNumber,
    this.clinicalNote,
    this.orderStatus,
    this.createdAt,
    this.priorityName,
    this.assignedCardiologistName,
    this.uploadInsuranceIDProof,
    this.ekgReportName,
    this.clinicName,
  });

  factory OrderFilterModel.fromJson(Map<String, dynamic> json) {
    return OrderFilterModel(
      orderDetailsId: json['orderDetailsId'] ?? 0,
      patientName: json['patientName'] ?? '',
      dateOfBirth: json['dateOfBirth'] ?? '',
      mobileNumber: json['mobileNumber'] ?? '',
      email: json['email'],
      insuranceIdNo: json['insuranceIdNo'],
      genderValue: json['genderValue'],
      medicalRecordNumber: json['medicalRecordNumber'],
      clinicalNote: json['clinicalNote'],
      orderStatus: json['orderStatus'],
      createdAt: _formatApiDate(json['createdAt']),
      priorityName: json['priorityName'],
      assignedCardiologistName: json['assignedCardiologistName'],
      uploadInsuranceIDProof: json['uploadInsuranceIDProof'],
      ekgReportName: json['ekgReport'],
      clinicName: json['clinicName'],
    );
  }

  static String? _formatApiDate(String? apiDate) {
    if (apiDate == null || apiDate.isEmpty) return null;
    try {
      final date = DateTime.parse(
        apiDate,
      ); // Parse ISO string like "2025-11-01T15:16:54.24644"
      final formatted = DateFormat(
        'dd MMM yyyy',
      ).format(date); // Format → "04 May 2025"
      return formatted; // Convert → "04 MAY 2025"
    } catch (e) {
      return apiDate; // Return original string if parsing fails
    }
  }

  static String? _extractFileName(String? fileUrl) {
    if (fileUrl == null || fileUrl.isEmpty) return null;
    try {
      // Extract everything after the last "/"
      return fileUrl.split('/').last;
    } catch (e) {
      // Return the original string if something goes wrong
      return fileUrl;
    }
  }
}
