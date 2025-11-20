import 'package:cardio_tech/src/data/generalPhysician/models/all_patient/OrderFilterModel.dart';
import 'package:cardio_tech/src/features/generalPhysicianScreens/home/navbar/newOrder.dart';
import 'package:cardio_tech/src/features/generalPhysicianScreens/home/widgets/gradient_border_dropdown.dart';
import 'package:cardio_tech/src/features/generalPhysicianScreens/home/widgets/gradient_button.dart';
import 'package:cardio_tech/src/provider/generalPhysicianProvider/allPatient/orderFilterProvider.dart';
import 'package:cardio_tech/src/provider/generalPhysicianProvider/commons/allStatusProvider.dart';
import 'package:cardio_tech/src/provider/generalPhysicianProvider/new_order/order_priority_provider.dart';
import 'package:cardio_tech/src/routes/AllRoutes.dart';
import 'package:flutter/material.dart';
import 'package:cardio_tech/src/features/generalPhysicianScreens/home/widgets/theme.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class AllPatient extends StatefulWidget {
  const AllPatient({super.key});

  @override
  State<AllPatient> createState() => _AllPatientState();
}

class _AllPatientState extends State<AllPatient> {
  String searchText = "";
  String selectedStatus = "All Status";
  String selectedPriority = "All Priority";

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<OrderPriorityProvider>().fetchOrderPriorities();
      context.read<OrderFilterProvider>().fetchFilteredOrders();
      context.read<AllStatusProvider>().getAllStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final filterProvider = context.watch<OrderFilterProvider>();

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
            //  Search
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
                  onChanged: (value) {
                    searchText = value;
                    context.read<OrderFilterProvider>().applyFilters(
                      searchText: searchText,
                      selectedStatus: selectedStatus,
                      selectedPriority: selectedPriority,
                    );
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    prefixIcon: const Icon(
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

            //  Dropdown Filters
            Row(
              children: [
                Expanded(
                  child: Consumer<AllStatusProvider>(
                    builder: (context, statusProvider, _) {
                      if (statusProvider.isLoading) {
                        return const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        );
                      }
                      final statusList = [
                        "All Status",
                        ...statusProvider.statuses.map((s) => s.value),
                      ];

                      return GradientBorderDropdown(
                        value: selectedStatus,
                        items: statusList,
                        onChanged: (val) {
                          setState(() => selectedStatus = val!);
                          context.read<OrderFilterProvider>().applyFilters(
                            searchText: searchText,
                            selectedStatus: selectedStatus,
                            selectedPriority: selectedPriority,
                          );
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Consumer<OrderPriorityProvider>(
                    builder: (context, priorityProvider, _) {
                      if (priorityProvider.isLoading) {
                        return const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        );
                      }
                      final priorities = [
                        "All Priority",
                        ...priorityProvider.priorities.map(
                          (p) => p.priorityName,
                        ),
                      ];

                      return GradientBorderDropdown(
                        value: selectedPriority,
                        items: priorities,
                        onChanged: (val) {
                          setState(() => selectedPriority = val!);
                          context.read<OrderFilterProvider>().applyFilters(
                            searchText: searchText,
                            selectedStatus: selectedStatus,
                            selectedPriority: selectedPriority,
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Clear Filters
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  setState(() {
                    searchText = "";
                    selectedStatus = "All Status";
                    selectedPriority = "All Priority";
                  });
                  context.read<OrderFilterProvider>().clearFilters();
                },
                child: const Text("Clear Filters"),
              ),
            ),

            const SizedBox(height: 8),

            Expanded(
              child: Builder(
                builder: (context) {
                  if (filterProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (filterProvider.errorMessage != null) {
                    return Center(
                      child: Text(
                        "Error: ${filterProvider.errorMessage}",
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }
                  final orders = filterProvider.filteredOrders;
                  if (orders.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset('assets/icon/no_data.svg'),
                          const SizedBox(height: 20),
                          const Text(
                            "No patients found",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 20),
                          GradientButton(
                            width: 250,
                            text: "New Order",
                            onPressed: () async {
                              // Push to NewOrder screen and wait for a result
                              final result = await Navigator.pushNamed(
                                context,
                                AppRoutes.newOrder,
                              );

                              // Refresh data if a new order was successfully created
                              if (result == true && context.mounted) {
                                context
                                    .read<OrderFilterProvider>()
                                    .fetchFilteredOrders();
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: GradientBorderCard(order: order),
                      );
                    },
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

class GradientBorderCard extends StatelessWidget {
  final OrderFilterModel order;

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
            Row(
              children: [
                const CircleAvatar(
                  radius: 26,
                  backgroundImage: AssetImage('assets/images/people/user.png'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              order.patientName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 6),
                          if (order.priorityName == "High Priority")
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 5),

                      Row(
                        children: [
                          SvgPicture.asset('assets/icon/user.svg'),
                          const SizedBox(width: 4),
                          Text(
                            "Order ID: ${order.orderDetailsId}",
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),

                      Row(
                        children: [
                          SvgPicture.asset('assets/icon/status.svg'),
                          const SizedBox(width: 4),
                          Text(
                            "Status: ${order.orderStatus ?? 'N/A'}",
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Icon(Icons.more_vert, color: AppColors.primary),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Submitted on: ${order.createdAt ?? '--'}",
                    style: TextStyle(color: Colors.grey.shade700),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                if (order.orderStatus == "SUBMITTED" ||
                    order.orderStatus == "IN_PROGRESS" ||
                    order.orderStatus == "FINALIZED" ||
                    order.orderStatus == "IN_REVIEW" ||
                    order.orderStatus == "FINALIZED_VIEW")
                  SizedBox(
                    width: 110,
                    child: GradientButton(
                      height: 30,
                      width: 110,
                      text: order.orderStatus == "FINALIZED_VIEW"
                          ? "Order Closed"
                          : (order.orderStatus == "SUBMITTED" ||
                                order.orderStatus == "FINALIZED")
                          ? "Track Order"
                          : "Create Order",

                      // Disable action for FINALIZED_VIEW
                      onPressed: order.orderStatus == "FINALIZED_VIEW"
                          ? null
                          : () async {
                              if (order.orderStatus == "SUBMITTED" ||
                                  order.orderStatus == "FINALIZED") {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.orderDetails,
                                  arguments: order,
                                );
                              } else if (order.orderStatus == "IN_PROGRESS") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        NewOrder(orderId: order.orderDetailsId),
                                  ),
                                );
                              }
                            },
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
