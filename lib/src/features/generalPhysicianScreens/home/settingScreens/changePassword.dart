import 'package:cardio_tech/src/features/generalPhysicianScreens/home/widgets/custom_textfield.dart';
import 'package:cardio_tech/src/features/generalPhysicianScreens/home/widgets/theme.dart';
import 'package:cardio_tech/src/provider/generalPhysicianProvider/commons/changePassword/changePasswordProvider.dart';
import 'package:cardio_tech/src/utils/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cardio_tech/src/features/generalPhysicianScreens/home/widgets/gradient_button.dart';
import 'package:provider/provider.dart';

class Changepassword extends StatefulWidget {
  const Changepassword({super.key});

  @override
  State<Changepassword> createState() => _ChangepasswordState();
}

class _ChangepasswordState extends State<Changepassword> {
  bool passwordVisible = false;
  bool confirmPasswordVisible = false;

  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  void _showMessage(String msg, {bool isError = false}) {
    SnackBarHelper.show(
      context,
      message: msg, // MUST be a String
      type: isError ? SnackBarType.error : SnackBarType.success,
    );
  }

  void handleUpdate() async {
    final provider = Provider.of<ChangePasswordProvider>(
      context,
      listen: false,
    );

    // Validations
    if (currentPasswordController.text.trim().isEmpty) {
      _showMessage("Enter current password", isError: true);
      return;
    }
    if (newPasswordController.text.trim().isEmpty) {
      _showMessage("Enter new password", isError: true);
      return;
    }
    if (confirmPasswordController.text.trim().isEmpty) {
      _showMessage("Confirm your password", isError: true);
      return;
    }
    if (newPasswordController.text.trim() !=
        confirmPasswordController.text.trim()) {
      _showMessage("New password & confirm password must match", isError: true);
      return;
    }

    // API CALL
    bool success = await provider.updatePassword(
      currentPassword: currentPasswordController.text.trim(),
      newPassword: newPasswordController.text.trim(),
      confirmPassword: confirmPasswordController.text.trim(),
    );

    // RESPONSE
    if (success) {
      _showMessage(provider.message ?? "Password changed successfully");
      Navigator.pop(context);
    } else {
      _showMessage(provider.message ?? "Password update failed", isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset("assets/icon/backbutton.svg"),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Change Password",
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.primary),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            CustomTextField(
              label: "Current Password",
              hint: "********",
              controller: currentPasswordController,
              obscureText: true,
            ),

            const SizedBox(height: 16),

            CustomTextField(
              label: "New Password",
              hint: "********",
              controller: newPasswordController,
              obscureText: !passwordVisible,
              isPassword: true,
              togglePassword: () {
                setState(() => passwordVisible = !passwordVisible);
              },
            ),

            const SizedBox(height: 16),

            CustomTextField(
              label: "Confirm Password",
              hint: "********",
              controller: confirmPasswordController,
              obscureText: !confirmPasswordVisible,
              isPassword: true,
              togglePassword: () {
                setState(
                  () => confirmPasswordVisible = !confirmPasswordVisible,
                );
              },
            ),

            const SizedBox(height: 30),

            Consumer<ChangePasswordProvider>(
              builder: (_, provider, __) {
                return provider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : GradientButton(
                        text: "Change Password",
                        onPressed: handleUpdate,
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}
