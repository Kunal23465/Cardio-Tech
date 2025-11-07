import 'dart:io';

class OrderAttachmentModel {
  final int orderDetailsId;
  final File? ekgReport;
  final File? uploadInsuranceIDProof;

  OrderAttachmentModel({
    required this.orderDetailsId,
    this.ekgReport,
    this.uploadInsuranceIDProof,
  });
}
