import 'package:cardio_tech/src/data/loginAuth/auth_service.dart';
import 'package:cardio_tech/src/features/generalPhysicianScreens/home/widgets/custom_textfield.dart';
import 'package:cardio_tech/src/features/generalPhysicianScreens/home/widgets/gradient_button.dart';
import 'package:cardio_tech/src/features/auth/screens/loginScreens/otp_verification_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dio/dio.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController forgotPassEmailController = TextEditingController();
  final AuthService _authService = AuthService();
  bool isLoading = false;

  void _sendOtp() async {
    final input = forgotPassEmailController.text.trim();
    if (input.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter email or mobile")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final Response response = await _authService.forgotPassword(input);
      final message = response.data is String
          ? response.data
          : response.data['message'] ?? "OTP sent successfully";

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OtpVerificationScreen(emailOrMobile: input),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
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
            child: Image.asset("assets/images/login/login_bg.png", fit: BoxFit.cover),
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
                            "Forgot Password",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 20),
                          CustomTextField(
                            label: "Mobile or Email",
                            hint: "Enter Email Or Mobile No.",
                            controller: forgotPassEmailController,
                          ),
                          const SizedBox(height: 20),
                          GradientButton(
                            text: isLoading ? "Sending..." : "Send OTP",
                            onPressed: isLoading ? null : _sendOtp,
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
