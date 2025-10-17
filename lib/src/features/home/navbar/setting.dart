import 'package:cardio_tech/src/features/home/widgets/gradient_button.dart';
import 'package:cardio_tech/src/routes/AllRoutes.dart';
import 'package:flutter/material.dart';
import 'package:cardio_tech/src/features/home/widgets/theme.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  Widget buildSettingTile({
    required String svgPath,
    required String title,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: Color(0xFFEef7f5),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: SvgPicture.asset(svgPath, width: 25, height: 25),
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        onTap: onTap,
      ),
    );
  }

  Widget buildLogoutTile() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.red.shade100,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: SvgPicture.asset('assets/images/setting/logout.svg'),
          ),
        ),
        title: const Text(
          'Logout',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
        onTap: () async {
          // Confirm logout with dialog
          final shouldLogout = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Logout Confirmation"),
              content: const Text("Are you sure you want to logout?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text(
                    "Logout",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          );

          if (shouldLogout == true) {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setBool('isLoggedIn', false);

            if (!mounted) return;
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.login,
              (route) => false,
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Settings",
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

      body: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: const CircleAvatar(
                radius: 28,
                backgroundImage: AssetImage("assets/images/people/image_1.png"),
              ),
              title: const Text(
                "Dr. Kunal Mishra",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              subtitle: const Text(
                "Cardiologist, Lucknow UP.",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              trailing: GradientButton(
                text: 'View',
                width: 80,
                height: 30,
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.viewProfile);
                },
              ),
            ),

            Container(
              width: double.infinity,
              height: 1,
              color: Colors.grey.shade300,
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                children: [
                  buildSettingTile(
                    svgPath: "assets/images/setting/password.svg",
                    title: "Change Password",
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.changePassword);
                    },
                  ),
                  buildSettingTile(
                    svgPath: "assets/images/setting/about.svg",
                    title: "About us",
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.aboutUs);
                    },
                  ),
                  buildSettingTile(
                    svgPath: "assets/images/setting/privacy.svg",
                    title: "Privacy Policy",
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.privacyPolicy);
                    },
                  ),
                  buildSettingTile(
                    svgPath: "assets/images/setting/terms.svg",
                    title: "Terms and Conditions",
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.termConditions);
                    },
                  ),
                  buildSettingTile(
                    svgPath: "assets/images/setting/help.svg",
                    title: "Help Center",
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.helpCenter);
                    },
                  ),

                  const SizedBox(height: 20),

                  buildLogoutTile(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
