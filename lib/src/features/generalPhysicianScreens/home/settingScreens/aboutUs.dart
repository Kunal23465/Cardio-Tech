import 'package:cardio_tech/src/features/generalPhysicianScreens/home/widgets/theme.dart';
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
          onPressed: () => Navigator.pop(context),
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

      // Responsive Body
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isWeb = constraints.maxWidth > 600; // breakpoint

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isWeb ? 80 : 16,
              vertical: 20,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: isWeb ? 300 : 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        image: const DecorationImage(
                          image: AssetImage(
                            "assets/images/setting/aboutUs.png",
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    Text(
                      "Who We Are",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: isWeb ? 28 : 20,
                      ),
                    ),
                    const SizedBox(height: 12),

                    Text(
                      "Cardio tech is a smart healthcare platform designed to strengthen collaboration between General Physicians and Cardiologists. Our mission is to simplify the process of sharing ECGs, reviewing cases, and delivering accurate reports, ensuring that patients receive the best possible care without delays.\n\n"
                      "With Cardio tech, physicians can securely upload ECGs and patient details, while cardiologists can quickly review, analyze, and finalize reports. The platform provides real-time tracking, allowing both doctors and clinics to monitor the progress of every case. Built with role-based access, secure data sharing, and compliance-ready workflows, Cardio tech ensures medical accuracy and accountability at every step.\n\n"
                      "By connecting clinics, technicians, and specialists on one platform, we bridge communication gaps and reduce turnaround time for critical diagnoses. Our goal is to empower healthcare providers with speed, transparency, and reliability—helping them save lives through timely cardiac care.",
                      style: TextStyle(
                        fontSize: isWeb ? 16 : 14,
                        color: Colors.black87,
                        height: 1.6,
                      ),
                    ),

                    const SizedBox(height: 30),

                    Text(
                      "Our Key Highlights",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: isWeb ? 28 : 20,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Responsive: Grid for Web, Column for Mobile
                    isWeb
                        ? GridView.count(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            crossAxisCount: 3,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                            childAspectRatio: 0.9,
                            children: [
                              _highlightCard(
                                "200+",
                                "Active Clinics",
                                "Easily onboard clinics and doctors with quick setup, ensuring secure collaboration across the platform",
                              ),
                              _highlightCard(
                                "500+",
                                "Reports Finalized",
                                "Specialists review every ECG report carefully, providing accurate and timely cardiac diagnosis",
                              ),
                              _highlightCard(
                                "800+",
                                "Verified Cardiologists",
                                "Expert cardiologists provide quick and accurate interpretations to support physicians",
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              _highlightCard(
                                "200+",
                                "Active Clinics",
                                "Easily onboard clinics and doctors with quick setup, ensuring secure collaboration across the platform",
                              ),
                              _highlightCard(
                                "500+",
                                "Reports Finalized",
                                "Specialists review every ECG report carefully, providing accurate and timely cardiac diagnosis",
                              ),
                              _highlightCard(
                                "800+",
                                "Verified Cardiologists",
                                "Expert cardiologists provide quick and accurate interpretations to support physicians",
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Responsive Card
  Widget _highlightCard(String number, String title, String desc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFEef7f5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            number,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            desc,
            style: const TextStyle(
              fontSize: 14,
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
