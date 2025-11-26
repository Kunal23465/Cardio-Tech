import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_painter/image_painter.dart';
import 'package:cardio_tech/src/features/generalPhysicianScreens/home/widgets/custom_textfield.dart';
import 'package:cardio_tech/src/features/generalPhysicianScreens/home/widgets/gradient_button.dart';
import 'package:cardio_tech/src/features/generalPhysicianScreens/home/widgets/theme.dart';
import 'package:cardio_tech/src/provider/cardioLogistsProvider/cardioSubmitReportProvider.dart';
import 'package:cardio_tech/src/provider/cardioLogistsProvider/myOrderProvider.dart';
import 'package:cardio_tech/src/utils/snackbar_helper.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class ImageEditor extends StatefulWidget {
  final String imagePath;
  final String? clinicalNote;
  final String? patientName;
  final int orderId;
  final List<dynamic>? approvalLevels;

  const ImageEditor({
    super.key,
    required this.imagePath,
    this.clinicalNote,
    this.patientName,
    required this.orderId,
    this.approvalLevels,
  });

  @override
  State<ImageEditor> createState() => _ImageEditorState();
}

class _ImageEditorState extends State<ImageEditor> {
  late final ImagePainterController _controller;
  late TextEditingController _commentController;
  late TextEditingController _clinicNoteFromCardioController;

  @override
  void initState() {
    super.initState();

    // initialize the controller with defaults
    _controller = ImagePainterController(
      strokeWidth: 2.0,
      color: Colors.red,
      mode: PaintMode.freeStyle,
    );

    _commentController = TextEditingController(text: widget.clinicalNote ?? "");
    _clinicNoteFromCardioController = TextEditingController();
  }

  bool get isNetworkImage => widget.imagePath.startsWith("http");

  Future<void> _handleSubmit(BuildContext context) async {
    final provider = context.read<CardioSumbitReportProvider>();
    final orderData = context.read<MyOrderProvider>();

    final Uint8List? image = await _controller.exportImage();

    if (image == null) {
      SnackBarHelper.show(
        context,
        message: "No image data found",
        type: SnackBarType.warning,
      );
      return;
    }

    // Take the latest approval level
    final lastApproval = widget.approvalLevels?.last;
    final approvalLevel = lastApproval?['approvalLevel'] ?? 0;
    final approverPocId = lastApproval?['approverPocId'] ?? 0;

    final result = await provider.submitReport(
      orderId: widget.orderId,
      approvalLevel: approvalLevel,
      approverPocId: approverPocId,
      action: "FINALIZED",
      attachmentBytes: image,
      clinicNoteFromCardio: _clinicNoteFromCardioController.text.trim(),
    );

    if (!mounted) return;

    if (result["success"] == true) {
      SnackBarHelper.show(
        context,
        message: result["message"] ?? "Report submitted successfully!",
        type: SnackBarType.success,
      );

      await orderData.fetchAllOrders();
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) Navigator.pop(context);
    } else {
      SnackBarHelper.show(
        context,
        message: result["message"] ?? "Something went wrong, please try again",
        type: SnackBarType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<CardioSumbitReportProvider>().isLoading;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: SvgPicture.asset("assets/icon/backbutton.svg"),
        ),
        elevation: 0,
        title: Text(
          widget.patientName ?? 'Unknown',
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Divider(height: 1, thickness: 1, color: AppColors.primary),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: isNetworkImage
                        ? ImagePainter.network(
                            widget.imagePath,
                            controller: _controller, //  use controller
                            scalable: true,
                          )
                        : ImagePainter.asset(
                            widget.imagePath,
                            controller: _controller,
                            scalable: true,
                          ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: CustomTextField(
                    label: "Clinical Notes",
                    controller: _commentController,
                    fieldType: FieldType.text,
                    enabled: false,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: CustomTextField(
                    label: "Clinic Note From Cardio",
                    controller: _clinicNoteFromCardioController,
                    fieldType: FieldType.text,
                    enabled: true,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: GradientButton(
                          text: 'Cancel',
                          isOutlined: true,
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: GradientButton(
                          text: 'Submit',
                          onPressed: () => _handleSubmit(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (isLoading)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
