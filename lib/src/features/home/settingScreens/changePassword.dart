import 'package:cardio_tech/src/features/home/widgets/custom_textfield.dart';
import 'package:cardio_tech/src/features/home/widgets/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cardio_tech/src/features/home/widgets/gradient_button.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset("assets/icon/backbutton.svg"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Change Password",
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
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

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            CustomTextField(
              label: "Current Password",
              hint: 'kunal@123',
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
                setState(() {
                  passwordVisible = !passwordVisible;
                });
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
                setState(() {
                  confirmPasswordVisible = !confirmPasswordVisible;
                });
              },
            ),
            const SizedBox(height: 30),

            GradientButton(text: "Change Password", onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
