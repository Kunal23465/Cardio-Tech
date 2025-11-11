import 'package:cardio_tech/src/data/cardioLogists/model/myOrderModel.dart';
import 'package:cardio_tech/src/provider/cardioLogistsProvider/assignCardioProvider.dart';
import 'package:cardio_tech/src/provider/cardioLogistsProvider/assignOrderProvider.dart';
import 'package:cardio_tech/src/provider/cardioLogistsProvider/assignClinicProvider.dart';
import 'package:cardio_tech/src/provider/cardioLogistsProvider/myOrderProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cardio_tech/src/features/generalPhysicianScreens/home/widgets/custom_textfield.dart';
import 'package:cardio_tech/src/features/generalPhysicianScreens/home/widgets/gradient_button.dart';
import 'package:cardio_tech/src/features/generalPhysicianScreens/home/widgets/theme.dart';
import 'package:cardio_tech/src/utils/snackbar_helper.dart';

class AssignCard extends StatefulWidget {
  final MyOrderModel order;

  const AssignCard({Key? key, required this.order}) : super(key: key);

  @override
  State<AssignCard> createState() => _AssignCardState();
}

class _AssignCardState extends State<AssignCard> {
  final TextEditingController reasonController = TextEditingController();
  String? selectedClinic;
  String? selectedCardiologist;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<AssignClinicProvider>(context, listen: false).fetchClinics();
    });
  }

  @override
  void dispose() {
    reasonController.dispose();
    super.dispose();
  }

  //  Handle Submit Function
  Future<void> handleSubmit(BuildContext context) async {
    final cardiologistProvider = context.read<AssignCardiologistProvider>();
    final assignOrderProvider = context.read<AssignOrderProvider>();

    if (reasonController.text.isEmpty ||
        selectedClinic == null ||
        selectedCardiologist == null) {
      SnackBarHelper.show(
        context,
        message: "Please fill all required fields",
        type: SnackBarType.error,
      );
      return;
    }

    try {
      final selectedCardioObj = cardiologistProvider.cardiologists.firstWhere(
        (e) => e.fullName == selectedCardiologist,
      );

      final orderDetailsId = widget.order.orderDetailsId;
      final fromCardiologistId =
          int.tryParse(widget.order.assignedCardiologistId ?? '0') ?? 0;

      final toCardiologistId = selectedCardioObj.pointsOfContactDetailsId;

      final success = await assignOrderProvider.assignOrder(
        orderDetailsId: orderDetailsId,
        fromCardiologistId: fromCardiologistId,
        toCardiologistId: toCardiologistId,
        reason: reasonController.text.trim(),
      );

      if (success) {
        Navigator.pop(context, true);
        SnackBarHelper.show(
          context,
          message:
              "Successfully assigned to $selectedCardiologist at $selectedClinic",
          type: SnackBarType.success,
        );
      } else {
        SnackBarHelper.show(
          context,
          message: "Assignment failed. Please try again.",
          type: SnackBarType.error,
        );
      }
    } catch (e) {
      SnackBarHelper.show(
        context,
        message: "Error: ${e.toString()}",
        type: SnackBarType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final clinicProvider = context.watch<AssignClinicProvider>();
    final cardiologistProvider = context.watch<AssignCardiologistProvider>();
    final assignOrderProvider = context.watch<AssignOrderProvider>();
    final orderDataProvider = context.watch<MyOrderProvider>();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                height: 4,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Assign Patient",
              style: TextStyle(
                color: appTheme().primaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 20),

            // --- Clinic Dropdown ---
            CustomTextField(
              label: "Clinic",
              fieldType: FieldType.dropdown,
              dropdownItems: clinicProvider.clinics
                  .map((e) => e.clinicName)
                  .toList(),
              selectedValue: selectedClinic,
              onChanged: (value) async {
                setState(() {
                  selectedClinic = value;
                  selectedCardiologist = null;
                });

                final selectedClinicObj = clinicProvider.clinics.firstWhere(
                  (e) => e.clinicName == value,
                );

                await cardiologistProvider.fetchCardiologists(
                  selectedClinicObj.clinicId,
                );
              },
            ),

            if (clinicProvider.isLoading)
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              ),

            const SizedBox(height: 16),

            // --- Cardiologist Dropdown ---
            CustomTextField(
              label: "Cardiologist",
              fieldType: FieldType.dropdown,
              dropdownItems: cardiologistProvider.cardiologists
                  .map((c) => c.fullName)
                  .toList(),
              selectedValue: selectedCardiologist,
              onChanged: (value) {
                setState(() => selectedCardiologist = value);
              },
            ),

            if (cardiologistProvider.isLoading)
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              ),

            const SizedBox(height: 16),

            CustomTextField(
              label: "Reason",
              hint: "Enter Reason",
              controller: reasonController,
            ),

            const SizedBox(height: 20),

            GradientButton(
              text: assignOrderProvider.isLoading ? "Assigning..." : "Confirm",
              onPressed: assignOrderProvider.isLoading
                  ? null
                  : () => handleSubmit(context),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
