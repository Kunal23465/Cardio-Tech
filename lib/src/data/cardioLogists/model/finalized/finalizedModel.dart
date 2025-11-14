import 'package:intl/intl.dart';

class FinalizedOrderModel {
  final int orderDetailsId;
  final String clinicName;
  final String patientName;
  final String medicalRecordNumber;
  final String? ekgReport;
  final String? orderStatus;
  final String? priorityName;
  final String? genderValue;
  final int? age;
  final String? createdAt;

  FinalizedOrderModel({
    required this.orderDetailsId,
    required this.clinicName,
    required this.patientName,
    required this.medicalRecordNumber,
    this.ekgReport,
    this.orderStatus,
    this.priorityName,
    this.genderValue,
    this.age,
    this.createdAt,
  });

  factory FinalizedOrderModel.fromJson(Map<String, dynamic> json) {
    return FinalizedOrderModel(
      orderDetailsId: json['orderDetailsId'] ?? 0,
      clinicName: json['clinicName'] ?? '',
      patientName: json['patientName'] ?? '',
      medicalRecordNumber: json['medicalRecordNumber'] ?? '',
      ekgReport: json['ekgReport'],
      orderStatus: json['orderStatus'],
      priorityName: json['priorityName'],
      genderValue: json['genderValue'],
      age: json['age'],
      createdAt: _formatApiDate(json['createdAt']),
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
