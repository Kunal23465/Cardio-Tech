import 'package:cardio_tech/src/features/generalPhysicianScreens/home/widgets/gradient_border_dropdown.dart';
import 'package:cardio_tech/src/features/generalPhysicianScreens/home/widgets/gradient_button.dart';
import 'package:cardio_tech/src/routes/AllRoutes.dart';
import 'package:flutter/material.dart';
import 'package:cardio_tech/src/features/generalPhysicianScreens/home/widgets/theme.dart';
import 'package:flutter_svg/svg.dart';

class Trackorder extends StatefulWidget {
  const Trackorder({super.key});

  @override
  State<Trackorder> createState() => _TrackorderState();
}

class _TrackorderState extends State<Trackorder> {
  final List<String> statusList = ["All Status", "Submitted", "In Progress"];

  final List<String> priorityList = [
    "All Priority",

    "High Priority",
    "Routine Priority",
  ];

  String selectedStatus = "All Status";
  String selectedPriority = "All Priority";

  final List<Map<String, String>> orders = List.generate(
    6,
    (index) => {
      "name": "Mrs. Amie Smith",
      "orderId": "789405",
      "doctor": "DR. GP",
      "submitted": "04 May 2025 | 12:58 PM",
      "image": "assets/images/people/user.png",
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Track Order",
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(height: 1, color: AppColors.primary),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          children: [
            // 🔍 Search bar
            Container(
              margin: const EdgeInsets.only(top: 8, bottom: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.secondary],
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.all(1.5),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey,
                      size: 22,
                    ),
                    hintText: "Search by patient name",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),

            //  Status & Priority Filters
            Row(
              children: [
                Expanded(
                  child: GradientBorderDropdown(
                    value: selectedStatus,
                    items: statusList,
                    onChanged: (newValue) {
                      setState(() => selectedStatus = newValue!);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GradientBorderDropdown(
                    value: selectedPriority,
                    items: priorityList,
                    onChanged: (newValue) {
                      setState(() => selectedPriority = newValue!);
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // 📋 Orders List
            Expanded(
              child: ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: TrackOrderCard(order: order),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//
// 📦 Reusable Track Order Card
//
class TrackOrderCard extends StatelessWidget {
  final Map<String, String> order;

  const TrackOrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10),
        ],
        border: Border.all(color: Colors.grey.shade300),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 👤 Top Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    Text(
                      order["name"]!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        SvgPicture.asset('assets/icon/user.svg'),
                        const SizedBox(width: 4),
                        Text(
                          "Order Id : ${order["orderId"]}",
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        SvgPicture.asset('assets/icon/stethoscope.svg'),
                        const SizedBox(width: 4),
                        Text(
                          "Seen By ${order["doctor"]}",
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4, top: 4),
                child: Icon(Icons.more_vert, color: AppColors.primary),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Padding(
            padding: const EdgeInsets.only(left: 0, right: 4),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          "Submitted on : ${order["submitted"]}",
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      GradientButton(
                        height: 30,
                        width: 110,
                        text: 'Track Order',
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.orderDetails);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
