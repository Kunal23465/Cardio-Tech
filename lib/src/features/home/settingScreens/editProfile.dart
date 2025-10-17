import 'package:cardio_tech/src/features/home/widgets/custom_textfield.dart';
import 'package:cardio_tech/src/features/home/widgets/theme.dart';
import 'package:cardio_tech/src/features/home/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Editprofile extends StatefulWidget {
  const Editprofile({super.key});

  @override
  State<Editprofile> createState() => _EditprofileState();
}

class _EditprofileState extends State<Editprofile> {
  final aboutController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  @override
  void dispose() {
    aboutController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
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

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: const DecorationImage(
                      image: AssetImage(
                        "assets/images/setting/profile_pic.png",
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            CustomTextField(
              label: "About Me",
              hint: "Write about yourself",
              controller: aboutController,
            ),
            const SizedBox(height: 16),

            CustomTextField(
              label: "Email",
              hint: "kunalmishra@gmail.com",
              controller: emailController,
            ),
            const SizedBox(height: 16),

            CustomTextField(
              label: "Phone",
              hint: "+91 753951365",
              controller: phoneController,
            ),
            const SizedBox(height: 16),

            CustomTextField(
              label: "Hospital",
              hint: "City Hospital Lucknow, Uttar Pradesh",
              controller: phoneController,
            ),
            const SizedBox(height: 16),

            CustomTextField(
              label: "Address",
              hint: "214 A block Krishna heights Lucknow Up.",
              controller: addressController,
            ),

            const SizedBox(height: 40),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: GradientButton(
                    text: 'Cancel',
                    isOutlined: true,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: GradientButton(text: 'Update', onPressed: () {}),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
