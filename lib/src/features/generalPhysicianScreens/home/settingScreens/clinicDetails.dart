import 'package:cardio_tech/src/features/generalPhysicianScreens/home/widgets/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ClinicDetails extends StatefulWidget {
  const ClinicDetails({super.key});

  @override
  State<ClinicDetails> createState() => _ClinicDetailsState();
}

class _ClinicDetailsState extends State<ClinicDetails> {
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
          "Clinic Details",
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "About Clinic",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "No Data",
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _clinicDetailsCard(
                    icon: SvgPicture.asset(
                      // 'assets/images/setting/myProfile/msg.svg',
                      'assets/images/setting/myProfile/hospital.svg',
                    ),
                    text: "No Data",
                  ),

                  _clinicDetailsCard(
                    icon: SvgPicture.asset(
                      // 'assets/images/setting/myProfile/call.svg',
                      'assets/images/setting/myProfile/license.svg',
                    ),
                    text: "No Data",
                  ),

                  _clinicDetailsCard(
                    icon: SvgPicture.asset(
                      'assets/images/setting/myProfile/msg.svg',
                    ),
                    text: "No Data",
                  ),

                  _clinicDetailsCard(
                    icon: SvgPicture.asset(
                      'assets/images/setting/myProfile/call.svg',
                    ),
                    text: "No Data",
                  ),
                  _clinicDetailsCard(
                    icon: SvgPicture.asset(
                      'assets/images/setting/myProfile/location.svg',
                    ),
                    text: "No Data",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _clinicDetailsCard({required SvgPicture icon, required String text}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 14),

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),

      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: Color(0xFFEef7f5),
            shape: BoxShape.circle,
          ),
          child: Center(child: icon),
        ),

        title: Text(text),
      ),
    );
  }
}
