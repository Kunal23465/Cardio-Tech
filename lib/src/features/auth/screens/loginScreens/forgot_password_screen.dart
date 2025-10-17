import 'package:cardio_tech/src/features/home/widgets/custom_textfield.dart';
import 'package:cardio_tech/src/features/auth/screens/loginScreens/otp_verification_screen.dart';
import 'package:cardio_tech/src/features/home/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final FocusNode forgotPassEmailFocusNode = FocusNode();
  final TextEditingController forgotPassEmailController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    // for auto enable field
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   forgotPassEmailFocusNode.requestFocus();
    // });
  }

  @override
  void dispose() {
    forgotPassEmailFocusNode.dispose();
    forgotPassEmailController.dispose();
    super.dispose();
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
                              "Forgot Password",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 20),

                            CustomTextField(
                              label: "Mobile or Email",
                              hint: "Enter Email Or Mobile No.",
                              focusNode: forgotPassEmailFocusNode,
                              controller: forgotPassEmailController,
                            ),

                            const SizedBox(height: 20),

                            GradientButton(
                              text: "Send OTP",
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const OtpVerificationScreen(),
                                  ),
                                );
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
