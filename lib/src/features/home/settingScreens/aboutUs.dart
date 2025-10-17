import 'package:cardio_tech/src/features/home/widgets/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Aboutus extends StatefulWidget {
  const Aboutus({super.key});

  @override
  State<Aboutus> createState() => _AboutusState();
}

class _AboutusState extends State<Aboutus> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgPicture.asset('assets/icon/backbutton.svg'),
        ),
        title: Text(
          'About Us',
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: const DecorationImage(
                  image: AssetImage("assets/images/setting/aboutUs.png"),
                  // fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),

            Text(
              "Who We Are",
              style: TextStyle(
                // color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 12),

            Text(
              "Cardio tech is a smart healthcare platform designed to strengthen collaboration between General Physicians and Cardiologists. Our mission is to simplify the process of sharing ECGs, reviewing cases, and delivering accurate reports, ensuring that patients receive the best possible care without delays.\n\n"
              "With Cardio tech, physicians can securely upload ECGs and patient details, while cardiologists can quickly review, analyze, and finalize reports. The platform provides real-time tracking, allowing both doctors and clinics to monitor the progress of every case. Built with role-based access, secure data sharing, and compliance-ready workflows, Cardio tech ensures medical accuracy and accountability at every step.\n\n"
              "By connecting clinics, technicians, and specialists on one platform, we bridge communication gaps and reduce turnaround time for critical diagnoses. Our goal is to empower healthcare providers with speed, transparency, and reliability—helping them save lives through timely cardiac care.",
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 24),

            Text(
              "Our Key Highlights",
              style: TextStyle(
                // color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 16),

            _highlightCard(
              "200+",
              "Active Clinics",
              "Easily onboard clinics and doctors with quick setup, ensuring smooth connections, secure access, and hassle-free collaboration across the platform",
            ),
            _highlightCard(
              "500+",
              "Reports Finalized",
              "Every ECG report is carefully reviewed by specialists and securely shared with physicians, ensuring accuracy, reliability, and timely cardiac diagnosis",
            ),
            _highlightCard(
              "800+",
              "Verified Cardiologists",
              "Verified cardiologists deliver expert insights instantly, supporting physicians with accurate interpretations and timely decisions for improved patient cardiac care",
            ),
          ],
        ),
      ),
    );
  }

  //  Card Widget
  Widget _highlightCard(String number, String title, String desc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEef7f5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            number,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            desc,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black54,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
