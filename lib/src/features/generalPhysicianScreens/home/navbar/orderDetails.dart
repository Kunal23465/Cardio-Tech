import 'package:cardio_tech/src/data/generalPhysician/models/all_patient/OrderFilterModel.dart';
import 'package:cardio_tech/src/features/generalPhysicianScreens/home/widgets/custom_textfield.dart';
import 'package:cardio_tech/src/features/generalPhysicianScreens/home/widgets/gradient_button.dart';
import 'package:cardio_tech/src/provider/generalPhysicianProvider/allPatient/downloadEkgReportProvider.dart';
import 'package:cardio_tech/src/provider/generalPhysicianProvider/allPatient/submitOrderDetailsProvider.dart';
import 'package:cardio_tech/src/utils/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cardio_tech/src/features/generalPhysicianScreens/home/widgets/theme.dart';
import 'package:provider/provider.dart';

class Orderdetails extends StatefulWidget {
  const Orderdetails({super.key});

  @override
  State<Orderdetails> createState() => _OrderdetailsState();
}

class _OrderdetailsState extends State<Orderdetails> {
  late SubmitOrderDetailsProvider submitProvider;
  late DownloadEkgReportProvider downloadProvider;

  @override
  void initState() {
    super.initState();

    submitProvider = Provider.of<SubmitOrderDetailsProvider>(
      context,
      listen: false,
    );
    downloadProvider = Provider.of<DownloadEkgReportProvider>(
      context,
      listen: false,
    );

    downloadProvider.addListener(() {
      if (!mounted) return;

      if (downloadProvider.isLoading) return;

      if (downloadProvider.isSuccess) {
        SnackBarHelper.show(
          context,
          message: "EKG Report downloaded successfully!",
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
        return;
      }
    });

    /// Submit order listeners (leave as is)
    submitProvider.addListener(() {
      if (!mounted) return;

      if (submitProvider.isSuccess) {
        SnackBarHelper.show(
          context,
          message: "Order closed successfully",
          type: SnackBarType.success,
        );
        submitProvider.reset();
      } else if (submitProvider.errorMessage != null) {
        SnackBarHelper.show(
          context,
          message: "Failed to close order: ${submitProvider.errorMessage}",
          type: SnackBarType.error,
        );
        submitProvider.reset();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final order =
        ModalRoute.of(context)!.settings.arguments as OrderFilterModel;

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
          child: Container(
            width: double.infinity,
            height: 1,
            color: AppColors.primary,
          ),
        ),
      ),

      // Body
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Patient Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: AssetImage(
                      'assets/images/people/user.png',
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Patient Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.patientName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            SvgPicture.asset('assets/icon/user.svg'),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                "MRN : ${order.medicalRecordNumber}",
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.primary,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.all(1.5),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.secondary],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        order.orderStatus ?? '',
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

            // Appointment Info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date Row
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
                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset('assets/icon/hospital.svg'),
                          const SizedBox(width: 6),
                          Text(
                            order.assignedCardiologistName ?? '',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Consumer<DownloadEkgReportProvider>(
              builder: (context, downloadProvider, _) {
                return downloadProvider.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      )
                    : CustomTextField(
                        label: "EKG Report",
                        fieldType: FieldType.download,
                        controller: TextEditingController(
                          text: order.ekgReportName ?? '',
                        ),
                        onDownload: () {
                          final fileId = order.uploadInsuranceIDProof;

                          if (fileId == null || fileId.isEmpty) {
                            SnackBarHelper.show(
                              context,
                              message: "EKG Report not available",
                              type: SnackBarType.error,
                            );
                            return;
                          }

                          downloadProvider.downloadEkgReport(fileId);
                        },
                      );
              },
            ),

            const SizedBox(height: 30),
            CustomTextField(
              label: "Clinical Note",
              hint: "Clinical Note",
              controller: TextEditingController(text: order.clinicalNote ?? ''),
              fieldType: FieldType.note,
              enabled: false,
            ),
            const SizedBox(height: 30),

            if (order.orderStatus == "FINALIZED")
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: GradientButton(
                      text: 'Cancel',
                      isOutlined: true,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: GradientButton(
                      text: 'Close Order',
                      onPressed: () {
                        submitProvider.submitOrderDetails(
                          orderDetailsId: order.orderDetailsId,
                        );
                      },
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
