import 'package:cardio_tech/src/features/generalPhysicianScreens/home/widgets/gradient_button.dart';
import 'package:cardio_tech/src/features/generalPhysicianScreens/home/widgets/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AllOrder extends StatefulWidget {
  const AllOrder({super.key});

  @override
  State<AllOrder> createState() => _AllOrderState();
}

class _AllOrderState extends State<AllOrder> {
  String searchText = "";
  String selectedStatus = "All Status";
  String selectedPriority = "All Priority";

  final List<String> statusList = [
    "All Status",
    "Pending",
    "In Progress",
    "Completed",
    "Cancelled",
  ];

  final List<String> priorityList = ["All Priority", "High", "Medium", "Low"];

  // Dummy static order data
  final List<Map<String, String>> allOrders = [
    {
      "image": "assets/images/people/user.png",

      "name": "Test Kumar",
      "orderId": "ORD123",
      "status": "Pending",
      "priority": "High",
      "submittedOn": "2025-11-03",
      "hospital": "Vedanta Multi Hospital",
      "seenBy": "Dr. Sharma",
    },
    {
      "image": "assets/images/people/user.png",

      "name": "Amit Sharma",
      "orderId": "ORD456",
      "status": "Completed",
      "priority": "Low",
      "submittedOn": "2025-11-02",
      "hospital": "City Care Hospital",
      "seenBy": "Dr. Mehta",
    },
    {
      "image": "assets/images/people/user.png",

      "name": "Priya Singh",
      "orderId": "ORD789",
      "status": "In Progress",
      "priority": "Medium",
      "submittedOn": "2025-11-01",
      "hospital": "Apollo Hospital",
      "seenBy": "Dr. Patel",
    },
    {
      "image": "assets/images/people/user.png",

      "name": "Rohit Verma",
      "orderId": "ORD999",
      "status": "Cancelled",
      "priority": "High",
      "submittedOn": "2025-10-29",
      "hospital": "Medicity Health Centre",
      "seenBy": "Dr. Kapoor",
    },
  ];

  List<Map<String, String>> filteredOrders = [];

  @override
  void initState() {
    super.initState();
    filteredOrders = List.from(allOrders);
  }

  void applyFilters() {
    setState(() {
      filteredOrders = allOrders.where((order) {
        final matchesSearch = order["name"]!.toLowerCase().contains(
          searchText.toLowerCase(),
        );
        final matchesStatus =
            selectedStatus == "All Status" || order["status"] == selectedStatus;
        final matchesPriority =
            selectedPriority == "All Priority" ||
            order["priority"] == selectedPriority;

        return matchesSearch && matchesStatus && matchesPriority;
      }).toList();
    });
  }

  void clearFilters() {
    setState(() {
      searchText = "";
      selectedStatus = "All Status";
      selectedPriority = "All Priority";
      filteredOrders = List.from(allOrders);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "All Orders",
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
            // 🔍 Search
            Container(
              margin: const EdgeInsets.only(top: 8, bottom: 12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
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
                  onChanged: (value) {
                    searchText = value;
                    applyFilters();
                  },
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey,
                      size: 22,
                    ),
                    hintText: "Search by patient name",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            //  Orders List
            Expanded(
              child: ListView.builder(
                itemCount: filteredOrders.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _TrackOrderCard(order: filteredOrders[index]),
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

/// --- Order Card ---
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
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icon/stethoscope.svg',
                          height: 14,
                        ),
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
                  // showModalBottomSheet(
                  //   context: context,
                  //   isScrollControlled: true,
                  //   shape: const RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.vertical(
                  //       top: Radius.circular(24),
                  //     ),
                  //   ),
                  //   builder: (context) => AssignCard(),
                  // );
                },
              ),
              const SizedBox(width: 8),
              GradientButton(
                height: 30,
                width: 90,
                text: 'Report',
                onPressed: () {
                  // Navigator.pushNamed(context, AppRoutes.reportOrder);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
