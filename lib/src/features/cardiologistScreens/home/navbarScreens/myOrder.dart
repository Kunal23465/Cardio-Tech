import 'package:cardio_tech/src/data/cardioLogists/model/myOrderModel.dart';
import 'package:cardio_tech/src/features/cardiologistScreens/home/widgets/assignCard.dart';
import 'package:cardio_tech/src/features/generalPhysicianScreens/home/widgets/gradient_border_dropdown.dart';
import 'package:cardio_tech/src/features/generalPhysicianScreens/home/widgets/theme.dart';
import 'package:cardio_tech/src/features/widgets/orderDetailsCard.dart';
import 'package:cardio_tech/src/provider/cardioLogistsProvider/getAllStatusProvider.dart';
import 'package:cardio_tech/src/provider/cardioLogistsProvider/myOrderProvider.dart';
import 'package:cardio_tech/src/provider/cardioLogistsProvider/orderStatusProvider.dart';
import 'package:cardio_tech/src/provider/generalPhysicianProvider/new_order/order_priority_provider.dart';
import 'package:cardio_tech/src/routes/AllRoutes.dart';
import 'package:cardio_tech/src/utils/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyOrder extends StatefulWidget {
  const MyOrder({super.key});

  @override
  State<MyOrder> createState() => _MyOrderState();
}

class _MyOrderState extends State<MyOrder> {
  String selectedStatus = "All Status";
  String selectedPriority = "All Priority";

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<GetAllCardioStatusProvider>().getAllCardioStatus();
      context.read<OrderPriorityProvider>().fetchOrderPriorities();
      context.read<MyOrderProvider>().fetchAllOrders();
    });
  }

  void clearFilters() {
    setState(() {
      selectedStatus = "All Status";
      selectedPriority = "All Priority";
    });
    context.read<MyOrderProvider>().fetchAllOrders();
  }

  Future<void> _handleReport(BuildContext context, MyOrderModel order) async {
    final orderStatusProvider = context.read<OrderStatusProvider>();
    final myOrderProvider = context.read<MyOrderProvider>();

    // Update status if order is SUBMITTED
    if (order.orderStatus?.toUpperCase() == 'SUBMITTED') {
      final success = await orderStatusProvider.updateStatusToInReview(
        orderDetailsId: order.orderDetailsId,
        cardioPocId: order.approvalLevels?.first.approverPocId ?? 0,
      );

      if (success) {
        myOrderProvider.updateOrderStatus(order.orderDetailsId, 'IN_REVIEW');
      } else {
        SnackBarHelper.show(
          context,
          message: "Failed to update order status",
          type: SnackBarType.warning,
        );

        return;
      }
    }

    //  Navigate to ReportOrder and WAIT for the result
    final result = await Navigator.pushNamed(
      context,
      AppRoutes.reportOrder,
      arguments: {
        'orderId': order.orderDetailsId,
        'patientName': order.patientName,
        'clinicalNote': order.clinicalNote,
        'ekgReport': order.ekgReport,
        'approvalLevels': order.approvalLevels?.map((e) => e.toJson()).toList(),
      },
    );

    if (result == true) {
      await myOrderProvider.fetchAllOrders(); // Refresh  order list
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = context.watch<MyOrderProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "My Orders",
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
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      context.read<MyOrderProvider>().searchOrders(
                        patientName: value,
                      );
                    } else {
                      context.read<MyOrderProvider>().fetchAllOrders();
                    }
                  },
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey,
                      size: 22,
                    ),
                    hintText: "Search by Patient Name, Order ID",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),

            //  Status + Priority dropdowns
            Row(
              children: [
                Expanded(
                  child: Consumer<GetAllCardioStatusProvider>(
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
                          context.read<MyOrderProvider>().applyStatusFilter(
                            selectedStatus,
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
                          context.read<MyOrderProvider>().applyPriorityFilter(
                            selectedPriority,
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: clearFilters,
                child: const Text("Clear Filters"),
              ),
            ),

            const SizedBox(height: 8),

            // Orders List
            Expanded(
              child: orderProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : orderProvider.orders.isEmpty
                  ? const Center(child: Text("No orders found"))
                  : ListView.builder(
                      itemCount: orderProvider.orders.length,
                      itemBuilder: (context, index) {
                        final order = orderProvider.orders[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: OrderDetailsCard(
                            image: "assets/images/people/user.png",
                            name: order.patientName ?? "",
                            age: order.age?.toString() ?? "",
                            gender: order.genderValue,
                            orderId: order.orderDetailsId.toString(),
                            referredBy: order.createdByGpName ?? "N/A",
                            hospital: order.clinicName ?? "N/A",
                            priorityName: order.priorityName,
                            orderStatus: order.orderStatus,
                            submittedOn: order.createdAt ?? '',
                            onAssign: () async {
                              final result = await showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(24),
                                  ),
                                ),
                                builder: (context) => AssignCard(order: order),
                              );

                              if (result == true) {
                                await context
                                    .read<MyOrderProvider>()
                                    .fetchAllOrders();
                              }
                            },

                            onReport: () => _handleReport(context, order),
                            onUnderProgress: () =>
                                _handleReport(context, order),
                          ),
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
