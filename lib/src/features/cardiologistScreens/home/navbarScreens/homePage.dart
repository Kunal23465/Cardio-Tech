import 'package:cardio_tech/src/features/cardiologistScreens/home/widgets/assignCard.dart';
import 'package:cardio_tech/src/features/generalPhysicianScreens/home/widgets/DashboardCard.dart';
import 'package:cardio_tech/src/features/generalPhysicianScreens/home/widgets/gradient_button.dart';
import 'package:cardio_tech/src/routes/AllRoutes.dart';
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
      'subtitle': 'High Priority ',
      'iconPath': 'assets/images/homePage/dashboard/icon2.svg',
    },
    {
      'title': '75',
      'subtitle': 'Sign Off',
      'iconPath': 'assets/cardiologistsIcon/icon/other/icon1.svg',
    },
    {
      'title': '240',
      'subtitle': 'Total Orders Assigned',
      'iconPath': 'assets/images/homePage/dashboard/icon3.svg',
    },
    {
      'title': '180',
      'subtitle': 'Finalized Orders',
      'iconPath': 'assets/cardiologistsIcon/icon/other/icon2.svg',
    },
  ];

  final List<Map<String, String>> _orders = [
    {
      "image": "assets/images/people/user.png",
      "name": "John Doe",
      "orderId": "ORD12345",
      "seenBy": "Dr. Kunal Mishra",
      "submittedOn": "02 Nov 2025",
      "hospital": "Lucknow Hospital",
    },
    {
      "image": "assets/images/people/user.png",
      "name": "Priya Sharma",
      "orderId": "ORD12346",
      "seenBy": "Dr. Neha Kapoor",
      "submittedOn": "03 Nov 2025",
      "hospital": "Max Hospital",
    },
    {
      "image": "assets/images/people/user.png",
      "name": "Amit Verma",
      "orderId": "ORD12347",
      "seenBy": "Dr. Rakesh Singh",
      "submittedOn": "03 Nov 2025",
      "hospital": "Vedanta Multi Hospital",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
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
                            "Dr. Kunal Mishra ",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            "Alambagh, Lucknow, UP",
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
                  for (var i = 0; i < _dashboardCards.length; i += 2)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
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
                ],
              ),

              const SizedBox(height: 20),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Urgent Orders",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _orders.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _TrackOrderCard(order: _orders[index]),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TrackOrderCard extends StatelessWidget {
  final Map<String, String> order;

  const _TrackOrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8),
        ],
        border: Border.all(color: Colors.grey.shade300),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 26,
                backgroundImage: AssetImage(order["image"]!),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            order["name"]!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Icon(Icons.circle, color: Colors.red, size: 10),
                      ],
                    ),

                    const SizedBox(height: 5),
                    Row(
                      children: [
                        SvgPicture.asset('assets/icon/user.svg'),
                        const SizedBox(width: 4),
                        Text(
                          "Order Id : ${order["orderId"]}",
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        SvgPicture.asset('assets/icon/stethoscope.svg'),
                        const SizedBox(width: 4),
                        Text(
                          "Referred By ${order["seenBy"]}",
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        SvgPicture.asset('assets/icon/hospital.svg'),
                        const SizedBox(width: 4),
                        Text(
                          order["hospital"]!,
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              Expanded(
                child: Text(
                  "Submitted on : ${order["submittedOn"]}",
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              GradientButton(
                height: 30,
                width: 90,
                text: 'Assign',
                isOutlined: true,
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                    ),
                    builder: (context) => AssignCard(
                      hospitalName:
                          order["hospital"] ?? "Vedanta Multi Hospital",
                    ),
                  );
                },
              ),

              const SizedBox(width: 8),
              GradientButton(
                height: 30,
                width: 90,
                text: 'Report',
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.reportOrder);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
