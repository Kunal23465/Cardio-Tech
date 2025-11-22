import 'package:cardio_tech/src/data/cardioLogists/model/myOrderModel.dart';
import 'package:cardio_tech/src/provider/generalPhysicianProvider/allPatient/downloadEkgReportProvider.dart';
import 'package:cardio_tech/src/utils/snackbar_helper.dart';
import 'package:cardio_tech/src/features/generalPhysicianScreens/home/widgets/custom_textfield.dart';
import 'package:cardio_tech/src/features/generalPhysicianScreens/home/widgets/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class CardiologistOrderDetails extends StatefulWidget {
  const CardiologistOrderDetails({super.key});

  @override
  State<CardiologistOrderDetails> createState() =>
      _CardiologistOrderDetailsState();
}

class _CardiologistOrderDetailsState extends State<CardiologistOrderDetails> {
  late DownloadEkgReportProvider downloadProvider;

  @override
  void initState() {
    super.initState();

    downloadProvider = Provider.of<DownloadEkgReportProvider>(
      context,
      listen: false,
    );

    /// EKG Download Listener
    downloadProvider.addListener(() {
      if (!mounted) return;

      if (downloadProvider.isLoading) return;

      if (downloadProvider.isSuccess) {
        SnackBarHelper.show(
          context,
          message: "Report downloaded successfully!",
          type: SnackBarType.success,
        );
        downloadProvider.reset();
        return;
      }

      if (downloadProvider.errorMessage != null) {
        SnackBarHelper.show(
          context,
          message: downloadProvider.errorMessage!,
          type: SnackBarType.error,
        );
        downloadProvider.reset();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final MyOrderModel order =
        ModalRoute.of(context)!.settings.arguments as MyOrderModel;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: SvgPicture.asset('assets/icon/backbutton.svg'),
        ),
        title: Text(
          'Order Details',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(height: 1, color: AppColors.primary),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// ---------------------- PATIENT CARD ----------------------
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  /// Avatar
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: AssetImage(
                      'assets/images/people/user.png',
                    ),
                  ),
                  const SizedBox(width: 16),

                  /// Patient Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.patientName ?? "",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            SvgPicture.asset('assets/icon/user.svg'),
                            SizedBox(width: 6),
                            Text(
                              "MRN: ${order.medicalRecordNumber ?? ''}",
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  /// Status Badge
                  Container(
                    padding: EdgeInsets.all(1.5),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.secondary],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        order.orderStatus ?? "",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// ---------------------- APPOINTMENT INFO ----------------------
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// Date
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset('assets/icon/calendar1.svg'),
                          const SizedBox(width: 6),
                          Text(
                            order.createdAt ?? '',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      if (order.priorityName == "High Priority")
                        const Icon(Icons.circle, color: Colors.red, size: 10),
                    ],
                  ),

                  SizedBox(height: 12),

                  Row(
                    children: [
                      SvgPicture.asset('assets/icon/hospital.svg'),
                      SizedBox(width: 8),
                      Text(
                        order.clinicName ?? "",
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            /// ---------------------- EKG DOWNLOAD ----------------------
            Consumer<DownloadEkgReportProvider>(
              builder: (context, dp, _) {
                return dp.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      )
                    : CustomTextField(
                        label: "EKG Report",
                        controller: TextEditingController(
                          text: order.ekgReport ?? "",
                        ),
                        fieldType: FieldType.download,
                        onDownload: () {
                          if (order.ekgReport == null ||
                              order.ekgReport!.isEmpty) {
                            return SnackBarHelper.show(
                              context,
                              message: "EKG Report not available",
                              type: SnackBarType.error,
                            );
                          }

                          downloadProvider.downloadEkgReport(order.ekgReport!);
                        },
                      );
              },
            ),

            const SizedBox(height: 25),

            CustomTextField(
              label: "Clinical Note",
              controller: TextEditingController(text: order.clinicalNote ?? ""),
              fieldType: FieldType.note,
              enabled: false,
            ),
          ],
        ),
      ),
    );
  }
}
