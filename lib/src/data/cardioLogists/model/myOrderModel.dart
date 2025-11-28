import 'package:intl/intl.dart';

class MyOrderModel {
  final int orderDetailsId;
  final String? patientName;
  final String? orderStatus;
  final String? priorityName;
  final String? assignedCardiologistName;
  final String? assignedCardiologistId;
  final String? medicalRecordNumber;
  final String? clinicalNote;
  final String? ekgReport;
  final String? createdAt;
  final int? age;
  final String? genderValue;
  final String? clinicName;
  final String? createdByGpName;
  final String? cardioNote;

  final List<ApprovalLevel>? approvalLevels;

  MyOrderModel({
    required this.orderDetailsId,
    this.patientName,
    this.orderStatus,
    this.priorityName,
    this.assignedCardiologistName,
    this.assignedCardiologistId,
    this.medicalRecordNumber,
    this.clinicalNote,
    this.ekgReport,
    this.createdAt,
    this.age,
    this.genderValue,
    this.approvalLevels,
    this.clinicName,
    this.createdByGpName,
    this.cardioNote,
  });

  factory MyOrderModel.fromJson(Map<String, dynamic> json) {
    return MyOrderModel(
      orderDetailsId: json["orderDetailsId"] ?? 0,
      patientName: json["patientName"],
      orderStatus: json["orderStatus"],
      priorityName: json["priorityName"],
      assignedCardiologistName: json["assignedCardiologistName"],
      assignedCardiologistId: json["assignedCardiologistId"]?.toString(),
      medicalRecordNumber: json["medicalRecordNumber"],
      clinicalNote: json["clinicalNote"],
      ekgReport: json["ekgReport"],
      createdAt: _formatApiDate(json['createdAt']),
      age: json["age"] != null ? int.tryParse(json["age"].toString()) : null,
      genderValue: json["genderValue"],
      clinicName: json["clinicName"],
      createdByGpName: json["createdByGpName"],
      cardioNote: json["cardioNote"],

      approvalLevels: (json["approvalLevels"] as List?)
          ?.map((e) => ApprovalLevel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "orderDetailsId": orderDetailsId,
      "patientName": patientName,
      "orderStatus": orderStatus,
      "priorityName": priorityName,
      "assignedCardiologistName": assignedCardiologistName,
      "assignedCardiologistId": assignedCardiologistId,

      "medicalRecordNumber": medicalRecordNumber,
      "clinicalNote": clinicalNote,
      "ekgReport": ekgReport,
      "createdAt": createdAt,
      "age": age,
      "genderValue": genderValue,
      "clinicName": clinicName,
      "createdByGpName": createdByGpName,
      "cardioNote": cardioNote,

      "approvalLevels": approvalLevels?.map((e) => e.toJson()).toList(),
    };
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

class ApprovalLevel {
  final int? approverUserId;
  final int? approvalLevel;
  final int? approverPocId;

  ApprovalLevel({this.approverUserId, this.approvalLevel, this.approverPocId});

  factory ApprovalLevel.fromJson(Map<String, dynamic> json) {
    return ApprovalLevel(
      approverUserId: json["approverUserId"],
      approvalLevel: json["approvalLevel"],
      approverPocId: json["approverPocId"],
    );
  }

  Map<String, dynamic> toJson() => {
    "approverUserId": approverUserId,
    "approvalLevel": approvalLevel,
    "approverPocId": approverPocId,
  };
}

extension MyOrderModelCopy on MyOrderModel {
  MyOrderModel copyWith({
    int? orderDetailsId,
    String? patientName,
    String? orderStatus,
    String? priorityName,
    String? assignedCardiologistName,
    String? assignedCardiologistId,
    String? medicalRecordNumber,
    String? clinicalNote,
    String? ekgReport,
    String? createdAt,
    int? age,
    String? genderValue,
    String? clinicName,
    String? createdByGpName,
    String? cardioNote,
    List<ApprovalLevel>? approvalLevels,
  }) {
    return MyOrderModel(
      orderDetailsId: orderDetailsId ?? this.orderDetailsId,
      patientName: patientName ?? this.patientName,
      orderStatus: orderStatus ?? this.orderStatus,
      priorityName: priorityName ?? this.priorityName,
      assignedCardiologistName:
          assignedCardiologistName ?? this.assignedCardiologistName,
      assignedCardiologistId:
          assignedCardiologistId ?? this.assignedCardiologistId,
      medicalRecordNumber: medicalRecordNumber ?? this.medicalRecordNumber,
      clinicalNote: clinicalNote ?? this.clinicalNote,
      ekgReport: ekgReport ?? this.ekgReport,
      createdAt: createdAt ?? this.createdAt,
      age: age ?? this.age,
      genderValue: genderValue ?? this.genderValue,
      clinicName: clinicName ?? this.clinicName,
      createdByGpName: createdByGpName ?? this.createdByGpName,
      cardioNote: cardioNote ?? this.cardioNote,
      approvalLevels: approvalLevels ?? this.approvalLevels,
    );
  }
}
