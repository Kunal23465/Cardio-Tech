import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:cardio_tech/src/features/generalPhysicianScreens/home/widgets/custom_textfield.dart';
import 'package:cardio_tech/src/features/generalPhysicianScreens/home/widgets/theme.dart';
import 'package:cardio_tech/src/features/generalPhysicianScreens/home/widgets/gradient_button.dart';

import 'package:cardio_tech/src/provider/generalPhysicianProvider/commons/editProfile.dart/editProfileProvider.dart';
import 'package:cardio_tech/src/provider/generalPhysicianProvider/commons/editProfile.dart/uploadProfileProvider.dart';
import 'package:cardio_tech/src/provider/user/loggedInUserDetailsProvider.dart';
import 'package:cardio_tech/src/provider/generalPhysicianProvider/commons/editProfile.dart/experienceProvider.dart';

import 'package:cardio_tech/src/data/generalPhysician/models/editProfile/editProfileModel.dart';
import 'package:cardio_tech/src/utils/snackbar_helper.dart';
import 'package:cardio_tech/src/utils/storage_helper.dart';

class Editprofile extends StatefulWidget {
  const Editprofile({super.key});

  @override
  State<Editprofile> createState() => _EditprofileState();
}

class _EditprofileState extends State<Editprofile> {
  // Controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final aboutController = TextEditingController();
  final aboutLicenseNo = TextEditingController();

  int? selectedExperienceId;

  File? selectedImage;

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final userId = await StorageHelper.getUserId();

      if (userId != null) {
        final userProvider = context.read<LoggedInUserDetailsProvider>();
        final experienceProvider = context.read<ExperienceProvider>();

        await userProvider.fetchLoggedInUserDetails(userId: userId);
        final user = userProvider.userDetails;

        await experienceProvider.loadExperiences();

        if (user != null) {
          firstNameController.text = user.firstName ?? "";
          lastNameController.text = user.lastName ?? "";
          fullNameController.text = user.CardioName;
          phoneController.text = user.mobile;
          emailController.text = user.email;
          addressController.text = user.userAddress;
          aboutController.text = user.about ?? "";
          aboutLicenseNo.text = user.licenseNo ?? "";

          if (user.totalExperience != null &&
              user.totalExperience!.isNotEmpty) {
            final exp = RegExp(r'\d+').stringMatch(user.totalExperience!);

            if (exp != null) {
              final parsed = int.tryParse(exp);

              // check exist in list
              final exist = experienceProvider.experienceList.any(
                (e) => e.commonLookupValueDetailsId == parsed,
              );

              if (exist) {
                selectedExperienceId = parsed;
              } else {
                selectedExperienceId = null;
              }
            }
          }
        }
      }
    });
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    fullNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    aboutController.dispose();
    aboutLicenseNo.dispose();
    super.dispose();
  }

  /// PICK IMAGE
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        selectedImage = File(picked.path);
      });
    }
  }

  Future<void> handleUpdate() async {
    final userId = await StorageHelper.getUserId();
    if (userId == null) return;

    final editProvider = context.read<EditProfileProvider>();
    final uploadProvider = context.read<UploadProfileProvider>();
    final userProvider = context.read<LoggedInUserDetailsProvider>();
    final user = userProvider.userDetails;
    if (user == null) return;

    // Prepare model with StorageHelper userId
    EditProfileModel model = EditProfileModel(
      userDetailsId: int.parse(
        userId.toString(),
      ), // send this to EditProfile API
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      pocPhone: phoneController.text,
      pocEmail: emailController.text,
      address: addressController.text,
      licenseNo: aboutLicenseNo.text,
      about: aboutController.text,
      experienceLookupId: selectedExperienceId,
    );

    // Call update profile API
    final updateSuccess = await editProvider.updateProfile(model);
    if (!updateSuccess) {
      SnackBarHelper.show(
        context,
        message: "Failed to update profile",
        type: SnackBarType.error,
      );
      return;
    }

    //  Get returned userDetailsId from provider
    final updatedUserId = editProvider.updatedUserDetailsId.toString();
    print("Updated userDetailsId = $updatedUserId");

    // Upload image using returned userDetailsId
    if (selectedImage != null) {
      final uploadSuccess = await uploadProvider.uploadProfile(
        userId: updatedUserId,
        file: selectedImage!,
      );

      if (!uploadSuccess) {
        SnackBarHelper.show(
          context,
          message: "Profile updated but image upload failed!",
          type: SnackBarType.error,
        );
      }
    }

    await userProvider.fetchLoggedInUserDetails(userId: userId);

    SnackBarHelper.show(
      context,
      message: "Profile updated successfully",
      type: SnackBarType.success,
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<LoggedInUserDetailsProvider>();
    final user = userProvider.userDetails;

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: SvgPicture.asset("assets/icon/backbutton.svg"),
        ),
        title: Text(
          'Edit Profile',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            width: double.infinity,
            height: 1,
            color: AppColors.primary,
          ),
        ),
      ),

      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    // onTap: pickImage,
                    child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: selectedImage != null
                                  ? FileImage(selectedImage!)
                                  : (user.profilePic != null &&
                                        user.profilePic!.isNotEmpty)
                                  ? NetworkImage(user.profilePic!)
                                  : const AssetImage(
                                          "assets/images/people/avatar.png",
                                        )
                                        as ImageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 10,
                          left: 10,
                          child: GestureDetector(
                            onTap: pickImage,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                // color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: SvgPicture.asset(
                                'assets/images/setting/editProfile.svg',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  CustomTextField(
                    label: "First Name",
                    controller: firstNameController,
                  ),
                  const SizedBox(height: 16),

                  CustomTextField(
                    label: "Last Name",
                    controller: lastNameController,
                  ),
                  const SizedBox(height: 16),

                  CustomTextField(
                    label: "Full Name",
                    controller: fullNameController,
                  ),
                  const SizedBox(height: 16),

                  CustomTextField(label: "Phone", controller: phoneController),
                  const SizedBox(height: 16),

                  CustomTextField(label: "Email", controller: emailController),
                  const SizedBox(height: 16),

                  CustomTextField(
                    label: "Address",
                    controller: addressController,
                  ),
                  const SizedBox(height: 16),

                  CustomTextField(
                    label: "License No",
                    controller: aboutLicenseNo,
                  ),
                  const SizedBox(height: 16),

                  CustomTextField(
                    label: "About",
                    controller: aboutController,
                    fieldType: FieldType.note,
                  ),
                  const SizedBox(height: 20),

                  // EXPERIENCE DROPDOWN
                  Consumer<ExperienceProvider>(
                    builder: (context, expProvider, child) {
                      return expProvider.experienceList.isEmpty
                          ? const CircularProgressIndicator()
                          : CustomTextField(
                              label: "Experience",
                              fieldType: FieldType.dropdown,
                              dropdownItems: expProvider.experienceList
                                  .map((e) => e.value)
                                  .toList(),
                              selectedValue: selectedExperienceId != null
                                  ? expProvider.experienceList
                                        .firstWhere(
                                          (e) =>
                                              e.commonLookupValueDetailsId ==
                                              selectedExperienceId,
                                          orElse: () =>
                                              expProvider.experienceList.first,
                                        )
                                        .value
                                  : null,

                              onChanged: (val) {
                                final selected = expProvider.experienceList
                                    .firstWhere(
                                      (e) => e.value == val,
                                      orElse: () =>
                                          expProvider.experienceList.first,
                                    );

                                setState(() {
                                  selectedExperienceId =
                                      selected.commonLookupValueDetailsId;
                                });

                                expProvider.setSelectedExperience(selected);
                              },
                            );
                    },
                  ),

                  const SizedBox(height: 20),

                  // BUTTONS
                  Row(
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
                        child: Consumer<EditProfileProvider>(
                          builder: (context, provider, child) {
                            return GradientButton(
                              text: provider.isLoading
                                  ? "Updating..."
                                  : "Update",
                              onPressed: provider.isLoading
                                  ? null
                                  : () => handleUpdate(),
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
