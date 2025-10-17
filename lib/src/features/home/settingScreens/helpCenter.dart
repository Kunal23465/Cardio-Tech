import 'package:cardio_tech/src/features/home/widgets/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HelpCenter extends StatefulWidget {
  const HelpCenter({super.key});

  @override
  State<HelpCenter> createState() => _HelpCenterState();
}

class _HelpCenterState extends State<HelpCenter> {
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
          'Help Center',
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
                  image: AssetImage("assets/images/setting/helpCenter.png"),
                  // fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),

            Text(
              "FAQs",
              style: TextStyle(
                // color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 12),

            Text(
              "Our FAQ section provides quick answers to commonly asked questions about using Cardio tech. From account setup to ECG uploads, users can easily find guidance. This section is regularly updated to address new features and common troubleshooting issues, ensuring physicians, cardiologists, and clinics save time and resolve queries quickly",
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              "Contact Support",
              style: TextStyle(
                // color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 12),

            Text(
              "For personalized assistance, our dedicated support team is available to help resolve issues. Users can reach us through email, live chat, or phone support. We ensure quick response times and clear solutions, minimizing disruptions in your workflow so physicians and cardiologists can stay focused on patient care without unnecessary delays",
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              "Troubleshooting",
              style: TextStyle(
                // color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 12),

            Text(
              "If you face technical difficulties, the troubleshooting section walks you through step-by-step solutions. Covering login errors, file uploads, and connectivity problems, this resource empowers users to solve problems independently. Each guide is crafted in simple language so clinics, technicians, and doctors can continue working without interruptions or delays in patient services",
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 24),

            Text(
              "Support Principles",
              style: TextStyle(
                // color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 16),

            _highlightCard(
              "Reliable Support",
              title: "Support Number : +61-98765-43210",
              desc: "We provide responsive, dependable assistance...",
            ),
            _highlightCard(
              "Fast Response",
              title: "Email : support@cardio tech.com",
              desc:
                  "All activities must comply with healthcare laws, digital regulations, and clinical standards, protecting both patients and providers on the platform",
            ),
            _highlightCard(
              "Transparency",
              title: "Website : www.cardio tech.com",
              desc:
                  "We maintain clear communication about issues, updates, and solutions, helping users trust our support team with accurate, honest, and helpful guidance",
            ),
            _highlightCard(
              "Restrictions",
              desc:
                  "Unauthorized use, misrepresentation, or misuse of the platform is strictly prohibited, ensuring trust, safety, and compliance at every stage",
            ),
          ],
        ),
      ),
    );
  }

  //  Card Widget
  Widget _highlightCard(String number, {String? title, required String desc}) {
    return Container(
      width: double.infinity,
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
          if (title != null && title.isNotEmpty) ...[
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
          ],
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
