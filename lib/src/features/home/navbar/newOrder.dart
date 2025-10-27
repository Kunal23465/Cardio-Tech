import 'package:cardio_tech/src/features/home/widgets/gradient_button.dart';
import 'package:cardio_tech/src/features/home/widgets/custom_textfield.dart';
import 'package:cardio_tech/src/features/home/widgets/theme.dart';
import 'package:cardio_tech/src/provider/new_order/all_cardiologist_provider.dart';
import 'package:cardio_tech/src/provider/new_order/order_priority_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:provider/provider.dart';

class NewOrder extends StatefulWidget {
  const NewOrder({super.key});

  @override
  State<NewOrder> createState() => _NewOrderState();
}

class _NewOrderState extends State<NewOrder> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final nameController = TextEditingController();
  final dobController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final medicalRecordController = TextEditingController();
  final clinicalNoteController = TextEditingController();
  final insuranceIdController = TextEditingController();

  DateTime? selectedDate;
  bool _enterIdManually = false;

  final TextRecognizer _textRecognizer = TextRecognizer();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CardiologistProvider>().fetchCardiologists();
      context.read<OrderPriorityProvider>().fetchOrderPriorities();
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        dobController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  void _extractAndFillFields(String text) {
    final lines = text
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    if (lines.isNotEmpty) {
      final firstLine = lines.first;
      if (firstLine.contains(',')) {
        final parts = firstLine.split(',');
        nameController.text = parts.length == 2
            ? '${parts[1].trim()} ${parts[0].trim()}'
            : firstLine;
      } else {
        nameController.text = firstLine;
      }
    }

    final dobMatch = RegExp(
      r'(?:DOB|D\.O\.B|Date of Birth|Birth Date)[:\s]*(\d{2}[/-]\d{2}[/-]\d{4}|\d{4}[/-]\d{2}[/-]\d{2})',
      caseSensitive: false,
    ).firstMatch(text);
    final extractedDob = dobMatch?.group(1)?.trim();
    if (extractedDob != null) {
      dobController.text = extractedDob;
    }
  }

  @override
  void dispose() {
    _textRecognizer.close();
    nameController.dispose();
    dobController.dispose();
    mobileController.dispose();
    emailController.dispose();
    medicalRecordController.dispose();
    clinicalNoteController.dispose();
    insuranceIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cardioProvider = context.watch<CardiologistProvider>();
    final priorityProvider = context.watch<OrderPriorityProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: SvgPicture.asset('assets/icon/backbutton.svg'),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: Text(
          'New Order',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            width: double.infinity,
            height: 1,
            color: AppColors.primary,
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    label: "Name",
                    hint: "Enter Your Name",
                    controller: nameController,
                    validator: (value) => value == null || value.isEmpty
                        ? "Please enter name"
                        : null,
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: CustomTextField(
                        label: "Date of Birth",
                        hint: "Select DOB",
                        controller: dobController,
                        fieldType: FieldType.dob,
                        validator: (value) => value == null || value.isEmpty
                            ? "Please select DOB"
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: "Gender",
                    fieldType: FieldType.dropdown,
                    hint: 'Select',
                    dropdownItems: ["Male", "Female", "Other"],
                    selectedValue: null,
                    onChanged: (val) {},
                    validator: (value) => value == null || value.isEmpty
                        ? "Please select gender"
                        : null,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: "Mobile Number",
                    hint: "Enter Phone No.",
                    controller: mobileController,
                    validator: (value) => value == null || value.isEmpty
                        ? "Please enter mobile number"
                        : null,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: "Email",
                    hint: "Enter Email Address",
                    controller: emailController,
                    validator: (value) => value == null || value.isEmpty
                        ? "Please enter email"
                        : null,
                  ),
                  const SizedBox(height: 16),
                  _enterIdManually
                      ? CustomTextField(
                          label: "Insurance ID *",
                          hint: "Enter Insurance ID",
                          controller: insuranceIdController,
                          validator: (value) => value == null || value.isEmpty
                              ? "Please enter Insurance ID"
                              : null,
                        )
                      : CustomTextField(
                          label: "Upload Insurance ID *",
                          hint: "Choose ID File",
                          fieldType: FieldType.file,
                        ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _enterIdManually = !_enterIdManually;
                      });
                    },
                    child: Text(
                      _enterIdManually
                          ? "Upload Insurance ID Instead"
                          : "Enter ID Details Manually",
                      style: const TextStyle(color: AppColors.primary),
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: "Medical Record Number *",
                    hint: "Enter Medical Record Number",
                    controller: medicalRecordController,
                    validator: (value) => value == null || value.isEmpty
                        ? "Please enter medical record number"
                        : null,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: "Clinical Note *",
                    hint: "Enter Clinical Note",
                    controller: clinicalNoteController,
                    fieldType: FieldType.note,
                    validator: (value) => value == null || value.isEmpty
                        ? "Please enter clinical note"
                        : null,
                  ),
                  const SizedBox(height: 16),

                  /// Order Priority Dropdown
                  priorityProvider.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : CustomTextField(
                          label: "Select Order Priority *",
                          hint: 'Select',
                          fieldType: FieldType.dropdown,
                          dropdownItems: priorityProvider.priorities
                              .map((e) => e.priorityName)
                              .toList(),
                          selectedValue: null,
                          onChanged: (val) {},
                        ),
                  const SizedBox(height: 16),

                  /// Cardiologist Dropdown
                  cardioProvider.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : CustomTextField(
                          label: "Cardiologist *",
                          hint: 'Select',
                          fieldType: FieldType.dropdown,
                          dropdownItems: cardioProvider.cardiologists
                              .map((e) => e.fullName)
                              .toList(),
                          selectedValue: cardioProvider.selected?.fullName,
                          onChanged: (val) {
                            final selected = cardioProvider.cardiologists
                                .firstWhere((e) => e.fullName == val);
                            cardioProvider.selectCardiologist(selected);
                          },
                        ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: GradientButton(
                          text: 'Save Order',
                          isOutlined: true,
                          onPressed: () {},
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: GradientButton(
                          text: 'Submit Order',
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 150),
                ],
              ),
            ),
          ),

          /// Overlay loader
          if (cardioProvider.isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
