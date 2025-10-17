import 'package:cardio_tech/src/features/home/widgets/gradient_button.dart';
import 'package:cardio_tech/src/routes/AllRoutes.dart';
import 'package:flutter/material.dart';
import 'package:cardio_tech/src/features/home/widgets/theme.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AllPatient extends StatefulWidget {
  const AllPatient({super.key});

  @override
  State<AllPatient> createState() => _AllPatientState();
}

class _AllPatientState extends State<AllPatient> {
  final List<Map<String, String>> orders = [
    {
      "name": "Mrs. Amie Smith",
      "orderId": "789405",
      "doctor": "Dr. GP",
      "submitted": "04 May 2025 | 12:58 PM",
      "image": "assets/images/people/user.png",
    },
    {
      "name": "Mr. John Doe",
      "orderId": "654321",
      "doctor": "Dr. Anita Rao",
      "submitted": "06 May 2025 | 09:32 AM",
      "image": "assets/images/people/user2.png",
    },
    {
      "name": "Ms. Emma Johnson",
      "orderId": "789654",
      "doctor": "Dr. Sameer Khan",
      "submitted": "08 May 2025 | 03:15 PM",
      "image": "assets/images/people/user3.png",
    },
    {
      "name": "Mr. Rahul Sharma",
      "orderId": "321987",
      "doctor": "Dr. Priya Nair",
      "submitted": "10 May 2025 | 10:20 AM",
      "image": "assets/images/people/user4.png",
    },
    {
      "name": "Mrs. Sophia Lee",
      "orderId": "987456",
      "doctor": "Dr. Ramesh Patel",
      "submitted": "12 May 2025 | 05:45 PM",
      "image": "assets/images/people/user5.png",
    },
    {
      "name": "Mr. Michael Brown",
      "orderId": "741852",
      "doctor": "Dr. Kavita Singh",
      "submitted": "14 May 2025 | 08:10 PM",
      "image": "assets/images/people/user6.png",
    },
  ];

  String selectedStatus = "All Status";
  String selectedPriority = "All Priority";

  final List<String> statusList = [
    "All Status",
    "Pending",
    "In Progress",
    "Completed",
    "Cancelled",
  ];

  final List<String> priorityList = ["All Priority", "Low", "Medium", "High"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "All Patients",
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
            //  Search bar
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
                child: TextField(
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.grey,
                      size: 22,
                    ),
                    hintText: "Search by patient name",
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),

            //  Filter dropdowns with gradient borders
            Row(
              children: [
                Expanded(
                  child: GradientBorderDropdown(
                    value: selectedStatus,
                    items: statusList,
                    onChanged: (val) => setState(() => selectedStatus = val!),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GradientBorderDropdown(
                    value: selectedPriority,
                    items: priorityList,
                    onChanged: (val) => setState(() => selectedPriority = val!),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            //  Orders list
            Expanded(
              child: ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GradientBorderCard(order: order),
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
//  Reusable Gradient Border Dropdown
//
class GradientBorderDropdown extends StatelessWidget {
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const GradientBorderDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
          // begin: Alignment.topLeft,
          // end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.all(1.2),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            icon: SvgPicture.asset('assets/icon/arrow-down.svg'),
            items: items
                .map(
                  (item) => DropdownMenuItem(
                    value: item,
                    child: Text(
                      item,
                      style: TextStyle(fontSize: 14, color: AppColors.primary),
                    ),
                  ),
                )
                .toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}

//
//  Gradient Border Card for Patient Orders
//
class GradientBorderCard extends StatelessWidget {
  final Map<String, String> order;

  const GradientBorderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(1.5),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //  Top Row
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
                            Navigator.pushNamed(
                              context,
                              AppRoutes.orderDetails,
                            );
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
      ),
    );
  }
}
