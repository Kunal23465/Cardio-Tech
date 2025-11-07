import 'package:flutter/material.dart';
import 'package:cardio_tech/src/features/cardiologistScreens/home/widgets/imageEditor.dart';

class ReportOrder extends StatelessWidget {
  const ReportOrder({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;

    if (args == null || args is! Map<String, dynamic>) {
      return const Scaffold(
        body: Center(
          child: Text(
            "No order data received.",
            style: TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    final String? ekgReport = args['ekgReport']?.toString();
    final String? clinicalNote = args['clinicalNote']?.toString();
    final String? patientName = args['patientName']?.toString();
    final int orderId = args['orderId'] ?? 0;
    final List<dynamic>? approvalLevels = args['approvalLevels'];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: (ekgReport != null && ekgReport.isNotEmpty)
            ? ImageEditor(
                imagePath: ekgReport,
                clinicalNote: clinicalNote ?? "",
                patientName: patientName ?? "Unknown",
                orderId: orderId,
                approvalLevels: approvalLevels,
              )
            : const Center(
                child: Text(
                  "No EKG report available for this order",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
      ),
    );
  }
}
