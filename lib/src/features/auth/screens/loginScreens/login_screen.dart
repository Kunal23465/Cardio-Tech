import 'package:cardio_tech/src/data/loginAuth/auth_repository.dart';
import 'package:cardio_tech/src/features/cardiologistScreens/home/widgets/CardiologistNavbar.dart';
import 'package:cardio_tech/src/features/generalPhysicianScreens/home/widgets/custom_textfield.dart';
import 'package:cardio_tech/src/features/auth/screens/loginScreens/forgot_password_screen.dart';
import 'package:cardio_tech/src/features/generalPhysicianScreens/home/widgets/gradient_button.dart';
import 'package:cardio_tech/src/features/generalPhysicianScreens/home/widgets/navbar.dart';
import 'package:cardio_tech/src/utils/storage_helper.dart';
import 'package:cardio_tech/src/utils/snackbar_helper.dart';
import 'package:cardio_tech/src/core/network/exceptions.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FocusNode emailFocusNode = FocusNode();
  bool rememberMe = false;
  bool passwordVisible = false;
  bool isLoading = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadRememberMe();
  }

  /// Load saved credentials if Remember Me is checked
  Future<void> _loadRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      rememberMe = prefs.getBool('rememberMe') ?? false;
      if (rememberMe) {
        emailController.text = prefs.getString('email') ?? '';
        passwordController.text = prefs.getString('password') ?? '';
      }
    });
  }

  /// Save or clear Remember Me preferences
  Future<void> _saveLoginPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    if (rememberMe) {
      await prefs.setBool('rememberMe', true);
      await prefs.setString('email', emailController.text);
      await prefs.setString('password', passwordController.text);
    } else {
      await prefs.remove('rememberMe');
      await prefs.remove('email');
      await prefs.remove('password');
    }
  }

  /// Handle Login with proper error catching and SnackBars
  Future<void> _handleLogin() async {
    final repo = AuthRepository();

    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      SnackBarHelper.show(
        context,
        message: "Please enter email and password",
        type: SnackBarType.warning,
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final success = await repo.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (success) {
        await _saveLoginPrefs();

        final staffType = await StorageHelper.getStaffType();
        final userId = await StorageHelper.getUserId();

        print(" Login success for UserID: $userId, Staff Type: $staffType");

        if (!mounted) return;

        SnackBarHelper.show(
          context,
          message: "Login successful!",
          type: SnackBarType.success,
        );

        // Navigate based on user role
        if (staffType == "CARDIO_TECH_SUPPORT") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const Cardiologistnavbar()),
          );
        } else if (staffType == "GENERAL_PHYSICIAN") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const Navbar()),
          );
        } else {
          SnackBarHelper.show(
            context,
            message: "Unknown role. Contact admin.",
            type: SnackBarType.warning,
          );
        }
      } else {
        SnackBarHelper.show(
          context,
          message: "Invalid credentials or server error",
          type: SnackBarType.error,
        );
      }
    } on ApiException catch (e) {
      SnackBarHelper.show(
        context,
        message: e.message,
        type: SnackBarType.error,
      );
    } catch (e) {
      SnackBarHelper.show(
        context,
        message: "Unexpected error: $e",
        type: SnackBarType.error,
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
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
                              "Log In",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 20),
                            CustomTextField(
                              label: "Email",
                              hint: "Enter Email",
                              controller: emailController,
                              focusNode: emailFocusNode,
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              label: "Password",
                              hint: "********",
                              obscureText: !passwordVisible,
                              controller: passwordController,
                              isPassword: true,
                              togglePassword: () {
                                setState(() {
                                  passwordVisible = !passwordVisible;
                                });
                              },
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Checkbox(
                                      value: rememberMe,
                                      onChanged: (val) {
                                        setState(() {
                                          rememberMe = val ?? false;
                                        });
                                      },
                                    ),
                                    const Text("Remember me"),
                                  ],
                                ),
                                Flexible(
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              const ForgotPasswordScreen(),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      "Forgot Password ?",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            isLoading
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : GradientButton(
                                    text: "Log In",
                                    onPressed: _handleLogin,
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
