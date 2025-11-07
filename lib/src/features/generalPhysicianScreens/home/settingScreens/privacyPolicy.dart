import 'package:cardio_tech/src/features/generalPhysicianScreens/home/widgets/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Privacypolicy extends StatefulWidget {
  const Privacypolicy({super.key});

  @override
  State<Privacypolicy> createState() => _PrivacypolicyState();
}

class _PrivacypolicyState extends State<Privacypolicy> {
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
          'Privacy Policy',
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
                  image: AssetImage("assets/images/setting/privacyPolicy.png"),
                  // fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),

            Text(
              "Our Commitment",
              style: TextStyle(
                // color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "At Cardio tech, protecting the privacy and security of patient and physician data is our highest priority. Every ECG, medical report, and case shared on our platform is stored with strict confidentiality, safeguarded by advanced encryption, and accessed only by authorized users to ensure complete trust and compliance",
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              "How We Protect Data",
              style: TextStyle(
                // color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "We use advanced security protocols, including end-to-end encryption, secure logins, and strict role-based access controls, to safeguard every piece of medical information shared on our platform. Only authorized users can view or exchange data, ensuring complete confidentiality at all times. Regular audits, monitoring, and updates further strengthen our system’s security, minimizing risks of breaches. By maintaining these safeguards, Cardio tech provides physicians, cardiologists, and patients the assurance that their data is always protected with the highest level of care",
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              "Your Rights",
              style: TextStyle(
                // color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Users have full control over their data, with the ability to update, access, or request deletion anytime. Cardio tech ensures transparency in data usage, building trust through privacy-first practices",
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
              "Data Security",
              "All sensitive medical data is secured with advanced encryption, safe storage, and restricted access, ensuring confidentiality and compliance at every step",
            ),
            _highlightCard(
              "User Privacy",
              "Only verified and authorized users can access data, ensuring strict role-based controls, privacy protection, and accountability across the platform",
            ),
            _highlightCard(
              "Compliance",
              "Our platform strictly follows healthcare privacy laws and regulations, ensuring compliance, patient confidentiality, and secure handling of sensitive medical data",
            ),
          ],
        ),
      ),
    );
  }

  //  Card Widget
  Widget _highlightCard(String number, String desc) {
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
  