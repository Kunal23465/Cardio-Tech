import 'package:cardio_tech/src/core/config/api_constants.dart';
import 'package:cardio_tech/src/data/cardioLogists/model/allOrders/cardioAllOrderModel.dart';
import 'package:cardio_tech/src/provider/generalPhysicianProvider/allPatient/downloadEkgReportProvider.dart';
import 'package:cardio_tech/src/utils/snackbar_helper.dart';
import 'package:cardio_tech/src/features/generalPhysicianScreens/home/widgets/custom_textfield.dart';
import 'package:cardio_tech/src/features/generalPhysicianScreens/home/widgets/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class AllOrderOrderDetails extends StatefulWidget {
  const AllOrderOrderDetails({super.key});

  @override
  State<AllOrderOrderDetails> createState() => _AllOrderOrderDetailsState();
}

class _AllOrderOrderDetailsState extends State<AllOrderOrderDetails> {
  late DownloadEkgReportProvider downloadProvider;

  bool _isPdf(String fileName) {
    return fileName.toLowerCase().endsWith(".pdf");
  }

  bool _isImage(String fileName) {
    return fileName.toLowerCase().endsWith(".png") ||
        fileName.toLowerCase().endsWith(".jpg") ||
        fileName.toLowerCase().endsWith(".jpeg");
  }

  bool showPreview = false;
  String fileUrl = "";
  bool isPdf = false;
  bool isImage = false;

  String buildFileUrl(String fileName) {
    if (fileName.startsWith("http://") || fileName.startsWith("https://")) {
      return fileName;
    }

    final candidate1 = "${ApiConstants.downloadEkgReport}/$fileName";
    final candidate2 = "${ApiConstants.downloadEkgReport}?fileName=$fileName";

    // Use candidate1 by default. If it doesn't work for you, try candidate2.
    debugPrint("buildFileUrl -> candidate1: $candidate1");
    debugPrint("buildFileUrl -> candidate2: $candidate2 (alternative)");

    return candidate1;
  }

  @override
  void initState() {
    super.initState();

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final order =
          ModalRoute.of(context)!.settings.arguments as CardioAllOrderModel;

      final fileName = order.ekgReport ?? "";

      if (fileName.isNotEmpty) {
        fileUrl = buildFileUrl(fileName);
        debugPrint("FINAL FILE URL => $fileUrl");

        isPdf = _isPdf(fileName);
        isImage = _isImage(fileName);

        setState(() {
          showPreview = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final CardioAllOrderModel order =
        ModalRoute.of(context)!.settings.arguments as CardioAllOrderModel;

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

            if (showPreview) ...[
              SizedBox(height: 20),

              Stack(
                children: [
                  // PDF VIEWER
                  if (isPdf)
                    Container(
                      height: 400,
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
                      child: SfPdfViewer.network(
                        fileUrl,
                        canShowScrollHead: true,
                        canShowPaginationDialog: true,
                      ),
                    ),

                  // IMAGE VIEWER
                  if (isImage)
                    Container(
                      height: 400,
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
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: InteractiveViewer(
                          panEnabled: true,
                          minScale: 1,
                          maxScale: 5,
                          child: Image.network(fileUrl, fit: BoxFit.contain),
                        ),
                      ),
                    ),

                  // Download Button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Consumer<DownloadEkgReportProvider>(
                      builder: (context, downloadProvider, _) {
                        return downloadProvider.isLoading
                            ? CircularProgressIndicator(
                                color: AppColors.primary,
                              )
                            : GestureDetector(
                                onTap: () {
                                  final fileId = order.ekgReport;

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
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.8),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.download,
                                    // color: AppColors.primary,
                                    color: Colors.grey,
                                    size: 24,
                                  ),
                                ),
                              );
                      },
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16),
            ],

            CustomTextField(
              label: "Clinical Note",
              controller: TextEditingController(text: order.clinicalNote ?? ""),
              fieldType: FieldType.note,
              enabled: false,
            ),
            SizedBox(height: 16),

            CustomTextField(
              label: "Cardiologists Note",
              controller: TextEditingController(text: order.cardioNote ?? ""),
              fieldType: FieldType.note,
              enabled: false,
            ),
          ],
        ),
      ),
    );
  }
}
