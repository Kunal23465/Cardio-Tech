import 'package:cardio_tech/src/features/home/widgets/theme.dart';
import 'package:cardio_tech/src/features/home/widgets/DashboardCard.dart';
import 'package:cardio_tech/src/features/home/widgets/gradient_button.dart';
import 'package:cardio_tech/src/routes/AllRoutes.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> _dashboardCards = [
    {
      'title': '100',
      'subtitle': 'In Progress',
      'iconPath': 'assets/images/homePage/dashboard/icon1.svg',
    },
    {
      'title': '100',
      'subtitle': 'High Priority Queue',
      'iconPath': 'assets/images/homePage/dashboard/icon2.svg',
    },
    {
      'title': '100',
      'subtitle': 'Total Orders Created',
      'iconPath': 'assets/images/homePage/dashboard/icon3.svg',
    },
    {
      'title': '100',
      'subtitle': 'In Review',
      'iconPath': 'assets/images/homePage/dashboard/icon4.svg',
    },
    {
      'title': '100',
      'subtitle': 'Reports Finalized',
      'iconPath': 'assets/images/homePage/dashboard/icon5.svg',
    },
    {
      'title': '100',
      'subtitle': 'Acknowledged',
      'iconPath': 'assets/images/homePage/dashboard/icon6.svg',
    },
  ];

  final List<String> banners = [
    'assets/images/homePage/banner.png',
    'assets/images/homePage/banner.png',
    'assets/images/homePage/banner.png',
  ];

  int _currentBanner = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 28,
                      backgroundImage: AssetImage(
                        'assets/images/homePage/clinic.png',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Dr. Kunal Multi Clinic",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          "Alambagh, Lucknow Up",
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.notification);
                  },
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Color(0xFFEef7f5),
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset(
                      'assets/images/homePage/notification.svg',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Column(
              children: [
                FlutterCarousel(
                  items: banners.map((banner) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        child: Image.asset(
                          banner,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    );
                  }).toList(),
                  options: FlutterCarouselOptions(
                    height: (MediaQuery.of(context).size.width * 0.35).clamp(
                      150.0,
                      double.infinity,
                    ),
                    autoPlay: true,
                    viewportFraction: 1,
                    showIndicator: false,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentBanner = index;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 8),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: banners.asMap().entries.map((entry) {
                    return Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 4,
                      ),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentBanner == entry.key
                            ? AppColors.primary
                            : Colors.grey[300],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 20),

            GradientButton(
              text: "New Order",
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.newOrder);
              },
            ),
            const SizedBox(height: 20),

            Column(
              children: [
                for (var i = 0; i < _dashboardCards.length; i += 2)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: OrderCard(
                              title: _dashboardCards[i]['title'] ?? '',
                              subtitle: _dashboardCards[i]['subtitle'] ?? '',
                              iconPath: _dashboardCards[i]['iconPath'] ?? '',
                            ),
                          ),
                          const SizedBox(width: 12),
                          if (i + 1 < _dashboardCards.length)
                            Expanded(
                              child: OrderCard(
                                title: _dashboardCards[i + 1]['title'] ?? '',
                                subtitle:
                                    _dashboardCards[i + 1]['subtitle'] ?? '',
                                iconPath:
                                    _dashboardCards[i + 1]['iconPath'] ?? '',
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
