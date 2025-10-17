import 'package:cardio_tech/src/features/home/widgets/custom_textfield.dart';
import 'package:cardio_tech/src/features/auth/screens/loginScreens/setNewPasswordScreen.dart';
import 'package:cardio_tech/src/features/home/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final FocusNode optVerificationFocusNode = FocusNode();
  final TextEditingController optVerificationController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    // for auto enable
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   optVerificationFocusNode.requestFocus();
    // });
  }

  @override
  void dispose() {
    optVerificationFocusNode.dispose();
    optVerificationController.dispose();
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

          //logo
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
                              "OTP Verification",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Enter the 6-digit code that we have sent via the phone number +708113484",
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                            const SizedBox(height: 30),

                            CustomTextField(
                              label: "OTP",
                              hint: "Enter OTP",
                              focusNode: optVerificationFocusNode,
                              controller: optVerificationController,
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'OTP verification failed',
                              style: TextStyle(color: Colors.red),
                            ),
                            const SizedBox(height: 20),
                            // ElevatedButton(
                            //   onPressed: () {},
                            //   style: ElevatedButton.styleFrom(
                            //     backgroundColor: Colors.white,
                            //     minimumSize: const Size(double.infinity, 50),

                            //     elevation: 0, // Flat look
                            //   ),
                            //   child: const Text(
                            //     'Send OTP',
                            //     style: TextStyle(
                            //       fontSize: 16,
                            //       fontWeight: FontWeight.w600,
                            //     ),
                            //   ),
                            // ),
                            GradientButton(
                              text: 'Send Otp',
                              isOutlined: true,

                              onPressed: () {},
                            ),

                            const SizedBox(height: 10),

                            GradientButton(
                              text: "Verify",
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        SetNewPasswordScreen(),
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
