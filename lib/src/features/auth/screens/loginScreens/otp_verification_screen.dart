import 'package:cardio_tech/src/data/loginAuth/auth_service.dart';
import 'package:cardio_tech/src/features/generalPhysicianScreens/home/widgets/custom_textfield.dart';
import 'package:cardio_tech/src/features/generalPhysicianScreens/home/widgets/gradient_button.dart';
import 'package:cardio_tech/src/routes/AllRoutes.dart';
import 'package:cardio_tech/src/utils/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String emailOrMobile;
  const OtpVerificationScreen({super.key, required this.emailOrMobile});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController otpController = TextEditingController();
  final AuthService _authService = AuthService();
  bool isLoading = false;

  void _verifyOtp() async {
    final otp = otpController.text.trim();

    if (otp.isEmpty) {
      SnackBarHelper.show(
        context,
        message: "Enter OTP",
        type: SnackBarType.warning,
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await _authService.verifyOtp(widget.emailOrMobile, otp);

      final message = response.data is String
          ? response.data
          : response.data['message'] ?? "OTP Verified";

      SnackBarHelper.show(
        context,
        message: message,
        type: SnackBarType.success,
      );

      if (!mounted) return;

      Navigator.pushNamed(
        context,
        AppRoutes.setNewPassword,
        arguments: widget.emailOrMobile,
      );
    } catch (e) {
      SnackBarHelper.show(
        context,
        message: "Error: $e",
        type: SnackBarType.error,
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
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
          Align(
            alignment: Alignment.bottomCenter,
            child: LayoutBuilder(
              builder: (context, constraints) => Container(
                width: double.infinity,
                height: constraints.maxHeight * 0.65,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
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
                            "Enter the 6-digit code sent to your email/mobile",
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          const SizedBox(height: 30),
                          CustomTextField(
                            label: "OTP",
                            hint: "Enter OTP",
                            controller: otpController,
                          ),
                          const SizedBox(height: 20),
                          GradientButton(
                            text: isLoading ? "Verifying..." : "Verify",
                            onPressed: isLoading ? null : _verifyOtp,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
