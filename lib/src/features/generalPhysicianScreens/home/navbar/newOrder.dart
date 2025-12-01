import 'dart:io';
import 'package:cardio_tech/src/data/generalPhysician/models/New_order/create_order_model.dart';
import 'package:cardio_tech/src/features/generalPhysicianScreens/home/widgets/gradient_button.dart';
import 'package:cardio_tech/src/features/generalPhysicianScreens/home/widgets/custom_textfield.dart';
import 'package:cardio_tech/src/features/generalPhysicianScreens/home/widgets/theme.dart';
import 'package:cardio_tech/src/provider/generalPhysicianProvider/allPatient/getOrderByIdProvider.dart';
import 'package:cardio_tech/src/provider/generalPhysicianProvider/new_order/all_cardiologist_provider.dart';
import 'package:cardio_tech/src/provider/generalPhysicianProvider/new_order/create_order_provider.dart';
import 'package:cardio_tech/src/provider/generalPhysicianProvider/new_order/gender_provider.dart';
import 'package:cardio_tech/src/provider/generalPhysicianProvider/new_order/order_priority_provider.dart';
import 'package:cardio_tech/src/routes/AllRoutes.dart';
import 'package:cardio_tech/src/utils/snackbar_helper.dart';
import 'package:cardio_tech/src/utils/storage_helper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class NewOrder extends StatefulWidget {
  final int? orderId;
  const NewOrder({super.key, this.orderId});

  @override
  State<NewOrder> createState() => _NewOrderState();
}

class _NewOrderState extends State<NewOrder> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final dobController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final medicalRecordController = TextEditingController();
  final clinicalNoteController = TextEditingController();
  final insuranceIdController = TextEditingController();
  String? ekgReportUrl;
  String? insuranceProofUrl;

  int? selectedGenderId;
  int? selectedPriorityId;
  int? selectedCardiologistId;

  DateTime? selectedDate;
  bool _enterIdManually = false;

  File? ekgReport;
  File? uploadInsuranceIDProof;
  bool _isEditingNameDob = false;

  final TextRecognizer _textRecognizer = TextRecognizer(
    script: TextRecognitionScript.latin,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<GenderProvider>().fetchGender();
      await context.read<OrderPriorityProvider>().fetchOrderPriorities();
      await context.read<CardiologistProvider>().fetchCardiologists();

      final orderId = widget.orderId;
      if (orderId != null) {
        await context.read<GetOrderByIdProvider>().fetchOrderById(orderId);
        final order = context.read<GetOrderByIdProvider>().order;
        if (order != null) {
          setState(() {
            nameController.text = order.patientName;
            dobController.text = order.dateOfBirth;
            mobileController.text = order.mobileNumber;
            emailController.text = order.email;
            insuranceIdController.text = order.insuranceIdNo;
            medicalRecordController.text = order.medicalRecordNumber;
            clinicalNoteController.text = order.clinicalNote;
            selectedGenderId = order.genderId;
            selectedPriorityId = order.priorityId;
            selectedCardiologistId = order.assignedCardiologistId;

            ekgReportUrl = order.ekgReport;
            insuranceProofUrl = order.uploadInsuranceIDProof;
          });
        }
      }
    });
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
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

  void _extractAndFillFields(String fullText) {
    final text = fullText.replaceAll('\n', ' ').replaceAll(',', ' ').trim();

    final nameRegex = RegExp(
      r'([A-Z][a-z]+(?:\s+[A-Z][a-z]+)*)\s*ID\s*[:\-]?\s*\d+',
      caseSensitive: false,
    );
    final dobRegex = RegExp(
      r'(?:DOB|Date\s*of\s*Birth)\s*[:\-]?\s*(\d{1,2}[\/\-\.]\d{1,2}[\/\-\.]\d{2,4})',
      caseSensitive: false,
    );
    final genderRegex = RegExp(r'\b(Male|Female|M|F)\b', caseSensitive: false);

    final nameMatch = nameRegex.firstMatch(text);
    final dobMatch = dobRegex.firstMatch(text);
    final genderMatch = genderRegex.firstMatch(text);

    if (nameMatch != null) {
      nameController.text = nameMatch.group(1)!.trim();
    } else {
      final fallbackName = RegExp(
        r'^([A-Za-z\s]+)\s*ID',
        caseSensitive: false,
      ).firstMatch(text);
      if (fallbackName != null) {
        nameController.text = fallbackName.group(1)!.trim();
      }
    }

    if (dobMatch != null) {
      dobController.text = dobMatch.group(1) ?? '';
    }

    if (genderMatch != null) {
      final gender = genderMatch.group(0)!.toLowerCase();
      if (gender.startsWith('m')) selectedGenderId = 1;
      if (gender.startsWith('f')) selectedGenderId = 2;
    }
  }

  Future<void> _pickEkgAndRunOcr() async {
    final picker = ImagePicker();
    final pickedFile = await showModalBottomSheet<XFile?>(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.blue),
                title: const Text('Capture from Camera'),
                onTap: () async {
                  final photo = await picker.pickImage(
                    source: ImageSource.camera,
                  );
                  Navigator.pop(context, photo);
                },
              ),
              ListTile(
                leading: const Icon(Icons.folder_open, color: Colors.green),
                title: const Text('Choose from Files'),
                onTap: () async {
                  final result = await FilePicker.platform.pickFiles(
                    type: FileType.any,
                  );
                  if (result != null && result.files.single.path != null) {
                    Navigator.pop(context, XFile(result.files.single.path!));
                  } else {
                    Navigator.pop(context, null);
                  }
                },
              ),
            ],
          ),
        );
      },
    );

    if (pickedFile == null) return;

    final inputImage = InputImage.fromFilePath(pickedFile.path);
    final recognizedText = await _textRecognizer.processImage(inputImage);

    _extractAndFillFields(recognizedText.text);

    setState(() => ekgReport = File(pickedFile.path));
  }

  Future<void> _pickInsuranceWithCamera() async {
    final picker = ImagePicker();
    final pickedFile = await showModalBottomSheet<XFile?>(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.blue),
                title: const Text('Capture from Camera'),
                onTap: () async {
                  final photo = await picker.pickImage(
                    source: ImageSource.camera,
                  );
                  Navigator.pop(context, photo);
                },
              ),
              ListTile(
                leading: const Icon(Icons.folder_open, color: Colors.green),
                title: const Text('Choose from Files'),
                onTap: () async {
                  final result = await FilePicker.platform.pickFiles(
                    type: FileType.any,
                  );
                  if (result != null && result.files.single.path != null) {
                    Navigator.pop(context, XFile(result.files.single.path!));
                  } else {
                    Navigator.pop(context, null);
                  }
                },
              ),
            ],
          ),
        );
      },
    );

    if (pickedFile != null) {
      setState(() => uploadInsuranceIDProof = File(pickedFile.path));
    }
  }

  Future<void> _handleOrder({
    required String status,
    required BuildContext context,
  }) async {
    if (!_formKey.currentState!.validate()) return;
    if (ekgReport == null && ekgReportUrl == null) {
      SnackBarHelper.show(
        context,
        message: "Please upload EKG report",
        type: SnackBarType.warning,
      );
      return;
    }

    final createOrderProvider = context.read<CreateOrderProvider>();
    final userId = await StorageHelper.getUserId() ?? 0;
    final existingOrder = context.read<GetOrderByIdProvider>().order;

    String apiDob;
    try {
      final parsed = DateFormat('dd/MM/yyyy').parseStrict(dobController.text);
      apiDob = DateFormat('yyyy-MM-dd').format(parsed);
    } catch (_) {
      apiDob = dobController.text;
    }

    final order = CreateOrderModel(
      // orderDetailsId: existingOrder?.orderDetailsId ?? 0,
      orderDetailsId: widget.orderId == null
          ? 0
          : existingOrder?.orderDetailsId ?? 0,

      patientName: nameController.text,
      dateOfBirth: apiDob,
      genderId: selectedGenderId ?? 0,
      mobileNumber: mobileController.text,
      email: emailController.text,
      insuranceIdNo: insuranceIdController.text,
      medicalRecordNumber: medicalRecordController.text,
      clinicalNote: clinicalNoteController.text,
      priorityId: selectedPriorityId ?? 0,
      assignedCardiologistId: selectedCardiologistId ?? 0,

      approvalLevels: [
        {"approverPocId": selectedCardiologistId ?? 0, "approvalLevel": 1},
      ],

      ekgReport: existingOrder?.ekgReport,
      uploadInsuranceIDProof: existingOrder?.uploadInsuranceIDProof,
    );

    final orderId = await createOrderProvider.createOrSubmitOrder(
      orderModel: order,
      createdById: userId,
      updatedById: userId,
      orderStatus: status,
      ekgReport: ekgReport,
      uploadInsuranceIDProof: uploadInsuranceIDProof,
    );

    if (context.mounted) {
      if (createOrderProvider.isSuccess) {
        SnackBarHelper.show(
          context,
          message: createOrderProvider.message,
          type: SnackBarType.success,
        );
      } else {
        SnackBarHelper.show(
          context,
          message: createOrderProvider.message,
          type: SnackBarType.error,
        );
      }
    }

    if (createOrderProvider.isSuccess && orderId != null) {
      if (existingOrder == null) {
        setState(() {
          nameController.clear();
          dobController.clear();
          mobileController.clear();
          emailController.clear();
          insuranceIdController.clear();
          medicalRecordController.clear();
          clinicalNoteController.clear();
          selectedGenderId = null;
          selectedPriorityId = null;
          selectedCardiologistId = null;
          ekgReport = null;
          uploadInsuranceIDProof = null;
          selectedDate = null;
          _enterIdManually = false;
        });
      }
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.genNavbar,
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cardioProvider = context.watch<CardiologistProvider>();
    final priorityProvider = context.watch<OrderPriorityProvider>();
    final genderProvider = context.watch<GenderProvider>();
    final createOrderProvider = context.watch<CreateOrderProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'New Order',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: SvgPicture.asset('assets/icon/backbutton.svg'),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(height: 1, color: AppColors.primary),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),

            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickEkgAndRunOcr,
                    child: AbsorbPointer(
                      child: CustomTextField(
                        label: "EKG *",
                        fieldType: FieldType.file,
                        hint: ekgReport != null
                            ? ekgReport!.path.split('/').last
                            : (ekgReportUrl != null
                                  ? "Uploaded: ${ekgReportUrl!.split('/').last}"
                                  : "Tap to upload"),

                        controller: TextEditingController(
                          text: ekgReport != null
                              ? ekgReport!.path
                              : (ekgReportUrl ?? ''),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  _enterIdManually
                      ? CustomTextField(
                          label: "Insurance ID",
                          hint: "Enter Insurance ID",
                          controller: insuranceIdController,
                        )
                      : GestureDetector(
                          onTap: _pickInsuranceWithCamera,
                          child: AbsorbPointer(
                            child: CustomTextField(
                              label: "Upload Insurance ID ",
                              fieldType: FieldType.file,
                              hint: uploadInsuranceIDProof != null
                                  ? uploadInsuranceIDProof!.path.split('/').last
                                  : (insuranceProofUrl != null
                                        ? "Uploaded: ${insuranceProofUrl!.split('/').last}"
                                        : "Tap to upload"),

                              controller: TextEditingController(
                                text: uploadInsuranceIDProof != null
                                    ? uploadInsuranceIDProof!.path
                                    : (insuranceProofUrl ?? ''),
                              ),
                            ),
                          ),
                        ),
                  Align(
                    alignment: Alignment.centerLeft,
                    // alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () =>
                          setState(() => _enterIdManually = !_enterIdManually),
                      child: Text(
                        _enterIdManually
                            ? "Upload Insurance ID Instead"
                            : "Enter ID Details Manually",
                        style: const TextStyle(color: AppColors.primary),
                      ),
                    ),
                  ),

                  const SizedBox(height: 6),

                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.secondary],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(1.5),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      "Name",
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    const Text(
                                      " *",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.red, // 🔴 red star
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 4),

                                TextFormField(
                                  controller: nameController,
                                  enabled: _isEditingNameDob,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    hintText: "Enter Name",
                                    border: InputBorder.none,
                                  ),
                                  style: const TextStyle(fontSize: 15),
                                  validator: (v) {
                                    if (v == null || v.trim().isEmpty) {
                                      return "Please Enter Name";
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      "Date of Birth",
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    const Text(
                                      " *",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.red, // 🔴 red star
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                TextFormField(
                                  controller: dobController,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  readOnly: true,
                                  enabled: _isEditingNameDob,
                                  onTap: _isEditingNameDob
                                      ? () => _selectDate(context)
                                      : null,
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    hintText: "Enter DOB",
                                    border: InputBorder.none,
                                  ),
                                  validator: (v) {
                                    if (v == null || v.trim().isEmpty) {
                                      return "DOB is required";
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),

                          IconButton(
                            icon: Icon(
                              _isEditingNameDob
                                  ? Icons.check_circle
                                  : Icons.edit,
                              color: AppColors.primary,
                            ),
                            onPressed: () {
                              setState(
                                () => _isEditingNameDob = !_isEditingNameDob,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: genderProvider.isLoading
                            ? const CircularProgressIndicator()
                            : CustomTextField(
                                label: "Gender *",
                                fieldType: FieldType.dropdown,
                                dropdownItems: genderProvider.genderList
                                    .map((e) => e.value ?? '')
                                    .toList(),
                                selectedValue: selectedGenderId != null
                                    ? genderProvider.genderList
                                          .firstWhere(
                                            (e) => e.id == selectedGenderId,
                                          )
                                          .value
                                    : null,
                                onChanged: (val) {
                                  final selected = genderProvider.genderList
                                      .firstWhere((g) => g.value == val);
                                  setState(
                                    () => selectedGenderId = selected.id,
                                  );
                                },
                                validator: (v) {
                                  if (selectedGenderId == null)
                                    return "Select gender";
                                  return null;
                                },
                              ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: priorityProvider.isLoading
                            ? const CircularProgressIndicator()
                            : CustomTextField(
                                label: "Priority *",
                                fieldType: FieldType.dropdown,
                                dropdownItems: priorityProvider.priorities
                                    .map((e) => e.priorityName)
                                    .toList(),
                                selectedValue: selectedPriorityId != null
                                    ? priorityProvider.priorities
                                          .firstWhere(
                                            (e) =>
                                                e.priorityId ==
                                                selectedPriorityId,
                                          )
                                          .priorityName
                                    : null,
                                onChanged: (val) {
                                  final selected = priorityProvider.priorities
                                      .firstWhere((e) => e.priorityName == val);
                                  setState(
                                    () => selectedPriorityId =
                                        selected.priorityId,
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                  // const SizedBox(width: 12),

                  // genderProvider.isLoading
                  //     ? const CircularProgressIndicator()
                  //     : CustomTextField(
                  //         label: "Gender ",
                  //         fieldType: FieldType.dropdown,
                  //         dropdownItems: genderProvider.genderList
                  //             .map((e) => e.value ?? '')
                  //             .toList(),
                  //         selectedValue: selectedGenderId != null
                  //             ? genderProvider.genderList
                  //                   .firstWhere((e) => e.id == selectedGenderId)
                  //                   .value
                  //             : null,
                  //         onChanged: (val) {
                  //           final selected = genderProvider.genderList
                  //               .firstWhere((g) => g.value == val);
                  //           setState(() => selectedGenderId = selected.id);
                  //         },
                  //         // validator: (v) =>
                  //         //     selectedGenderId == null ? "Select gender" : null,
                  //       ),
                  const SizedBox(height: 16),

                  // CustomTextField(
                  //   label: "Mobile Number",
                  //   hint: "Enter Phone No.",
                  //   controller: mobileController,
                  //   maxLength: 10,
                  //   // inputFormatters: [
                  //   //   FilteringTextInputFormatter.digitsOnly,
                  //   //   LengthLimitingTextInputFormatter(10),
                  //   // ]
                  //   validator: (v) {
                  //     if (v == null || v.isEmpty) {
                  //       return "Enter mobile number";
                  //     } else if (!RegExp(r'^[0-9]{10}$').hasMatch(v)) {
                  //       return "Mobile number must be 10 digits";
                  //     }
                  //     return null;
                  //   },
                  // ),
                  CustomTextField(
                    label: "Medical Record Number *",
                    hint: "Enter MRN",
                    controller: medicalRecordController,

                    validator: (v) =>
                        v == null || v.isEmpty ? "Enter MRN" : null,
                  ),
                  const SizedBox(height: 16),

                  cardioProvider.isLoading
                      ? const CircularProgressIndicator()
                      : CustomTextField(
                          label: "Cardiologist *",
                          fieldType: FieldType.dropdown,
                          dropdownItems: cardioProvider.cardiologists
                              .map((e) => e.fullName)
                              .toList(),
                          selectedValue: selectedCardiologistId != null
                              ? cardioProvider.cardiologists
                                    .firstWhere(
                                      (e) => e.id == selectedCardiologistId,
                                    )
                                    .fullName
                              : null,
                          onChanged: (val) {
                            final selected = cardioProvider.cardiologists
                                .firstWhere((e) => e.fullName == val);
                            setState(
                              () => selectedCardiologistId = selected.id,
                            );
                          },
                        ),
                  const SizedBox(height: 16),

                  CustomTextField(
                    label: "Clinical Note ",
                    hint: "Enter Note",
                    controller: clinicalNoteController,
                    fieldType: FieldType.note,
                    // validator: (v) =>
                    //     v == null || v.isEmpty ? "Enter note" : null,
                  ),

                  // priorityProvider.isLoading
                  //     ? const CircularProgressIndicator()
                  //     : CustomTextField(
                  //         label: "Select Priority ",
                  //         fieldType: FieldType.dropdown,
                  //         dropdownItems: priorityProvider.priorities
                  //             .map((e) => e.priorityName)
                  //             .toList(),
                  //         selectedValue: selectedPriorityId != null
                  //             ? priorityProvider.priorities
                  //                   .firstWhere(
                  //                     (e) => e.priorityId == selectedPriorityId,
                  //                   )
                  //                   .priorityName
                  //             : null,
                  //         onChanged: (val) {
                  //           final selected = priorityProvider.priorities
                  //               .firstWhere((e) => e.priorityName == val);
                  //           setState(
                  //             () => selectedPriorityId = selected.priorityId,
                  //           );
                  //         },
                  //       ),
                  // const SizedBox(height: 16),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: GradientButton(
                          text: 'Save Order',
                          isOutlined: true,
                          onPressed: () => _handleOrder(
                            status: "IN_PROGRESS",
                            context: context,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: GradientButton(
                          text: 'Submit Order',
                          onPressed: () => _handleOrder(
                            status: "SUBMITTED",
                            context: context,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),

          if (createOrderProvider.isLoading)
            Container(
              color: Colors.black26,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}
