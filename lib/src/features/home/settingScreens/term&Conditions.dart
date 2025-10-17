import 'package:cardio_tech/src/features/home/widgets/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TermConditions extends StatefulWidget {
  const TermConditions({super.key});

  @override
  State<TermConditions> createState() => _TermConditionsState();
}

class _TermConditionsState extends State<TermConditions> {
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
          'Terms & Conditions',
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
                  image: AssetImage(
                    "assets/images/setting/term&conditions.png",
                  ),
                  // fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),

            Text(
              "Our Assurance",
              style: TextStyle(
                // color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 12),

            Text(
              "We are committed to providing a safe, secure, and transparent platform for healthcare professionals. Cardio tech ensures reliable communication between physicians, cardiologists, and clinics, respecting medical ethics, patient confidentiality, and legal requirements. Our goal is to empower users with efficient workflows while maintaining compliance and trust at every step of collaboration",
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              "User Responsibilities",
              style: TextStyle(
                // color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 12),

            Text(
              "Users are expected to provide accurate details, maintain patient confidentiality, and follow ethical medical practices when using the platform. Misuse, misrepresentation, or negligence is strictly prohibited. Physicians, cardiologists, and staff must use Cardio tech responsibly to ensure that case management, reporting, and patient care are always handled with professionalism and accountability",
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              "Usage Rights",
              style: TextStyle(
                // color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 12),

            Text(
              "Role-based access ensures each user can only access features relevant to their responsibilities. Physicians, cardiologists, technicians, and clinics are granted permissions according to their roles, preventing unauthorized access. This structured control strengthens security, maintains compliance, and allows smooth workflows across the platform while protecting sensitive data and ensuring accountability for all actions",
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 24),

            Text(
              "Guiding Principles",
              style: TextStyle(
                // color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 16),

            _highlightCard(
              "Fair Use",
              "Users must follow ethical medical practices and platform guidelines, ensuring safe usage, accurate reporting, and trusted collaboration across all cases",
            ),
            _highlightCard(
              "Legal Compliance",
              "All activities must comply with healthcare laws, digital regulations, and clinical standards, protecting both patients and providers on the platform",
            ),
            _highlightCard(
              "Accountability",
              "Every action is logged for transparency, making users accountable for responsible data handling, report accuracy, and ethical platform interactionsV",
            ),
            _highlightCard(
              "Restrictions",
              "Unauthorized use, misrepresentation, or misuse of the platform is strictly prohibited, ensuring trust, safety, and compliance at every stage",
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
