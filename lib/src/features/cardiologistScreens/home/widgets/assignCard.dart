import 'package:flutter/material.dart';
import 'package:cardio_tech/src/features/generalPhysicianScreens/home/widgets/custom_textfield.dart';
import 'package:cardio_tech/src/features/generalPhysicianScreens/home/widgets/gradient_button.dart';
import 'package:cardio_tech/src/features/generalPhysicianScreens/home/widgets/theme.dart';
import 'package:cardio_tech/src/utils/snackbar_helper.dart';

class AssignCard extends StatefulWidget {
  final String hospitalName;

  const AssignCard({Key? key, required this.hospitalName}) : super(key: key);

  @override
  State<AssignCard> createState() => _AssignCardState();
}

class _AssignCardState extends State<AssignCard> {
  final TextEditingController mobileController = TextEditingController();
  String? selectedDoctor;
  String? selectedDepartment;

  final List<String> doctors = [
    "Lucknow Multi Clinic",
    "Max Multi Clinic",
    "Kanpur Multi Clinic",
  ];

  final List<String> departments = [
    "Dr. A. Sharma",
    "Dr. P. Mehta",
    "Dr. R. Singh",
  ];

  @override
  void dispose() {
    mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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

            CustomTextField(
              label: "Clinic ",
              fieldType: FieldType.dropdown,
              dropdownItems: doctors,
              selectedValue: selectedDoctor,
              onChanged: (value) {
                setState(() => selectedDoctor = value);
              },
            ),
            const SizedBox(height: 16),

            CustomTextField(
              label: "Cardiologist ",
              fieldType: FieldType.dropdown,
              dropdownItems: departments,
              selectedValue: selectedDepartment,
              onChanged: (value) {
                setState(() => selectedDepartment = value);
              },
            ),
            const SizedBox(height: 16),

            CustomTextField(
              label: "Reason ",
              hint: "Enter Reason",
              controller: mobileController,
            ),
            const SizedBox(height: 20),

            GradientButton(
              text: "Confirm Assignment",
              onPressed: () {
                if (mobileController.text.isEmpty ||
                    selectedDoctor == null ||
                    selectedDepartment == null) {
                  SnackBarHelper.show(
                    context,
                    message: "Please fill all required fields",
                    type: SnackBarType.error,
                  );
                  return;
                }

                Navigator.pop(context);

                SnackBarHelper.show(
                  context,
                  message:
                      "Assigned to $selectedDoctor (${selectedDepartment ?? 'N/A'})",
                  type: SnackBarType.success,
                );
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
