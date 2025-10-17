import 'package:cardio_tech/src/features/home/widgets/custom_textfield.dart';
import 'package:cardio_tech/src/features/home/widgets/gradient_button.dart';
import 'package:cardio_tech/src/routes/AllRoutes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SetNewPasswordScreen extends StatefulWidget {
  const SetNewPasswordScreen({super.key});

  @override
  State<SetNewPasswordScreen> createState() => _SetNewPasswordScreenState();
}

class _SetNewPasswordScreenState extends State<SetNewPasswordScreen> {
  bool newPasswordVisible = false;
  bool confirmPasswordVisible = false;

  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final FocusNode newPasswordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // for auto enable field
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   newPasswordFocusNode.requestFocus();
    // });
  }

  @override
  void dispose() {
    newPasswordFocusNode.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _showSuccessModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              SvgPicture.asset("assets/images/login/checked.svg"),
              const SizedBox(height: 24),
              const Text(
                "Your Password has been Changed successfully",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: GradientButton(
                  text: "Continue",
                  onPressed: () {
                    Navigator.of(context).pop(); // close modal
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.login,
                      (route) => false,
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/images/login/login_bg.png",
              fit: BoxFit.cover,
            ),
          ),

          // Logo
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 100),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SvgPicture.asset("assets/images/login/heartbeat.svg"),
                  SvgPicture.asset("assets/images/login/cardio.svg"),
                ],
              ),
            ),
          ),

          // Bottom form container
          Align(
            alignment: Alignment.bottomCenter,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  width: double.infinity,
                  height: constraints.maxHeight * 0.65,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(40),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: SafeArea(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Set New Password",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 20),

                            CustomTextField(
                              label: "New Password",
                              hint: "********",
                              obscureText: !newPasswordVisible,
                              controller: newPasswordController,
                              focusNode: newPasswordFocusNode,
                              isPassword: true,
                              togglePassword: () {
                                setState(() {
                                  newPasswordVisible = !newPasswordVisible;
                                });
                              },
                            ),
                            const SizedBox(height: 16),

                            CustomTextField(
                              label: "Confirm Password",
                              hint: "********",
                              obscureText: !confirmPasswordVisible,
                              controller: confirmPasswordController,
                              isPassword: true,
                              togglePassword: () {
                                setState(() {
                                  confirmPasswordVisible =
                                      !confirmPasswordVisible;
                                });
                              },
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Password must be at least 8 characteres long",
                              style: TextStyle(color: Colors.red),
                            ),

                            const SizedBox(height: 20),
                            GradientButton(
                              text: "Set Password",
                              onPressed: () {
                                _showSuccessModal();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
